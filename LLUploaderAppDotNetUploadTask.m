//
//  LLUploaderAppDotNetUploadTask.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetUploadTask.h"

#import "LLAppDotNetContext.h"
#import "LLUploaderAppDotNet.h"
#import "LLUploaderAppDotNetPreset.h"

@interface LLUploaderAppDotNetUploadTask ()

@property (readonly, retain, nonatomic) LLUploaderAppDotNetPreset *destination;

@property (retain, nonatomic) LLAppDotNetContext *context;

@end

@implementation LLUploaderAppDotNetUploadTask

@dynamic destination;

- (void)upload
{
	LLAppDotNetContext *context = [[[LLAppDotNetContext alloc] init] autorelease];
	[LLUploaderAppDotNet authenticateContext:context withCredentials:[[self destination] authentication]];
	[self setContext:context];
	
	[self _continueUpload];
}

- (void)cancel
{
	
}

- (void)_continueUpload
{
	
}

@end
