//
//  LLUploaderAppDotNetPresetConfigurationViewController.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "RMUploadKit/RMUploadKit.h"

@class LLUploaderAppDotNetPreset;

@interface LLUploaderAppDotNetPresetConfigurationViewController : RMUploadPresetConfigurationViewController

@property (retain, nonatomic) LLUploaderAppDotNetPreset *representedObject;

@property (assign, nonatomic) IBOutlet NSPopUpButton *privacyPopupButton;
- (IBAction)privacySelectionChanged:(id)sender;

@end
