//
//  LLUploaderAppDotNet.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNet.h"

#import "LLUploaderAppDotNetCredentialsConfigurationViewController.h"
#import "LLUploaderAppDotNetPresetConfigurationViewController.h"

@implementation LLUploaderAppDotNet

- (RMUploadPresetConfigurationViewController *)credentialsConfigurationViewControllerForCredentials:(RMUploadCredentials *)credentials
{
	return [[[LLUploaderAppDotNetCredentialsConfigurationViewController alloc] init] autorelease];
}

- (RMUploadPresetConfigurationViewController *)presetConfigurationViewControllerForPreset:(RMUploadPreset *)preset
{
	return [[[LLUploaderAppDotNetPresetConfigurationViewController alloc] init] autorelease];
}

@end
