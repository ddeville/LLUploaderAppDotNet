//
//  LLAppDotNet-Constants.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LLAppDotNetBundleIdentifier;

extern NSString * const LLAppDotNetErrorDomain;

typedef NS_ENUM (NSInteger, LLAppDotNetErrorCode) {
	LLAppDotNetUnknownError = 0,
	
	LLAppDotNetErrorCodeInvalidCredentials = -100,
};
