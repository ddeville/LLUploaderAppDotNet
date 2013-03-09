//
//  LLUploaderAppDotNet-Constants.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LLUploaderAppDotNetBundleIdentifier;

extern NSString * const LLUploaderAppDotNetErrorDomain;

typedef NS_ENUM (NSInteger, LLUploaderAppDotNetErrorCode) {
	LLUploaderAppDotNetUnknownError = 0,
	
	LLUploaderAppDotNetErrorCodeInvalidCredentials = -100,
	LLUploaderAppDotNetErrorCodeKeychain = -101,
	
	LLUploaderAppDotNetErrorStorage = -200,
};
