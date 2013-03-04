//
//  LLUploaderAppDotNetCredentialsConfigurationViewController.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import <RMUploadKit/RMUploadKit.h>

@class LLUploaderAppDotNetCredentials;

@interface LLUploaderAppDotNetCredentialsConfigurationViewController : RMUploadPresetConfigurationViewController

@property (strong, nonatomic) LLUploaderAppDotNetCredentials *representedObject;

@property (copy, nonatomic) NSString *password;
@property (readonly, getter = isAuthenticating, nonatomic) BOOL authenticating;

@end
