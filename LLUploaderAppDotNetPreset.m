//
//  LLUploaderAppDotNetPreset.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetPreset.h"

#import "LLUploaderAppDotNetCredentials.h"
#import "LLUploaderAppDotNetUploadTask.h"

#import "LLAppDotNet-Constants.h"

@implementation LLUploaderAppDotNetPreset

+ (NSString *)localisedName
{
	return @"App.net";
}

+ (NSImage *)icon
{
	return [[[NSImage alloc] initWithContentsOfURL:[[NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier] URLForImageResource:@"app_dot_net"]] autorelease];
}

+ (Class)uploadTaskClass
{
	return [LLUploaderAppDotNetUploadTask class];
}

+ (Class)credentialsClass
{
	return [LLUploaderAppDotNetCredentials class];
}

@end
