//
//  LLUploaderAppDotNetCredentials.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetCredentials.h"

static NSString * const _LLUploaderAppDotNetCredentialsUsernameKey = @"username";
static NSString * const _LLUploaderAppDotNetCredentialsAccessTokenKey = @"accessToken";

@implementation LLUploaderAppDotNetCredentials

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSMutableSet *keyPaths = [NSMutableSet setWithSet:[super keyPathsForValuesAffectingValueForKey:key]];
	
	if ([key isEqualToString:RMUploadCredentialsDirtyKey]) {
		[keyPaths addObject:_LLUploaderAppDotNetCredentialsUsernameKey];
		[keyPaths addObject:_LLUploaderAppDotNetCredentialsAccessTokenKey];
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
	_accessToken = [[values objectForKey:_LLUploaderAppDotNetCredentialsAccessTokenKey] copy];
	
	return self;
}

- (void)dealloc
{
	[_username release];
	[_accessToken release];
	
	[super dealloc];
}

- (id)propertyListRepresentation
{
	id superRepresentation = [super propertyListRepresentation];
	
	NSMutableDictionary *propertyListRepresentation = [NSMutableDictionary dictionary];
	[propertyListRepresentation setValue:superRepresentation forKey:@"super"];
	
	[propertyListRepresentation setValue:[self username] forKey:_LLUploaderAppDotNetCredentialsUsernameKey];
	[propertyListRepresentation setValue:[self accessToken] forKey:_LLUploaderAppDotNetCredentialsAccessTokenKey];
	
	return propertyListRepresentation;
}

- (NSString *)userIdentifier
{
	return [self username];
}

@end
