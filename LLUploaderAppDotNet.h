//
//  LLUploaderAppDotNet.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMUploadKit/RMUploadKit.h"

@class LLAppDotNetContext, LLUploaderAppDotNetCredentials;

@interface LLUploaderAppDotNet : RMUploadPlugin

+ (void)authenticateContext:(LLAppDotNetContext *)context withCredentials:(LLUploaderAppDotNetCredentials *)credentials;

@end
