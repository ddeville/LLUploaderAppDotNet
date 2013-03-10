//
//  LLUploaderAppDotNetCredentialsConfigurationViewController.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetCredentialsConfigurationViewController.h"

#import <objc/message.h>

#import "RMFoundation/RMFoundation.h"
#import "RMUploadKit/RMUploadKit+Private.h"

#import "LLUploaderAppDotNet.h"
#import "LLUploaderAppDotNetCredentials.h"
#import "LLAppDotNetContext.h"

#import "LLUploaderAppDotNet-Constants.h"

static NSString * const _LLUploaderAppDotNetCredentialsConfigurationViewControllerAuthenticatingKey = @"authenticating";
static NSString * const _LLUploaderAppDotNetCredentialsConfigurationViewControllerAuthenticationConnectionKey = @"authenticationConnection";

@interface LLUploaderAppDotNetCredentialsConfigurationViewController (/* Private */)

@property (readwrite, assign, nonatomic) BOOL authenticating;

@property (retain, nonatomic) RMUploadURLConnection *authenticationConnection;

@end

@implementation LLUploaderAppDotNetCredentialsConfigurationViewController

@dynamic representedObject;

- (id)init
{
	return [self initWithNibName:@"LLUploaderAppDotNetCredentialsConfigurationView" bundle:[NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier]];
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

- (IBAction)nextStage:(id)sender
{
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
		[[[self view] window] makeFirstResponder:[self usernameTextField]];
		return;
	}
	NSString *username = [[self usernameTextField] stringValue];
	
	if (!validateTextField([self passwordTextField])) {
		[[[self view] window] makeFirstResponder:[self passwordTextField]];
		return;
	}
	NSString *password = [[self passwordTextField] stringValue];
	
	LLAppDotNetContext *context = [[[LLAppDotNetContext alloc] init] autorelease];
	[LLUploaderAppDotNet authenticateContext:context withCredentials:nil error:NULL];
	
	NSURLRequest *authenticationRequest = [context requestOAuthTokenCredentialsWithUsername:username password:password];
	
	[self setAuthenticationConnection:[RMUploadURLConnection _connectionWithRequest:authenticationRequest responseProviderBlock:^ void (LLAppDotNetResponseProvider responseProvider) {
		[self setAuthenticationConnection:nil];
		
		NSString *authenticationUsername = nil;
		NSError *parseAuthenticationResponseError = nil;
		NSString *accessToken = [LLAppDotNetContext parseAuthenticationResponseWithProvider:responseProvider username:&authenticationUsername error:&parseAuthenticationResponseError];
		if (accessToken == nil) {
			[self _failWithError:parseAuthenticationResponseError];
			return;
		}
		
		[[self representedObject] setUsername:(authenticationUsername ? : username)];
		
		NSError *saveAccessTokenError = nil;
		BOOL saveAccessToken = [LLUploaderAppDotNetCredentials setAccessToken:accessToken forCredentials:[self representedObject] error:&saveAccessTokenError];
		if (!saveAccessToken) {
			[self _failWithError:saveAccessTokenError];
			return;
		}
		
		[super nextStage:sender];
	}]];
}

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
	if ([notification object] != [self usernameTextField]) {
		return;
	}
	
	NSString *username = [[self usernameTextField] stringValue];
	if ([username length] == 0) {
		return;
	}
	
	NSString *password = [LLUploaderAppDotNetCredentials findInternetPasswordForUsername:username error:NULL];
	if (password != nil) {
		[[self passwordTextField] setStringValue:password];
	}
}

#pragma mark - Private

- (void)_failWithError:(NSError *)error
{
	if ([[error domain] isEqualToString:LLUploaderAppDotNetErrorDomain] && [error code] == LLUploaderAppDotNetErrorCodeInvalidCredentials) {
		RMErrorRecoveryAttempter *recoveryAttempter = [[[RMErrorRecoveryAttempter alloc] init] autorelease];
		[recoveryAttempter addRecoveryOptionWithLocalizedTitle:NSLocalizedStringFromTableInBundle(@"Sign In", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetCredentialsViewController blank password sign in error recovery suggestion") recoveryBlock:^ (NSError *recoveryError) {
			NSError *signInError = [NSError errorWithDomain:RMUploadKitBundleIdentifier code:RMUploadCredentialsErrorRequiresReauthentication userInfo:nil];
			
			NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjectsAndKeys:
											  signInError, RMUploadPresetConfigurationViewControllerDidCompleteErrorKey,
											  nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadPresetConfigurationViewControllerDidCompleteNotificationName object:self userInfo:notificationInfo];
			return NO;
		}];
		[recoveryAttempter addRecoveryOptionWithLocalizedTitle:NSLocalizedStringFromTableInBundle(@"Cancel", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetCredentialsViewController blank password close error recovery suggestion") recoveryBlock:^ (NSError *recoveryError) {
			NSError *cancelledError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
			
			NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjectsAndKeys:
											  cancelledError, RMUploadPresetConfigurationViewControllerDidCompleteErrorKey,
											  nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadPresetConfigurationViewControllerDidCompleteNotificationName object:self userInfo:notificationInfo];
			return NO;
		}];
		
		NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								   [error localizedDescription], NSLocalizedDescriptionKey,
								   [error localizedRecoverySuggestion], NSLocalizedRecoverySuggestionErrorKey,
								   recoveryAttempter, NSRecoveryAttempterErrorKey,
								   [recoveryAttempter recoveryOptions], NSLocalizedRecoveryOptionsErrorKey,
								   error, NSUnderlyingErrorKey,
								   nil];
		error = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetUnknownError userInfo:errorInfo];
	}
	
	NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjectsAndKeys:
									  error, RMUploadPresetConfigurationViewControllerDidCompleteErrorKey,
									  nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadPresetConfigurationViewControllerDidCompleteNotificationName object:self userInfo:notificationInfo];
}

@end
