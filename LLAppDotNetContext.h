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

- (void)authenticateWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;
- (void)authenticateWithOAuthToken:(NSString *)OAuthToken OAuthSecret:(NSString *)OAuthSecret;

- (NSURLRequest *)requestOAuthTokenCredentialsWithUsername:(NSString *)username password:(NSString *)password;
+ (BOOL)parseAuthenticationResponseWithProvider:(_RMUploadURLConnectionResponseProviderBlock)responseProvider OAuthToken:(NSString **)OAuthTokenRef OAuthSecret:(NSString **)OAuthSecretRef error:(NSError **)errorRef;

@end
