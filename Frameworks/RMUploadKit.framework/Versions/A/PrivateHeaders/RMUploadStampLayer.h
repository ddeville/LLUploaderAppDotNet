//
//  DSStampLayer.h
//  Courier
//
//  Created by Keith Duncan on 16/03/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RMUploadKit/RMUploadMacros.h"

/*!
	\brief
	Composites the stamp image onto a background image.
	
	\details
	The resultant image is set into the contents property and can be used elsewhere.
 */
@interface RMUploadStampLayer : CALayer

@property (retain, nonatomic) NSImage *stampIcon;
@property (retain, nonatomic) NSImage *stampBackgroundIcon;

@property (retain, RMUPLOAD_PROPERTY_ATOMIC) /* NSImage * */ id contents;

@end
