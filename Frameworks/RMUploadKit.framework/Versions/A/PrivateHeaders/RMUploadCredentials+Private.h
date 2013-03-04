//
//  RMUploadCredentials+Private.h
//  RMUploadKit
//
//  Created by Keith Duncan on 31/07/2009.
//  Copyright 2009 Realmac Software. All rights reserved.
//

#import "RMUploadKit/RMUploadCredentials.h"

/*!
	\brief
	This property is privately writable.
 */
extern NSString *const _RMUploadCredentialsPluginKey;

@interface RMUploadCredentials () <NSCopying>

@end

@interface RMUploadCredentials (RMUploadPrivate)

/*!
	\brief
	Credentials should be validated before creating any presets for them, and upon load to prune invalid credentials.
 */
+ (BOOL)_validateCredentials:(RMUploadCredentials *)credentials;

@end
