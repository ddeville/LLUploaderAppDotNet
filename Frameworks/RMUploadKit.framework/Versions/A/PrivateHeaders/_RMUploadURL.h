//
//  _RMUploadURL.h
//  RMUploadKit
//
//  Created by Keith Duncan on 28/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSData *_RMUploadURLEncodeData(NSData *data);
extern NSData *_RMUploadURLDecodeData(NSData *data);

extern NSString *_RMUploadURLEncodeString(NSString *string);
extern NSString *_RMUploadURLDecodeString(NSString *string);

/*!
	\brief
	
 */
@interface _RMUploadURL : NSObject

@end
