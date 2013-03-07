//
//  LLAppDotNetContext.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLAppDotNetContext.h"

#import "RMUploadKit/RMUploadKit.h"
#import "RMUploadKit/RMUploadKit+Private.h"

#import "LLUploaderAppDotNet-Constants.h"

#define _LLAppDotNetContextCast(cls, obj) ({ id __obj = (obj); [__obj isKindOfClass:[cls class]] ? __obj : nil; })

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
	
	/*
		Note:
		
		These parameters are defined in http://developers.app.net/docs/authentication/flows/password
	 */
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setURL:[NSURL URLWithString:@"https://alpha.app.net/oauth/access_token"]];
	
	NSDictionary *parameters = @{
		@"grant_type" : @"password",
		@"scope" : @"basic",
		@"client_id" : [self clientID],
		@"password_grant_secret" : [self passwordGrantSecret],
		@"username" : username,
		@"password" : password,
	};
	[self _addBodyParameters:parameters toRequest:request];
	
	return request;
}

+ (NSString *)parseAuthenticationResponseWithProvider:(RMAppDotNetResponseProvider)responseProvider username:(NSString **)username error:(NSError **)errorRef
{
	NSParameterAssert(username != nil);
	
	NSURLResponse *response = nil;
	NSData *bodyData = responseProvider(&response, errorRef);
	if (bodyData == nil) {
		return nil;
	}
	
	if (![self _checkResponse:response bodyData:bodyData error:errorRef]) {
		return nil;
	}
	
	void (^returnUnexpectedError)(NSString *, NSError *) = ^ (NSString *description, NSError *underlyingError) {
		if (errorRef != NULL) {
			description = description ? : NSLocalizedStringFromTableInBundle(@"Couldn\u2019t sign in to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected authentication error description");
			NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											  description, NSLocalizedDescriptionKey,
											  NSLocalizedStringFromTableInBundle(@"An unexpected error occurred while signing in to App.net, please double check your username and password, and try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected authentication error recovery suggestion"), NSLocalizedRecoverySuggestionErrorKey,
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
	
	responseJSON = _LLAppDotNetContextCast(NSDictionary, responseJSON);
	
	NSString *accessToken = [responseJSON objectForKey:@"access_token"];
	if (accessToken == nil) {
		NSString *errorDescription = [responseJSON objectForKey:@"error"];
		returnUnexpectedError(errorDescription, nil);
		return nil;
	}
	
	*username = [responseJSON objectForKey:@"username"];
	
	return accessToken;
}

#pragma mark - Authentication (Private)

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

- (void)_addAuthenticationToRequest:(NSMutableURLRequest *)request
{
	static NSString * const _LLAppDotNetContextHTTPHeaderFieldAuthorization = @"Authorization";
	static NSString * const _LLAppDotNetContextAuthenticationTokenTypeKey = @"Bearer";
	
	/*
		Note:
		
		This is the value documented in http://developers.app.net/docs/authentication
	 */
	NSString *authenticationHeaderValue = [NSString stringWithFormat:@"%@ %@", _LLAppDotNetContextAuthenticationTokenTypeKey, [self accessToken]];
	[request setValue:authenticationHeaderValue forHTTPHeaderField:_LLAppDotNetContextHTTPHeaderFieldAuthorization];
}

#pragma mark - Upload

- (NSURLRequest *)requestUploadFileAtURL:(NSURL *)fileLocation title:(NSString *)title description:(id)description tags:(NSArray *)tags privacy:(LLUploaderAppDotNetPresetPrivacy)privacy error:(NSError **)errorRef
{
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setURL:[NSURL URLWithString:@"https://alpha-api.app.net/stream/0/files"]];
	
	RMUploadMultipartFormDocument *fileDocument = [[[RMUploadMultipartFormDocument alloc] init] autorelease];
	
	/*
		File content
	 */
	[fileDocument addFileByReferencingURL:fileLocation withFilename:[fileLocation lastPathComponent] toField:@"content"];
	
	/*
		Metadata
	 */
	NSString *hostApplicationType = [[NSBundle mainBundle] bundleIdentifier];
	
	[fileDocument setValue:hostApplicationType forField:@"type"];
	[fileDocument setValue:title forField:@"name"];
	[fileDocument setValue:[(privacy == LLUploaderAppDotNetPresetPrivacyPublic ? @YES : @NO) stringValue] forField:@"public"];
	
	/*
		Annotations
	 */
#if 0
	NSString *hostApplicationDescriptionType = [hostApplicationType stringByAppendingKeyPath:@"description"];
	NSString *hostApplicationTagsType = [hostApplicationType stringByAppendingKeyPath:@"tags"];
	
	NSMutableArray *annotations = [NSMutableArray array];
	if (description != nil) {
		NSDictionary *descriptionAnnotation = @{
			@"type" : hostApplicationDescriptionType,
			@"value" : description,
		};
		[annotations addObject:descriptionAnnotation];
	}
	if (tags != nil) {
		NSDictionary *tagsAnnotation = @{
			@"type" : hostApplicationTagsType,
			@"value" : tags,
		};
		[annotations addObject:tagsAnnotation];
	}
	
	NSData *annotationsJSONData = [NSJSONSerialization dataWithJSONObject:annotations options:(NSJSONWritingOptions)0 error:NULL];
	NSString *annotationsJSONString = [[NSString alloc] initWithData:annotationsJSONData encoding:NSUTF8StringEncoding];
	[fileDocument setValue:annotationsJSONString forField:@"annotations"];
#endif
	
	[request setHTTPBodyDocument:fileDocument];
	
	[self _addAuthenticationToRequest:request];
	
	return request;
}

+ (NSURL *)parseUploadFileResponseWithProvider:(RMAppDotNetResponseProvider)responseProvider error:(NSError **)errorRef
{
	NSURLResponse *response = nil;
	NSData *bodyData = responseProvider(&response, errorRef);
	if (bodyData == nil) {
		return nil;
	}
	
	BOOL responseOK = [self _checkResponse:response bodyData:bodyData error:errorRef];
	if (!responseOK) {
		return nil;
	}
	
	void (^returnUnexpectedError)(NSError *) = ^ (NSError *underlyingError) {
		if (errorRef != NULL) {
			NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											  NSLocalizedStringFromTableInBundle(@"Couldn\u2019t upload to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected upload error description"), NSLocalizedDescriptionKey,
											  NSLocalizedStringFromTableInBundle(@"An unexpected App.net error has occurred. Please try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected app.net error recovery suggestion"), NSLocalizedRecoverySuggestionErrorKey,
											  nil];
			[errorInfo setValue:underlyingError forKey:NSUnderlyingErrorKey];
			*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetUnknownError userInfo:errorInfo];
		}
	};
	
	if ([bodyData length] == 0) {
		returnUnexpectedError(nil);
		return nil;
	}
	
	NSError *deserializationError = nil;
	id responseJSON = [NSJSONSerialization JSONObjectWithData:bodyData options:(NSJSONReadingOptions)0 error:&deserializationError];
	if (responseJSON == nil) {
		returnUnexpectedError(deserializationError);
		return nil;
	}
	
	NSDictionary *responseDocument = _LLAppDotNetContextCast(NSDictionary, responseJSON);
	
	NSDictionary *responseMeta = _LLAppDotNetContextCast(NSDictionary, responseDocument[@"meta"]);
	
	NSNumber *responseCode = _LLAppDotNetContextCast(NSNumber, responseMeta[@"code"]) ;
	if (responseCode == nil) {
		returnUnexpectedError(nil);
		return nil;
	}
	
	if ([responseCode integerValue] != 200) {
		returnUnexpectedError(nil);
		return nil;
	}
	
	NSDictionary *responseData = _LLAppDotNetContextCast(NSDictionary, responseDocument[@"data"]);
	
	NSURL *permanentURL = [NSURL URLWithString:_LLAppDotNetContextCast(NSString, responseData[@"url_permanent"])];
	if (permanentURL != nil) {
		return permanentURL;
	}
	
	NSURL *URL = [NSURL URLWithString:_LLAppDotNetContextCast(NSString, responseData[@"url"])];
	if (URL == nil) {
		returnUnexpectedError(nil);
		return nil;
	}
	
	return URL;
}

#pragma mark - Response (Private)

+ (BOOL)_checkResponse:(NSURLResponse *)response bodyData:(NSData *)bodyData error:(NSError **)errorRef
{
	NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
	if (statusCode >= 200 && statusCode <= 299) {
		return YES;
	}
	
	if (errorRef == NULL) {
		return NO;
	}
	
	NSDictionary *statusCodeToRecoverySuggestionMap = @{
		@(400) : NSLocalizedStringFromTableInBundle(@"", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @""),
		@(413) : NSLocalizedStringFromTableInBundle(@"This file is too large for App.net. Please visit the App.net support page for information about size limits.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext file too large error recovery suggestion"),
		@(507) : NSLocalizedStringFromTableInBundle(@"You don\u2019t have enough space in your App.net Files storage for this file. Please upgrade your account or delete some file from your Files storage.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext insufficient storage error recovery suggestion"),
	};
	
	NSString *recoverySuggestion = statusCodeToRecoverySuggestionMap[@(statusCode)];
	if (recoverySuggestion == nil) {
		recoverySuggestion = NSLocalizedStringFromTableInBundle(@"", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"");
	}
	
	NSDictionary *errorInfo = @{
		NSLocalizedDescriptionKey : @"",
		NSLocalizedRecoveryOptionsErrorKey : recoverySuggestion,
	};
	*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:0 userInfo:errorInfo];
	
	return NO;
}

#pragma mark - Helpers (Private)

- (void)_addBodyParameters:(NSDictionary *)parameters toRequest:(NSMutableURLRequest *)request
{
	static NSString * const _LLAppDotNetContextHTTPHeaderFieldContentType = @"Content-Type";
	static NSString * const _LLAppDotNetContextApplicationFormURLEncodedMIMEType = @"application/x-www-form-urlencoded";
	
	NSString *bodyString = [self __encodeParameters:parameters];
	NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
	
	[request setValue:_LLAppDotNetContextApplicationFormURLEncodedMIMEType forHTTPHeaderField:_LLAppDotNetContextHTTPHeaderFieldContentType];
	[request setHTTPBody:bodyData];
}

- (NSString *)__encodeParameters:(NSDictionary *)parameters
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
