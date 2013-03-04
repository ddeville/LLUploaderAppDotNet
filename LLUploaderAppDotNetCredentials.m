//
//  LLUploaderAppDotNetCredentials.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetCredentials.h"

@implementation LLUploaderAppDotNetCredentials

- (void)dealloc
{
	[_username release];
	
	[super dealloc];
}

@end
