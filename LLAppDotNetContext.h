//
//  LLAppDotNetContext.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LLUploaderAppDotNetPreset.h"

typedef NSData * (^LLAppDotNetResponseProvider)(NSURLResponse **, NSError **);

@interface LLAppDotNetContext : NSObject

- (void)authenticateWithClientID:(NSString *)clientID passwordGrantSecret:(NSString *)passwordGrantSecret;
- (void)authenticateWithUsername:(NSString *)username accessToken:(NSString *)accessToken;

/*
	Authentication
 */
- (NSURLRequest *)requestOAuthTokenCredentialsWithUsername:(NSString *)username password:(NSString *)password;
+ (NSString *)parseAuthenticationResponseWithProvider:(LLAppDotNetResponseProvider)responseProvider username:(NSString **)usernameRef error:(NSError **)errorRef;

/*
	User retrieval
 */
- (NSURLRequest *)requestCurrentUserInformation;
+ (NSString *)parseUserResponseWithProvider:(LLAppDotNetResponseProvider)responseProvider error:(NSError **)errorRef;

/*
	Upload
 */
- (NSURLRequest *)requestUploadFileContent:(NSURL *)fileLocation error:(NSError **)errorRef;
+ (NSString *)parseUploadFileContentResponseWithProvider:(LLAppDotNetResponseProvider)responseProvider error:(NSError **)errorRef;

- (NSURLRequest *)requestUploadFileMetadata:(NSString *)fileID title:(NSString *)title description:(id)description tags:(NSArray *)tags privacy:(LLUploaderAppDotNetPresetPrivacy)privacy error:(NSError **)errorRef;
+ (NSURL *)parseUploadedFileMetadataResponseWithProvider:(LLAppDotNetResponseProvider)responseProvider fileToken:(NSString **)fileTokenRef error:(NSError **)errorRef;

- (NSURLRequest *)requestPost:(NSString *)postContent fileID:(NSString *)fileID fileToken:(NSString *)fileToken error:(NSError **)errorRef;
+ (NSString *)parsePostResponseWithProvider:(LLAppDotNetResponseProvider)responseProvider error:(NSError **)errorRef;

@end
