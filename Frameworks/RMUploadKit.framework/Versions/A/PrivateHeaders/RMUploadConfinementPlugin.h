//
//  RMUploadConfinementPlugin.h
//  RMUploadKit
//
//  Created by Keith Duncan on 02/11/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMUploadCredentials;
@class RMUploadPreset;

@interface RMUploadConfinementPlugin : NSObject

- (id)initWithCredentials:(RMUploadCredentials *)credentials preset:(RMUploadPreset *)preset;

@property (readonly, nonatomic) RMUploadCredentials *credentials;
@property (readonly, nonatomic) RMUploadPreset *preset;

@end
