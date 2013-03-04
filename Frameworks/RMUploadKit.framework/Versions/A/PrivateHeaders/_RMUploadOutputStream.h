//
//  _RMUploadOutputStream.h
//  RMUploadKit
//
//  Created by Keith Duncan on 27/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _RMUploadOutputStream : NSOutputStream

typedef NSInteger (^_RMUploadOutputStreamOutputBlock)(uint8_t const *buffer, NSUInteger length);
- (id)initWithBlock:(_RMUploadOutputStreamOutputBlock)outputBlock;

@end
