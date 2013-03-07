//
//  LLUploaderAppDotNetPresetConfigurationViewController.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetPresetConfigurationViewController.h"

#import "LLUploaderAppDotNetPreset.h"

#import "LLUploaderAppDotNet-Constants.h"

@implementation LLUploaderAppDotNetPresetConfigurationViewController

@dynamic representedObject;

- (id)init
{
	return [self initWithNibName:@"LLUploaderAppDotNetPresetConfigurationView" bundle:[NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier]];
}

- (void)loadView
{
	[super loadView];
	
	LLUploaderAppDotNetPresetPrivacy privacy = [[self representedObject] privacy];
	[[self privacyPopupButton] selectItemWithTag:privacy];
}

- (IBAction)privacySelectionChanged:(id)sender
{
	LLUploaderAppDotNetPresetPrivacy privacy = [[[self privacyPopupButton] selectedItem] tag];
	[[self representedObject] setPrivacy:privacy];
}

@end
