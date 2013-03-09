//
//  LLUploaderAppDotNetMetadataViewController.h
//  LLUploaderAppDotNet
//
//  Created by Damien DeVille on 09/03/2013.
//  Copyright (c) 2013 Damien DeVille. All rights reserved.
//

#import "RMUploadKit/RMUploadKit.h"

@interface LLUploaderAppDotNetMetadataViewController : RMUploadMetadataConfigurationViewController

@property (assign, nonatomic) IBOutlet NSButton *postCheckBox;
@property (assign, nonatomic) IBOutlet NSTextField *postCharactersCountTextField;

@property (assign, nonatomic) IBOutlet NSTextField *postTextField;

@end
