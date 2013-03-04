//
//  _RMUploadMetadataConfigurationViewController.h
//  RMUploadKit
//
//  Created by Keith Duncan on 21/06/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RMUploadStampView;

@class RMUploadPlugin;

@class RMUploadMetadataConfigurationViewController;

@interface _RMUploadMetadataConfigurationViewController : NSViewController

- (id)initWithPlugin:(RMUploadPlugin *)plugin presetClass:(Class)presetClass childViewController:(RMUploadMetadataConfigurationViewController *)viewController;

@property (readonly, assign, nonatomic) IBOutlet RMUploadStampView *stampView;
@property (readonly, assign, nonatomic) IBOutlet NSView *childViewControllerContainer;

@end
