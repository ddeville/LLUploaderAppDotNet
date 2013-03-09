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

static NSString * const LLAppDotNetContextBaseAPI = @"https://alpha-api.app.net/";

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
		@"scope" : @"basic, files",
		@"client_id" : [self clientID],
		@"password_grant_secret" : [self passwordGrantSecret],
		@"username" : username,
		@"password" : password,
	};
	[self _addBodyParameters:parameters toRequest:request];
	
	return request;
}

+ (NSString *)parseAuthenticationResponseWithProvider:(LLAppDotNetResponseProvider)responseProvider username:(NSString **)usernameRef error:(NSError **)errorRef
{
	NSParameterAssert(usernameRef != nil);
	
	NSURLResponse *response = nil;
	NSData *bodyData = responseProvider(&response, errorRef);
	if (bodyData == nil) {
		return nil;
	}
	
	void (^returnUnexpectedError)(NSError *) = ^ (NSError *underlyingError) {
		if (errorRef != NULL) {
			NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											  NSLocalizedStringFromTableInBundle(@"Couldn\u2019t sign in to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected authentication error description"), NSLocalizedDescriptionKey,
											  NSLocalizedStringFromTableInBundle(@"An unexpected error occurred while signing in to App.net, please double check your username and password, and try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected authentication error recovery suggestion"), NSLocalizedRecoverySuggestionErrorKey,
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
	
	responseJSON = _LLAppDotNetContextCast(NSDictionary, responseJSON);
	
	NSString *accessToken = [responseJSON objectForKey:@"access_token"];
	if (accessToken == nil) {
		NSString *errorDescription = [responseJSON objectForKey:@"error"];
		if (errorDescription == nil) {
			returnUnexpectedError(nil);
			return nil;
		}
		
		if (errorRef != NULL) {
			NSDictionary *errorInfo = @{
				NSLocalizedDescriptionKey : errorDescription,
				NSLocalizedRecoverySuggestionErrorKey : NSLocalizedStringFromTableInBundle(@"Your App.net sign-in details were incorrect, please reenter them and try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext invalid credentials error recovery suggestion")
			};
			*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetErrorCodeInvalidCredentials userInfo:errorInfo];
		}
		
		return nil;
	}
	
	*usernameRef = [responseJSON objectForKey:@"username"];
	
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

#pragma mark - User

static NSString * const LLAppDotNetContextUserEndpoint = @"/stream/0/users/me";

- (NSURLRequest *)requestCurrentUserInformation
{
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:[LLAppDotNetContextBaseAPI stringByAppendingString:LLAppDotNetContextUserEndpoint]]];
	
	[self _addAuthenticationToRequest:request];
	
	return request;
}

+ (NSString *)parseUserResponseWithProvider:(LLAppDotNetResponseProvider)responseProvider error:(NSError **)errorRef
{
	NSURLResponse *response = nil;
	NSData *bodyData = responseProvider(&response, errorRef);
	if (bodyData == nil) {
		return nil;
	}
	
	BOOL responseOK = [self _checkResponse:response bodyData:bodyData errorDescription:NSLocalizedStringFromTableInBundle(@"Couldn\u2019t load your details", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext user loading error description") error:errorRef];
	if (!responseOK) {
		return nil;
	}
	
	void (^returnUnexpectedError)(NSError *) = ^ (NSError *underlyingError) {
		if (errorRef != NULL) {
			NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											  NSLocalizedStringFromTableInBundle(@"Couldn\u2019t retrieve the user\u2019s information from App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected upload error description"), NSLocalizedDescriptionKey,
											  NSLocalizedStringFromTableInBundle(@"An unexpected App.net error has occurred. Please try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected app.net error recovery suggestion"), NSLocalizedRecoverySuggestionErrorKey,
											  nil];
			[errorInfo setValue:underlyingError forKey:NSUnderlyingErrorKey];
			*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetUnknownError userInfo:errorInfo];
		}
	};
	
	NSError *deserializationError = nil;
	id responseJSON = [NSJSONSerialization JSONObjectWithData:bodyData options:(NSJSONReadingOptions)0 error:&deserializationError];
	if (responseJSON == nil) {
		returnUnexpectedError(deserializationError);
		return nil;
	}
	
	NSDictionary *responseDocument = _LLAppDotNetContextCast(NSDictionary, responseJSON);
	
	NSDictionary *responseData = _LLAppDotNetContextCast(NSDictionary, responseDocument[@"data"]);
	
	NSString *username = _LLAppDotNetContextCast(NSString, responseData[@"username"]);
	
	if (username == nil) {
		returnUnexpectedError(nil);
		return nil;
	}
	
	return username;
}

#pragma mark - Upload

static NSString * const LLAppDotNetContextFileCreationEndpoint = @"stream/0/files";

static inline NSError *LLAppDotNetContextUploadError(NSError *underlyingError) {
	NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									  NSLocalizedStringFromTableInBundle(@"Couldn\u2019t upload to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected upload error description"), NSLocalizedDescriptionKey,
									  NSLocalizedStringFromTableInBundle(@"An unexpected App.net error has occurred. Please try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected app.net error recovery suggestion"), NSLocalizedRecoverySuggestionErrorKey,
									  nil];
	[errorInfo setValue:underlyingError forKey:NSUnderlyingErrorKey];
	return [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:LLUploaderAppDotNetUnknownError userInfo:errorInfo];
}

- (NSURLRequest *)requestUploadFileContent:(NSURL *)fileLocation error:(NSError **)errorRef
{
	NSParameterAssert(fileLocation != nil);
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setURL:[NSURL URLWithString:[LLAppDotNetContextBaseAPI stringByAppendingString:LLAppDotNetContextFileCreationEndpoint]]];
	
	RMUploadMultipartFormDocument *fileDocument = [[[RMUploadMultipartFormDocument alloc] init] autorelease];
	[fileDocument addFileByReferencingURL:fileLocation withFilename:[fileLocation lastPathComponent] toField:@"content"];
	[fileDocument setValue:[[NSBundle mainBundle] bundleIdentifier] forField:@"type"];
	[request setHTTPBodyDocument:fileDocument];
	
	[self _addAuthenticationToRequest:request];
	
	return request;
}

+ (NSString *)parseUploadFileContentResponseWithProvider:(LLAppDotNetResponseProvider)responseProvider error:(NSError **)errorRef
{
	NSURLResponse *response = nil;
	NSData *bodyData = responseProvider(&response, errorRef);
	if (bodyData == nil) {
		return nil;
	}
	
	BOOL responseOK = [self _checkResponse:response bodyData:bodyData errorDescription:NSLocalizedStringFromTableInBundle(@"Couldn\u2019t upload to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext uploading error description") error:errorRef];
	if (!responseOK) {
		return nil;
	}
	
	void (^returnUnexpectedError)(NSError *) = ^ (NSError *underlyingError) {
		if (errorRef != NULL) {
			*errorRef = LLAppDotNetContextUploadError(underlyingError);
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
	
	NSDictionary *responseData = _LLAppDotNetContextCast(NSDictionary, responseDocument[@"data"]);
	
	NSString *fileID = _LLAppDotNetContextCast(NSString, responseData[@"id"]);
	if (fileID == nil) {
		returnUnexpectedError(nil);
		return nil;
	}
	
	return fileID;
}

static NSString * const LLAppDotNetContextFileUpdateEndpoint = @"stream/0/files/%@";

- (NSURLRequest *)requestUploadFileMetadata:(NSString *)fileID title:(NSString *)title description:(id)description tags:(NSArray *)tags privacy:(LLUploaderAppDotNetPresetPrivacy)privacy error:(NSError **)errorRef
{
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setURL:[NSURL URLWithString:[[LLAppDotNetContextBaseAPI stringByAppendingFormat:LLAppDotNetContextFileUpdateEndpoint, fileID] stringByAppendingString:@"?include_annotations=1"]]];
	
	NSMutableDictionary *hostApplicationAnnotations = [NSMutableDictionary dictionary];
	[hostApplicationAnnotations setValue:description forKey:@"description"];
	[hostApplicationAnnotations setValue:tags forKey:@"tags"];
	NSDictionary *annotations = @{
		@"type" : [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingKeyPath:@"metadata"],
		@"value" : hostApplicationAnnotations,
	};
	
	NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
	[metadata setValue:title forKey:@"name"];
	[metadata setValue:(privacy == LLUploaderAppDotNetPresetPrivacyPublic ? @YES : @NO) forKey:@"public"];
	[metadata setValue:@[annotations] forKey:@"annotations"];
	
	NSData *bodyData = [NSJSONSerialization dataWithJSONObject:metadata options:(NSJSONWritingOptions)0 error:errorRef];
	if (bodyData == nil) {
		return nil;
	}
	
	[request setHTTPBody:bodyData];
	
	[self _addAuthenticationToRequest:request];
	
	return request;
}

+ (NSURL *)parseUploadedFileMetadataWithProvider:(LLAppDotNetResponseProvider)responseProvider error:(NSError **)errorRef
{
	NSURLResponse *response = nil;
	NSData *bodyData = responseProvider(&response, errorRef);
	if (bodyData == nil) {
		return nil;
	}
	
	NSLog(@"%@", [[[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding] autorelease]);
	
	BOOL responseOK = [self _checkResponse:response bodyData:bodyData errorDescription:NSLocalizedStringFromTableInBundle(@"Couldn\u2019t upload to App.net", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext uploading error description") error:errorRef];
	if (!responseOK) {
		return nil;
	}
	
	void (^returnUnexpectedError)(NSError *) = ^ (NSError *underlyingError) {
		if (errorRef != NULL) {
			*errorRef = LLAppDotNetContextUploadError(underlyingError);
		}
	};
	
	NSError *deserializationError = nil;
	id responseJSON = [NSJSONSerialization JSONObjectWithData:bodyData options:(NSJSONReadingOptions)0 error:&deserializationError];
	if (responseJSON == nil) {
		returnUnexpectedError(deserializationError);
		return nil;
	}
	
	NSDictionary *responseDocument = _LLAppDotNetContextCast(NSDictionary, responseJSON);
	
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

+ (BOOL)_checkResponse:(NSURLResponse *)response bodyData:(NSData *)bodyData errorDescription:(NSString *)errorDescription error:(NSError **)errorRef
{
	NSParameterAssert(errorDescription != nil);
	
	NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
	if (statusCode >= 200 && statusCode <= 299) {
		return YES;
	}
	
	if (errorRef == NULL) {
		return NO;
	}
	
	NSDictionary *statusCodeToRecoverySuggestionMap = @{
		@(401) : NSLocalizedStringFromTableInBundle(@"Your App.net sign-in details have expired, please sign in again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext authentication recovery suggestion"),
		@(413) : NSLocalizedStringFromTableInBundle(@"This file is too large for App.net. Please visit the App.net support page for information about size limits.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext file too large error recovery suggestion"),
		@(507) : NSLocalizedStringFromTableInBundle(@"You don\u2019t have enough space in your App.net Files storage for this file. Please upgrade your account or delete some file from your Files storage.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext insufficient storage error recovery suggestion"),
	};
	
	NSDictionary *statusCodeToErrorCodeMap = @{
		@(401) : @(LLUploaderAppDotNetErrorCodeInvalidCredentials),
		@(413) : @(LLUploaderAppDotNetErrorStorage),
		@(517) : @(LLUploaderAppDotNetErrorStorage),
	};
	
	NSString *recoverySuggestion = statusCodeToRecoverySuggestionMap[@(statusCode)] ? : NSLocalizedStringFromTableInBundle(@"An unexpected App.net error has occurred. Please try again.", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLAppDotNetContext unexpected app.net error recovery suggestion");
	NSNumber *errorCode = statusCodeToErrorCodeMap[@(statusCode)] ? : @(LLUploaderAppDotNetUnknownError);
	
	NSDictionary *errorInfo = @{
		NSLocalizedDescriptionKey : errorDescription,
		NSLocalizedRecoverySuggestionErrorKey : recoverySuggestion,
	};
	*errorRef = [NSError errorWithDomain:LLUploaderAppDotNetErrorDomain code:[errorCode integerValue] userInfo:errorInfo];
	
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
