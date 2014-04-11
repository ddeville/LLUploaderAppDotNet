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
#import "LLUploaderAppDotNetMetadataViewController.h"

#error Populate client ID and secret

static NSString * const _LLUploaderAppDotNetClientID = @"";
static NSString * const _LLUploaderAppDotNetClientSecret = @"";
static NSString * const _LLUploaderAppDotNetPasswordGrantSecret = @"";

@implementation LLUploaderAppDotNet

+ (BOOL)authenticateContext:(LLAppDotNetContext *)context withCredentials:(LLUploaderAppDotNetCredentials *)credentials error:(NSError **)errorRef
{
	[context authenticateWithClientID:_LLUploaderAppDotNetClientID passwordGrantSecret:_LLUploaderAppDotNetPasswordGrantSecret];
	
	if (credentials != nil) {
		NSString *accessToken = [LLUploaderAppDotNetCredentials accessTokenForCredentials:credentials error:errorRef];
		if (accessToken == nil) {
			return NO;
		}
		[context authenticateWithUsername:[credentials username] accessToken:accessToken];
	}
	
	return YES;
}

- (RMUploadPresetConfigurationViewController *)credentialsConfigurationViewControllerForCredentials:(RMUploadCredentials *)credentials
{
	return [[[LLUploaderAppDotNetCredentialsConfigurationViewController alloc] init] autorelease];
}

- (RMUploadPresetConfigurationViewController *)presetConfigurationViewControllerForPreset:(RMUploadPreset *)preset
{
	return [[[LLUploaderAppDotNetPresetConfigurationViewController alloc] init] autorelease];
}

- (RMUploadMetadataConfigurationViewController *)additionalMetadataViewControllerForPresetClass:(Class)presetClass
{
	return [[[LLUploaderAppDotNetMetadataViewController alloc] init] autorelease];
}

@end
