//
//  LLUploaderAppDotNetPresetConfigurationViewController.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetPresetConfigurationViewController.h"

#import "RMFoundation/RMFoundation.h"
#import "RMUploadKit/RMUploadKit.h"
#import "RMUploadKit/RMUploadKit+Private.h"

#import "LLUploaderAppDotNet.h"
#import "LLUploaderAppDotNetPreset.h"
#import "LLUploaderAppDotNetCredentials.h"
#import "LLAppDotNetContext.h"

#import "LLUploaderAppDotNet-Constants.h"

@interface LLUploaderAppDotNetPresetConfigurationViewController ()

@property (retain, nonatomic) LLAppDotNetContext *context;

@property (retain, nonatomic) RMUploadURLConnection *userConnection;

@end

@implementation LLUploaderAppDotNetPresetConfigurationViewController

@dynamic representedObject;

- (id)init
{
	return [self initWithNibName:@"LLUploaderAppDotNetPresetConfigurationView" bundle:[NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier]];
}

- (void)dealloc
{
	[_context release];
	[_userConnection release];
	
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	
	NSError *keychainItemError = nil;
	id keychainItem = [LLUploaderAppDotNetCredentials accessTokenForCredentials:[[self representedObject] authentication] error:&keychainItemError];
	if (keychainItem == nil) {
		[self _postCompletionNotificationWithError:keychainItemError];
		return;
	}
	
	LLAppDotNetContext *context = [[[LLAppDotNetContext alloc] init] autorelease];
	[LLUploaderAppDotNet authenticateContext:context withCredentials:[[self representedObject] authentication] error:NULL];
	[self setContext:context];
	
	[self _loadUserProfile];
}

#pragma mark - Actions

- (IBAction)privacySelectionChanged:(id)sender
{
	LLUploaderAppDotNetPresetPrivacy privacy = [[[self privacyPopupButton] selectedItem] tag];
	[[self representedObject] setPrivacy:privacy];
}

#pragma mark - Private

- (void)_loadUserProfile
{
	[self setUserConnection:[RMUploadURLConnection _connectionWithRequest:[[self context] requestCurrentUserInformation] responseProviderBlock:^ void (LLAppDotNetResponseProvider responseProvider) {
		[self setUserConnection:nil];
		
		NSError *usernameParsingError = nil;
		NSString *username = [LLAppDotNetContext parseUserResponseWithProvider:responseProvider error:&usernameParsingError];
		if (username == nil) {
			NSString *domain = [usernameParsingError domain];
			NSInteger code = [usernameParsingError code];
			
			if (([domain isEqualToString:LLUploaderAppDotNetErrorDomain] && code == LLUploaderAppDotNetErrorCodeInvalidCredentials) || ([domain isEqualToString:LLUploaderAppDotNetErrorDomain] && code == LLUploaderAppDotNetErrorCodeKeychain)) {
				[self _postCompletionNotificationWithError:usernameParsingError];
				return;
			}
		}
		
		[self _refreshPrivacyMenu];
	}]];
}

- (void)_refreshPrivacyMenu
{
	NSMenu *privacyMenu = [[[NSMenu alloc] init] autorelease];
	
	NSMenuItem *publicMenuItem = [[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Public", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetPresetConfigurationViewController privacy menu public item title") action:NULL keyEquivalent:@""] autorelease];
	[publicMenuItem setTag:LLUploaderAppDotNetPresetPrivacyPublic];
	[privacyMenu addItem:publicMenuItem];
	
	NSMenuItem *privateMenuItem = [[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Private", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetPresetConfigurationViewController privacy menu private item title") action:NULL keyEquivalent:@""] autorelease];
	[privateMenuItem setTag:LLUploaderAppDotNetPresetPrivacyPrivate];
	[privacyMenu addItem:privateMenuItem];
	
	[[self privacyPopupButton] setMenu:privacyMenu];
	
	if ([[self privacyPopupButton] indexOfItemWithTag:[[self representedObject] privacy]] == -1) {
		[[self privacyPopupButton] selectItemWithTag:LLUploaderAppDotNetPresetPrivacyPublic];
	}
	
	[[self privacyPopupButton] setEnabled:YES];
}

- (void)_postCompletionNotificationWithError:(NSError *)error
{
	NSString *domain = [error domain];
	NSInteger code = [error code];
	
	if (([domain isEqualToString:LLUploaderAppDotNetErrorDomain] && code == LLUploaderAppDotNetErrorCodeInvalidCredentials) || ([domain isEqualToString:LLUploaderAppDotNetErrorDomain] && code == LLUploaderAppDotNetErrorCodeKeychain)) {
		RMErrorRecoveryAttempter *recoveryAttempter = [[[RMErrorRecoveryAttempter alloc] init] autorelease];
		
		[recoveryAttempter addRecoveryOptionWithLocalizedTitle:NSLocalizedStringFromTableInBundle(@"Sign In", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetPresetConfigurationViewController sign in non existing credentials error recovery suggestion") recoveryBlock:^ BOOL (NSError *error) {
			NSDictionary *notificationInfo = @{RMUploadPresetConfigurationViewControllerDidCompleteErrorKey : [NSError errorWithDomain:RMUploadKitBundleIdentifier code:RMUploadCredentialsErrorRequiresReauthentication userInfo:nil]};
			[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadPresetConfigurationViewControllerDidCompleteNotificationName object:self userInfo:notificationInfo];
			return NO;
		}];
		
		[recoveryAttempter addRecoveryOptionWithLocalizedTitle:NSLocalizedStringFromTableInBundle(@"Cancel", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetPresetConfigurationViewController close non existing credentials error recovery suggestion") recoveryBlock:^ BOOL (NSError *error) {
			NSDictionary *notificationInfo = @{RMUploadPresetConfigurationViewControllerDidCompleteErrorKey : [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]};
			[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadPresetConfigurationViewControllerDidCompleteNotificationName object:self userInfo:notificationInfo];
			return NO;
		}];
		
		NSDictionary *errorInfo = @{
			NSLocalizedDescriptionKey : [error localizedDescription],
			NSLocalizedRecoverySuggestionErrorKey : [error localizedRecoverySuggestion],
			NSRecoveryAttempterErrorKey : recoveryAttempter,
			NSLocalizedRecoveryOptionsErrorKey : [recoveryAttempter recoveryOptions],
			NSUnderlyingErrorKey : error,
		};
		
		error = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetUnknownError userInfo:errorInfo];
	}
	
	NSDictionary *notificationInfo = @{RMUploadPresetConfigurationViewControllerDidCompleteErrorKey : error};
	[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadPresetConfigurationViewControllerDidCompleteNotificationName object:self userInfo:notificationInfo];
}

@end
