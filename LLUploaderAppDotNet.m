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

static NSString * const _LLUploaderAppDotNetClientID = @"Vy3TT9w4eYAHvCnXEyfVqvXzKRn5GcLu";
static NSString * const _LLUploaderAppDotNetClientSecret = @"vqHVnuKBGds8tGu9j9yJhM4KR3BuZaM4";
static NSString * const _LLUploaderAppDotNetPasswordGrantSecret = @"3ATd9EtxSDpjQNakFhxnHrgs5HtPYYEg";

@interface LLUploaderAppDotNet ()

@property (retain, nonatomic) NSMutableDictionary *uploadUUIDToPostID;

@end

@implementation LLUploaderAppDotNet

- (id)initWithBundle:(NSBundle *)bundle
{
	self = [super initWithBundle:bundle];
	if (self == nil) {
		return nil;
	}
	
	_uploadUUIDToPostID = [[NSMutableDictionary alloc] init];
	
	return self;
}

- (void)dealloc
{
	[_uploadUUIDToPostID release];
	
	[super dealloc];
}

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

- (NSString *)postIDForUploadUUID:(NSString *)uploadUUID
{
	NSString *postID = nil;
	@synchronized (self) {
		postID = [self uploadUUIDToPostID][uploadUUID];
	}
	return postID;
}

- (void)setPostID:(NSString *)postID forUploadUUID:(NSString *)uploadUUID
{
	@synchronized (self) {
		[[self uploadUUIDToPostID] setObject:postID forKey:uploadUUID];
	}
}

@end
