//
//  RMUploadStampView.h
//  RMUploadKit
//
//  Created by Keith Duncan on 21/06/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*!
	\brief
	Delegates the drawing to a stamp layer and caches the result.
 */
@interface RMUploadStampView : NSView

@property (retain, nonatomic) NSImage *stampIcon;
@property (retain, nonatomic) NSImage *stampBackgroundIcon;

@end
