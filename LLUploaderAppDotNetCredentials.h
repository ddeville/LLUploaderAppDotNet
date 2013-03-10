//
//  LLUploaderAppDotNetCredentials.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMUploadKit/RMUploadKit.h"

@interface LLUploaderAppDotNetCredentials : RMUploadCredentials

@property (copy, nonatomic) NSString *username;

+ (NSString *)accessTokenForCredentials:(LLUploaderAppDotNetCredentials *)credentials error:(NSError **)errorRef;
+ (BOOL)setAccessToken:(NSString *)accessToken forCredentials:(LLUploaderAppDotNetCredentials *)credentials error:(NSError **)errorRef;

+ (NSString *)findInternetPasswordForUsername:(NSString *)username error:(NSError **)errorRef;

@end
