//
//  LLUploaderAppDotNetCredentials.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetCredentials.h"

static NSString * const _LLUploaderAppDotNetCredentialsUsernameKey = @"username";
static NSString * const _LLUploaderAppDotNetCredentialsOAuthTokenKey = @"OAuthToken";
static NSString * const _LLUploaderAppDotNetCredentialsOAuthSecretKey = @"OAuthSecret";

@implementation LLUploaderAppDotNetCredentials

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSMutableSet *keyPaths = [NSMutableSet setWithSet:[super keyPathsForValuesAffectingValueForKey:key]];
	
	if ([key isEqualToString:RMUploadCredentialsDirtyKey]) {
		[keyPaths addObject:_LLUploaderAppDotNetCredentialsUsernameKey];
		[keyPaths addObject:_LLUploaderAppDotNetCredentialsOAuthTokenKey];
		[keyPaths addObject:_LLUploaderAppDotNetCredentialsOAuthSecretKey];
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
	
	_OAuthToken = [[values objectForKey:_LLUploaderAppDotNetCredentialsOAuthTokenKey] copy];
	_OAuthSecret = [[values objectForKey:_LLUploaderAppDotNetCredentialsOAuthSecretKey] copy];
	
	return self;
}

- (void)dealloc
{
	[_username release];
	
	[_OAuthToken release];
	[_OAuthSecret release];
	
	[super dealloc];
}

- (id)propertyListRepresentation
{
	id superRepresentation = [super propertyListRepresentation];
	
	NSMutableDictionary *propertyListRepresentation = [NSMutableDictionary dictionary];
	[propertyListRepresentation setValue:superRepresentation forKey:@"super"];
	
	[propertyListRepresentation setValue:[self username] forKey:_LLUploaderAppDotNetCredentialsUsernameKey];
	
	[propertyListRepresentation setValue:[self OAuthToken] forKey:_LLUploaderAppDotNetCredentialsOAuthTokenKey];
	[propertyListRepresentation setValue:[self OAuthSecret] forKey:_LLUploaderAppDotNetCredentialsOAuthSecretKey];
	
	return propertyListRepresentation;
}

- (NSString *)userIdentifier
{
	return [self username];
}

@end
