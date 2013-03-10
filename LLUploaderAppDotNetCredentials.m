//
//  LLUploaderAppDotNetCredentials.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetCredentials.h"

#import "RMFoundation/RMFoundation.h"

#import "LLUploaderAppDotNet-Constants.h"

static NSString * const _LLUploaderAppDotNetCredentialsUsernameKey = @"username";

@implementation LLUploaderAppDotNetCredentials

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSMutableSet *keyPaths = [NSMutableSet setWithSet:[super keyPathsForValuesAffectingValueForKey:key]];
	
	if ([key isEqualToString:RMUploadCredentialsDirtyKey]) {
		[keyPaths addObject:_LLUploaderAppDotNetCredentialsUsernameKey];
	}
	else if ([key isEqualToString:RMUploadCredentialsUserIdentifierKey]) {
		[keyPaths addObject:_LLUploaderAppDotNetCredentialsUsernameKey];
	}
	
	return keyPaths;
}

- (id)initWithPropertyListRepresentation:(id)values
{
	id superRepresentation = [values objectForKey:@"super"];
	self = [super initWithPropertyListRepresentation:superRepresentation];
	if (self == nil) {
		return nil;
	}
	
	_username = [[values objectForKey:_LLUploaderAppDotNetCredentialsUsernameKey] copy];
	
	return self;
}

- (void)dealloc
{
	[_username release];
	
	[super dealloc];
}

- (id)propertyListRepresentation
{
	id superRepresentation = [super propertyListRepresentation];
	
	NSMutableDictionary *propertyListRepresentation = [NSMutableDictionary dictionary];
	[propertyListRepresentation setValue:superRepresentation forKey:@"super"];
	
	[propertyListRepresentation setValue:[self username] forKey:_LLUploaderAppDotNetCredentialsUsernameKey];
	
	return propertyListRepresentation;
}

- (NSString *)userIdentifier
{
	return [self username];
}

#pragma mark - Keychain

static inline NSString *_LLUploaderAppDotNetOAuthServiceName(void) {
	return [LLUploaderAppDotNetBundleIdentifier stringByAppendingKeyPath:@"oauth-access-token"];
}

+ (NSString *)accessTokenForCredentials:(LLUploaderAppDotNetCredentials *)credentials error:(NSError **)errorRef
{
	RMGenericKeychainItem *keychainItem = [self _findKeychainItemForUsername:[credentials username] serviceName:_LLUploaderAppDotNetOAuthServiceName() includePassword:YES error:errorRef];
	if (keychainItem == nil) {
		return nil;
	}
	return [keychainItem password];
}

+ (BOOL)setAccessToken:(NSString *)accessToken forCredentials:(LLUploaderAppDotNetCredentials *)credentials error:(NSError **)errorRef
{
	NSParameterAssert([credentials username] != nil);
	
	NSString *username = [credentials username];
	
	void (^returnError)(NSError *) = ^ void (NSError *underlyingError) {
		if (errorRef != NULL) {
			NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											  NSLocalizedStringFromTableInBundle(@"Couldn\u2019t sign in to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetCredentials write keychain error description"), NSLocalizedDescriptionKey,
											  NSLocalizedStringFromTableInBundle(@"Your Keychain could not be opened to save your access token, please try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetCredentials write keychain access denied error recovery suggestion"), NSLocalizedRecoverySuggestionErrorKey,
											  nil];
			[errorInfo setValue:underlyingError forKey:NSUnderlyingErrorKey];
			*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetErrorCodeKeychain userInfo:errorInfo];
		}
	};
	
	NSError *keychainItemError = nil;
	RMGenericKeychainItem *keychainItem = [self _findKeychainItemForUsername:username serviceName:_LLUploaderAppDotNetOAuthServiceName() includePassword:NO error:&keychainItemError];
	if (keychainItem == nil) {
		NSError *underlyingError = [[keychainItemError userInfo] objectForKey:NSUnderlyingErrorKey];
		if (![[underlyingError domain] isEqualToString:RMFoundationBundleIdentifier] || [underlyingError code] != RMKeychainItemErrorCodeItemNotFound) {
			returnError(keychainItemError);
			return NO;
		}
		
		RMGenericKeychainItem *newKeychainItem = [self _makeKeychainItemWithUsername:username accessToken:accessToken];
		
		NSError *saveError = nil;
		BOOL save = [newKeychainItem addItemToKeychain:&saveError];
		if (!save) {
			returnError(saveError);
			return NO;
		}
		
		return YES;
	}
	
	[keychainItem setPassword:accessToken];
	
	NSError *updateError = nil;
	BOOL update = [keychainItem updateItemInKeychain:&updateError];
	if (!update) {
		returnError(updateError);
		return NO;
	}
	
	return YES;
}

+ (RMGenericKeychainItem *)_makeKeychainItemWithUsername:(NSString *)username accessToken:(NSString *)accessToken
{
	return [RMGenericKeychainItem keychainItemWithUsername:username password:accessToken label:nil serviceName:_LLUploaderAppDotNetOAuthServiceName()];
}

+ (RMGenericKeychainItem *)_findKeychainItemForUsername:(NSString *)username serviceName:(NSString *)serviceName includePassword:(BOOL)includePassword error:(NSError **)errorRef
{
	void (^returnFindKeychainItemError)(NSError *) = ^ void (NSError *underlyingError) {
		if (errorRef != NULL) {
			NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											  NSLocalizedStringFromTableInBundle(@"Couldn\u2019t sign in to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetCredentials read keychain access denied error description"), NSLocalizedDescriptionKey,
											  NSLocalizedStringFromTableInBundle(@"Your access token could not be found in your Keychain, please sign in and try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetCredentials read keychain access denied error recovery suggestion"), NSLocalizedRecoverySuggestionErrorKey,
											  nil];
			[errorInfo setValue:underlyingError forKey:NSUnderlyingErrorKey];
			*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetErrorCodeKeychain userInfo:errorInfo];
		}
	};
	
	if (username == nil) {
		returnFindKeychainItemError(nil);
		return nil;
	}
	
	RMGenericKeychainItem *keychainItem = [RMGenericKeychainItem findKeychainItemForUsername:username serviceName:serviceName];
	
	NSError *refreshItemError = nil;
	BOOL refreshItem = [keychainItem refreshItemFromKeychainIncludePassword:includePassword error:&refreshItemError];
	if (!refreshItem) {
		returnFindKeychainItemError(refreshItemError);
		return nil;
	}
	
	return keychainItem;
}

#pragma mark - Internet password

+ (NSString *)findInternetPasswordForUsername:(NSString *)username error:(NSError **)errorRef
{
	NSString * (^findPasswordForServer)(NSString *) = ^ NSString * (NSString *server) {
		RMInternetKeychainItem *keychainItem = [RMInternetKeychainItem findKeychainItemForUsername:username server:@"alpha.app.net" path:nil port:0 protocol:RMInternetKeychainItemProtocolHTTPS];
		if (keychainItem == nil) {
			if (errorRef != NULL) {
				NSDictionary *userInfo = @{
					NSLocalizedDescriptionKey : NSLocalizedStringFromTableInBundle(@"Couldn\u2019t find a matching username in the keychain", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetCredentials keychain item not found error description"),
					NSLocalizedRecoverySuggestionErrorKey : NSLocalizedStringFromTableInBundle(@"No matching username could be found for this service in your keychain.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLUploaderAppDotNetCredentials keychain item not found error recovery suggestion"),
				};
				*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetUnknownError userInfo:userInfo];
			}
			return nil;
		}
		BOOL refreshed = [keychainItem refreshItemFromKeychainIncludePassword:YES error:errorRef];
		if (!refreshed) {
			return nil;
		}
		return [keychainItem password];
	};
	
	NSArray *servers = @[@"alpha.app.net", @"account.app.net"];
	for (NSString *server in servers) {
		NSString *password = findPasswordForServer(server);
		if (password == nil) {
			continue;
		}
		return password;
	}
	
	return nil;
}

@end
