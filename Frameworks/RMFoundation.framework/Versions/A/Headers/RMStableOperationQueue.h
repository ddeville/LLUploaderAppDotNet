//
//  RMStableOperationQueue.h
//  SumOverHistories
//
//  Created by Keith Duncan on 04/09/2011.
//  Copyright (c) 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMFoundation/RMFoundation-Macros.h"

/*!
	\brief
	This provides a stable operationCount property which can be observed accurately.
	
	<rdar://problem/10117542> Foundation - when observing NSOperationQueue.operationCount the change dictionaries aren't consistent
	Mac OS SDK
	Serious Bug
 */
@interface RMStableOperationQueue : NSOperationQueue

extern NSString *const RMStableOperationQueueStableOperationCountKey;
/*!
	\brief
	Changes to this property are serialised, and it is safe to monitor using key value observing
	Key value observing notifications for this property may be received on any thread, but won't they be received concurrently.
 */
@property (readonly, assign, RM_PROPERTY_ATOMIC) NSInteger stableOperationCount;

@end
