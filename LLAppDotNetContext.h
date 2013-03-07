//
//  LLAppDotNetContext.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LLUploaderAppDotNetPreset.h"

typedef NSData * (^RMAppDotNetResponseProvider)(NSURLResponse **, NSError **);

@interface LLAppDotNetContext : NSObject

- (void)authenticateWithClientID:(NSString *)clientID passwordGrantSecret:(NSString *)passwordGrantSecret;
- (void)authenticateWithUsername:(NSString *)username accessToken:(NSString *)accessToken;

- (NSURLRequest *)requestOAuthTokenCredentialsWithUsername:(NSString *)username password:(NSString *)password;
+ (NSString *)parseAuthenticationResponseWithProvider:(RMAppDotNetResponseProvider)responseProvider username:(NSString **)username error:(NSError **)errorRef;

- (NSURLRequest *)requestUploadFileAtURL:(NSURL *)fileLocation title:(NSString *)title description:(id)description tags:(NSArray *)tags privacy:(LLUploaderAppDotNetPresetPrivacy)privacy error:(NSError **)errorRef;
+ (NSURL *)parseUploadFileResponseWithProvider:(RMAppDotNetResponseProvider)responseProvider error:(NSError **)errorRef;

@end
