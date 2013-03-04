//
//  RMUploadMacros.h
//  RMUploadKit
//
//  Created by Damien DeVille on 11/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
	
	#import <UIKit/UIKit.h>
	
	#define RMUPLOAD_OPEN_URL(var) \
	do { \
		id __var = (var); \
		if ([[UIApplication sharedApplication] canOpenURL:__var]) { \
			[[UIApplication sharedApplication] openURL:__var]; \
		} \
	} \
	while (0)

#else
	
	#import <Cocoa/Cocoa.h>

	#define RMUPLOAD_OPEN_URL(var)	[[NSWorkspace sharedWorkspace] openURL:(var)]

#endif /* TARGET_OS_IPHONE */
