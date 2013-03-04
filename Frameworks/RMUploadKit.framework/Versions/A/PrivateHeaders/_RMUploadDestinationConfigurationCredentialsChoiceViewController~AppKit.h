//
//  _RMUploadDestinationConfigurationCredentialsChoiceViewController.h
//  RMUploadKit
//
//  Created by Keith Duncan on 24/10/2011.
//  Copyright (c) 2011 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RMUploadPresetConfigurationViewController.h"

@interface _RMUploadDestinationConfigurationCredentialsChoiceViewController : RMUploadPresetConfigurationViewController

- (id)initWithCredentials:(NSArray *)credentials;
@property (readonly, copy, nonatomic) NSArray *credentials;

@property (readonly, assign, nonatomic) IBOutlet NSPopUpButton *existingCredentialsButton;
- (IBAction)selectExistingCredentials:(id)sender;

@property (readonly, assign, nonatomic) NSButton *authenticateNewCredentialsButton;
- (IBAction)authenticateNewCredentials:(id)sender;

@property (readonly, assign, nonatomic) IBOutlet NSImageView *bottomBarSeparatorImageView;

@property (readonly, assign, nonatomic) IBOutlet NSButton *secondaryActionButton;
- (IBAction)cancelConfiguration:(id)sender;

@property (readonly, assign, nonatomic) IBOutlet NSButton *primaryActionButton;
- (IBAction)nextStage:(id)sender;

@end
