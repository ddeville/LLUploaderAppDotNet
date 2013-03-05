//
//  LLAppDotNetContext.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLAppDotNetContext.h"

#import "RMUploadKit/RMUploadKit+Private.h"

#import "LLUploaderAppDotNet-Constants.h"

@interface LLAppDotNetContext ()

@property (copy, nonatomic) NSString *clientID, *passwordGrantSecret;
@property (copy, nonatomic) NSString *username, *accessToken;

@end

@implementation LLAppDotNetContext

- (void)dealloc
{
	[_clientID release];
	[_passwordGrantSecret release];
	
	[_username release];
	[_accessToken release];
	
	[super dealloc];
}

#pragma mark - Context authentication

- (void)authenticateWithClientID:(NSString *)clientID passwordGrantSecret:(NSString *)passwordGrantSecret
{
	NSParameterAssert(clientID != nil);
	NSParameterAssert(passwordGrantSecret != nil);
	
	[self setClientID:clientID];
	[self setPasswordGrantSecret:passwordGrantSecret];
}

- (void)authenticateWithUsername:(NSString *)username accessToken:(NSString *)accessToken;
{
	[self setUsername:username];
	[self setAccessToken:accessToken];
}

#pragma mark - Authentication

- (NSURLRequest *)requestOAuthTokenCredentialsWithUsername:(NSString *)username password:(NSString *)password
{
	NSParameterAssert(username != nil);
	NSParameterAssert(password != nil);
	
	NSParameterAssert([self _checkHasOAuthClientAuthentication]);
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setURL:[NSURL URLWithString:@"https://alpha.app.net/oauth/access_token"]];
	
	NSDictionary *parameters = @{
		@"grant_type" : @"password",
		@"scrope" : @"basic",
		@"client_id" : [self clientID],
		@"password_grant_secret" : [self passwordGrantSecret],
		@"username" : username,
		@"password" : password,
	};
	[self _addBodyParameters:parameters toRequest:request];
	
//	[self _addOAuthAuthenticationToRequest:request];
	
	return request;
}

+ (NSString *)parseAuthenticationResponseWithProvider:(_RMUploadURLConnectionResponseProviderBlock)responseProvider username:(NSString **)username error:(NSError **)errorRef
{
	NSParameterAssert(username != nil);
	
	NSURLResponse *response = nil;
	NSData *bodyData = responseProvider(&response, errorRef);
	if (bodyData == nil) {
		return nil;
	}
	
//	if (![self _checkResponse:response bodyData:bodyData errorDescription:CannotSigninToTumblrErrorDescription() supplementaryErrorRecoverySuggestions:[self _authenticationResponseSupplementaryErrorRecoverySuggestionsMap] error:errorRef]) {
//		return NO;
//	}
	
	void (^returnUnexpectedError)(NSString *, NSError *) = ^ (NSString *description, NSError *underlyingError) {
		if (errorRef != NULL) {
			description = description ? : NSLocalizedStringFromTableInBundle(@"Couldn\u2019t sign in to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected authentication error description");
			NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											  description, NSLocalizedDescriptionKey,
											  RMLocalizedStringFromTableInBundle(@"An unexpected error occurred while signing in to App.net, please double check your username and password, and try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected authentication error recovery suggestion"), NSLocalizedRecoverySuggestionErrorKey,
											  nil];
			[errorInfo setValue:underlyingError forKey:NSUnderlyingErrorKey];
			*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetUnknownError userInfo:errorInfo];
		}
	};
	
	if ([bodyData length] == 0) {
		returnUnexpectedError(nil, nil);
		return nil;
	}
	
	NSError *deserializationError = nil;
	id responseJSON = [NSJSONSerialization JSONObjectWithData:bodyData options:(NSJSONReadingOptions)0 error:&deserializationError];
	if (responseJSON == nil) {
		returnUnexpectedError(nil, deserializationError);
		return nil;
	}
	
	if (![responseJSON isKindOfClass:[NSDictionary class]]) {
		returnUnexpectedError(nil, nil);
		return nil;
	}
	
	NSString *accessToken = [responseJSON objectForKey:@"access_token"];
	if (accessToken == nil) {
		NSString *errorDescription = [responseJSON objectForKey:@"error"];
		returnUnexpectedError(errorDescription, nil);
		return nil;
	}
	
	*username = [responseJSON objectForKey:@"username"];
	
	return accessToken;
}

#pragma mark - Private

- (BOOL)_checkHasOAuthClientAuthentication
{
	BOOL hasOAuthClientAuthentication = YES;
	if (hasOAuthClientAuthentication) {
		hasOAuthClientAuthentication = ([self clientID] != nil);
	}
	if (hasOAuthClientAuthentication) {
		hasOAuthClientAuthentication = ([self passwordGrantSecret] != nil);
	}
	return hasOAuthClientAuthentication;
}

static NSString * const _LLAppDotNetContextApplicationFormURLEncodedMIMEType = @"application/x-www-form-urlencoded";

- (void)_addBodyParameters:(NSDictionary *)parameters toRequest:(NSMutableURLRequest *)request
{
	NSString *bodyString = [self _encodeParameters:parameters];
	NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
	
	[request setValue:_LLAppDotNetContextApplicationFormURLEncodedMIMEType forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:bodyData];
}

- (NSString *)_encodeParameters:(NSDictionary *)parameters
{
	NSMutableArray *parameterPairs = [NSMutableArray arrayWithCapacity:[parameters count]];
	
	[parameters enumerateKeysAndObjectsUsingBlock:^ (id key, id obj, BOOL *stop) {
		NSMutableString *parameter = [NSMutableString string];
		[parameter appendString:_RMUploadURLEncodeString(key)];
		[parameter appendString:@"="];
		
		if ([obj isKindOfClass:[NSNull class]]) {
			// nop
		}
		else if ([obj isKindOfClass:[NSString class]]) {
			[parameter appendString:_RMUploadURLEncodeString(obj)];
		}
		else if ([obj isKindOfClass:[NSData class]]) {
			[parameter appendString:[[[NSString alloc] initWithData:_RMUploadURLEncodeData(obj) encoding:NSASCIIStringEncoding] autorelease]];
		}
		else {
			@throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s, unknown object class (%@)", __PRETTY_FUNCTION__, [obj class]] userInfo:nil];
			return;
		}
		
		[parameterPairs addObject:parameter];
	}];
	return [parameterPairs componentsJoinedByString:@"&"];
}

@end
