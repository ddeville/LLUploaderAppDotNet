//
//  LLUploaderAppDotNetCredentialsConfigurationViewController.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetCredentialsConfigurationViewController.h"

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

#pragma mark - Actions

- (IBAction)nextStage:(id)sender
{
	
}

@end
