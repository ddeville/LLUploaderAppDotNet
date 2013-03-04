//
//  LLAppDotNetContext.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLAppDotNetContext.h"

@implementation LLAppDotNetContext

- (NSURLRequest *)requestOAuthTokenCredentialsWithUsername:(NSString *)username password:(NSString *)password
{
	return nil;
}

+ (BOOL)parseAuthenticationResponseWithProvider:(_RMUploadURLConnectionResponseProviderBlock)responseProvider OAuthToken:(NSString **)OAuthTokenRef OAuthSecret:(NSString **)OAuthSecretRef error:(NSError **)errorRef
{
	return NO;
}

@end
