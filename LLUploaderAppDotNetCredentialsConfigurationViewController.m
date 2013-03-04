//
//  LLUploaderAppDotNetCredentialsConfigurationViewController.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetCredentialsConfigurationViewController.h"

#import "LLUploaderAppDotNetCredentials.h"

#import "LLAppDotNet-Constants.h"

static NSString * const _LLUploaderAppDotNetCredentialsConfigurationViewControllerAuthenticatingKey = @"authenticating";
static NSString * const _LLUploaderAppDotNetCredentialsConfigurationViewControllerAuthenticationConnectionKey = @"authenticationConnection";

@interface LLUploaderAppDotNetCredentialsConfigurationViewController (/* User interface */)

@property (assign, nonatomic) IBOutlet NSTextField *usernameTextField;
@property (assign, nonatomic) IBOutlet NSSecureTextField *passwordTextField;

@end

@interface LLUploaderAppDotNetCredentialsConfigurationViewController (/* Private */)

@property (readwrite, nonatomic) BOOL authenticating;

@property (strong, nonatomic) NSURLConnection *authenticationConnection;

@end

@implementation LLUploaderAppDotNetCredentialsConfigurationViewController

@dynamic representedObject;

- (id)init
{
	return [self initWithNibName:@"LLUploaderAppDotNetCredentialsConfigurationView" bundle:[NSBundle bundleWithIdentifier:LLAppDotNetBundleIdentifier]];
}

- (void)dealloc
{
	[_password release];
	[_authenticationConnection release];
	
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[[[self view] window] makeFirstResponder:[self usernameTextField]];
	
	NSString *username = [[self representedObject] username];
	if ([username length] > 0) {
		[[[self view] window] makeFirstResponder:[self passwordTextField]];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - KVO

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSMutableSet *keyPaths = [NSMutableSet setWithSet:[super keyPathsForValuesAffectingValueForKey:key]];
	
	if ([key isEqualToString:_LLUploaderAppDotNetCredentialsConfigurationViewControllerAuthenticatingKey]) {
		[keyPaths addObject:_LLUploaderAppDotNetCredentialsConfigurationViewControllerAuthenticationConnectionKey];
	}
	
	return keyPaths;
}

#pragma mark - Properties

- (BOOL)isAuthenticating
{
	return ([self authenticationConnection] != nil);
}

#pragma mark - Actions

- (IBAction)stopConfiguration:(id)sender
{
	[super stopConfiguration:sender];
	
	[[self authenticationConnection] cancel];
	[self setAuthenticationConnection:nil];
}

- (IBAction)nextStage:(id)sender {
	BOOL (^validateTextField)(NSTextField *) = ^ (NSTextField *field) {
		[field validateEditing];
		if ([field stringValue] != nil && [[field stringValue] length] > 0) {
			return YES;
		}
		
		[self highlightErrorInView:field];
		
		NSDictionary *validationNotificationInfo = [NSDictionary dictionaryWithObjectsAndKeys:
													[NSError errorWithDomain:RMUploadKitBundleIdentifier code:RMUploadPresetConfigurationViewControllerErrorValidation userInfo:nil], RMUploadPresetConfigurationViewControllerDidCompleteErrorKey,
													nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadPresetConfigurationViewControllerDidCompleteNotificationName object:self userInfo:validationNotificationInfo];
		
		return NO;
	};
	
	if (!validateTextField([self usernameTextField])) {
		return;
	}
	NSString *username = [[self usernameTextField] stringValue];
	
	if (!validateTextField([self passwordTextField])) {
		return;
	}
	NSString *password = [[self passwordTextField] stringValue];
	
	RMTumblrContext *context = [[[RMTumblrContext alloc] init] autorelease];
	[RMUploaderTumblr authenticateContext:context withCredentials:nil];
	NSURLRequest *authenticateRequest = [context requestOAuthTokenCredentialsWithUsername:username password:password];
	
	[self setAuthenticationConnection:[RMUploadURLConnection _connectionWithRequest: authenticateRequest responseProviderBlock: ^ (_RMUploadURLConnectionResponseProviderBlock responseProvider) {
		[self setAuthenticationConnection:nil];
		
		NSString *OAuthToken = nil, *OAuthSecret = nil;
		
		NSError *parseAuthenticationResponseError = nil;
		BOOL parseAuthenticationResponse = [RMTumblrContext parseAuthenticationResponseWithProvider:responseProvider OAuthToken:&OAuthToken OAuthSecret:&OAuthSecret error:&parseAuthenticationResponseError];
		if (!parseAuthenticationResponse) {
			[self _failWithError:parseAuthenticationResponseError];
			return;
		}
		
		[(RMUploaderTumblrCredentials *)[self representedObject] setOAuthToken:OAuthToken];
		[(RMUploaderTumblrCredentials *)[self representedObject] setOAuthSecret:OAuthSecret];
		
		[super nextStage:sender];
	}]];
}

@end
