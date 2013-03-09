//
//  LLUploaderAppDotNetMetadataViewController.m
//  LLUploaderAppDotNet
//
//  Created by Damien DeVille on 09/03/2013.
//  Copyright (c) 2013 Damien DeVille. All rights reserved.
//

#import "LLUploaderAppDotNetMetadataViewController.h"

#import "LLUploaderAppDotNet-Constants.h"

@implementation LLUploaderAppDotNetMetadataViewController

- (id)init
{
	return [self initWithNibName:@"LLUploaderAppDotNetMetadataView" bundle:[NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier]];
}

- (void)loadView
{
	[super loadView];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
	if ([notification object] != [self postTextField]) {
		return;
	}
	
	NSUInteger characterCount = [[[self postTextField] stringValue] length];
	
	if (characterCount > 256) {
		NSString *truncatedStringValue = [[[self postTextField] stringValue] substringToIndex:256];
		[[self postTextField] setStringValue:truncatedStringValue];
		
		characterCount = 256;
	}
	
	characterCount = fmax(256 - characterCount, 0) ;
	
	[[self postCharactersCountTextField] setStringValue:[NSString stringWithFormat:@"%lu", characterCount]];
}

@end
