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

static NSString * const _LLUploaderAppDotNetClientID = @"Vy3TT9w4eYAHvCnXEyfVqvXzKRn5GcLu";
static NSString * const _LLUploaderAppDotNetClientSecret = @"vqHVnuKBGds8tGu9j9yJhM4KR3BuZaM4";
static NSString * const _LLUploaderAppDotNetPasswordGrantSecret = @"3ATd9EtxSDpjQNakFhxnHrgs5HtPYYEg";

@implementation LLUploaderAppDotNet

+ (void)authenticateContext:(LLAppDotNetContext *)context withCredentials:(LLUploaderAppDotNetCredentials *)credentials
{
	[context authenticateWithClientID:_LLUploaderAppDotNetClientID passwordGrantSecret:_LLUploaderAppDotNetPasswordGrantSecret];
	
	if (credentials != nil) {
		[context authenticateWithUsername:[credentials username] accessToken:[credentials accessToken]];
	}
}

- (RMUploadPresetConfigurationViewController *)credentialsConfigurationViewControllerForCredentials:(RMUploadCredentials *)credentials
{
	return [[[LLUploaderAppDotNetCredentialsConfigurationViewController alloc] init] autorelease];
}

- (RMUploadPresetConfigurationViewController *)presetConfigurationViewControllerForPreset:(RMUploadPreset *)preset
{
	return nil;
//	return [[[LLUploaderAppDotNetPresetConfigurationViewController alloc] init] autorelease];
}

@end
