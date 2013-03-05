//
//  LLAppDotNetContext.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RMUploadKit/RMUploadURLConnection+Private.h"

@interface LLAppDotNetContext : NSObject

- (void)authenticateWithClientID:(NSString *)clientID passwordGrantSecret:(NSString *)passwordGrantSecret;
- (void)authenticateWithUsername:(NSString *)username accessToken:(NSString *)accessToken;

- (NSURLRequest *)requestOAuthTokenCredentialsWithUsername:(NSString *)username password:(NSString *)password;
+ (NSString *)parseAuthenticationResponseWithProvider:(_RMUploadURLConnectionResponseProviderBlock)responseProvider username:(NSString **)username error:(NSError **)errorRef;

@end
