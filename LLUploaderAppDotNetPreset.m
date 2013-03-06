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

@implementation LLUploaderAppDotNetPreset

@dynamic authentication;

+ (NSString *)localisedName
{
	return @"App.net";
}

+ (NSString *)iconResource
{
	return @"ADN";
}

+ (Class)uploadTaskClass
{
	return [LLUploaderAppDotNetUploadTask class];
}

+ (Class)credentialsClass
{
	return [LLUploaderAppDotNetCredentials class];
}

- (NSSet *)acceptedTypes
{
	NSMutableSet *acceptedTypes = [NSMutableSet setWithSet:[super acceptedTypes]];
	[acceptedTypes addObject:(id)kUTTypeData];
	return acceptedTypes;
}

- (NSURL *)serviceURL
{
	return [[[NSURL alloc] initWithScheme:@"http" host:@"app.net" path:@"/"] autorelease];
}

@end
