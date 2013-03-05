//
//  LLAppDotNetContext.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLAppDotNetContext.h"

@interface LLAppDotNetContext ()

@property (copy, nonatomic) NSString *consumerKey, *consumerSecret;
@property (copy, nonatomic) NSString *OAuthToken, *OAuthSecret;

@end

@implementation LLAppDotNetContext

- (void)dealloc
{
	[_consumerKey release];
	[_consumerSecret release];
	
	[_OAuthToken release];
	[_OAuthSecret release];
	
	[super dealloc];
}

#pragma mark - Context authentication

- (void)authenticateWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
	NSParameterAssert(consumerKey != nil);
	NSParameterAssert(consumerSecret != nil);
	
	[self setConsumerKey:consumerKey];
	[self setConsumerSecret:consumerSecret];
}

- (void)authenticateWithOAuthToken:(NSString *)OAuthToken OAuthSecret:(NSString *)OAuthSecret
{
	[self setOAuthToken:OAuthToken];
	[self setOAuthSecret:OAuthSecret];
}

#pragma mark - Authentication

- (NSURLRequest *)requestOAuthTokenCredentialsWithUsername:(NSString *)username password:(NSString *)password
{
	NSParameterAssert(username != nil);
	NSParameterAssert(password != nil);
	
//	NSParameterAssert([self _checkHasOAuthClientAuthentication]);
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setURL:[NSURL URLWithString:@"https://alpha.app.net/oauth/access_token"]];
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:username forKey:@"x_auth_username"];
	[parameters setObject:password forKey:@"x_auth_password"];
	[parameters setObject:@"client_auth" forKey:@"x_auth_mode"];
	[self _addBodyParameters:parameters toRequest:request];
	
	[self _addOAuthAuthenticationToRequest:request];
	
	return request;
}

+ (BOOL)parseAuthenticationResponseWithProvider:(_RMUploadURLConnectionResponseProviderBlock)responseProvider OAuthToken:(NSString **)OAuthTokenRef OAuthSecret:(NSString **)OAuthSecretRef error:(NSError **)errorRef
{
	return NO;
}

#pragma mark - Private

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
