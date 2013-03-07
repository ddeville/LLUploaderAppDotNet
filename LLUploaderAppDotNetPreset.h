//
//  LLUploaderAppDotNetPreset.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMUploadKit/RMUploadKit.h"

#import "LLUploaderAppDotNetCredentials.h"

typedef NS_ENUM(NSInteger, LLUploaderAppDotNetPresetPrivacy) {
	LLUploaderAppDotNetPresetPrivacyPublic = 1,
	LLUploaderAppDotNetPresetPrivacyPrivate = 2,
};

@interface LLUploaderAppDotNetPreset : RMUploadPreset

@property (readonly, assign, nonatomic) LLUploaderAppDotNetCredentials *authentication;

extern NSString * const LLUploaderAppDotNetPresetPrivacyKey;
@property (assign, nonatomic) LLUploaderAppDotNetPresetPrivacy privacy;

@end
