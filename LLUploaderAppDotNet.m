//
//  LLUploaderAppDotNet.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNet.h"

#import "LLAppDotNetContext.h"
#import "LLUploaderAppDotNetCredentials.h"

#import "LLUploaderAppDotNetCredentialsConfigurationViewController.h"
#import "LLUploaderAppDotNetPresetConfigurationViewController.h"

static NSString * const _LLUploaderAppDotNetConsumerKey = @"Vy3TT9w4eYAHvCnXEyfVqvXzKRn5GcLu";
static NSString * const _LLUploaderAppDotNetConsumerSecret = @"vqHVnuKBGds8tGu9j9yJhM4KR3BuZaM4";

@implementation LLUploaderAppDotNet

+ (void)authenticateContext:(LLAppDotNetContext *)context withCredentials:(LLUploaderAppDotNetCredentials *)credentials
{
	[context authenticateWithConsumerKey:_LLUploaderAppDotNetConsumerKey consumerSecret:_LLUploaderAppDotNetConsumerSecret];
	
	if (credentials != nil) {
		[context authenticateWithOAuthToken:[credentials OAuthToken] OAuthSecret:[credentials OAuthSecret]];
	}
}

- (RMUploadPresetConfigurationViewController *)credentialsConfigurationViewControllerForCredentials:(RMUploadCredentials *)credentials
{
	return [[[LLUploaderAppDotNetCredentialsConfigurationViewController alloc] init] autorelease];
}

- (RMUploadPresetConfigurationViewController *)presetConfigurationViewControllerForPreset:(RMUploadPreset *)preset
{
	return [[[LLUploaderAppDotNetPresetConfigurationViewController alloc] init] autorelease];
}

@end
