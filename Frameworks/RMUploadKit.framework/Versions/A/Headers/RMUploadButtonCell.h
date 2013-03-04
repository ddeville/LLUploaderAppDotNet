//
//  DSBottomBarButton.h
//  Dispatch
//
//  Created by Keith Duncan on 19/08/2009.
//  Copyright 2009 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const RMUploadButtonCellStyleWhite;
extern NSString *const RMUploadButtonCellStyleBlue;

@interface RMUploadButtonCell : NSButtonCell

@property (copy, nonatomic) NSString *style;

@end
