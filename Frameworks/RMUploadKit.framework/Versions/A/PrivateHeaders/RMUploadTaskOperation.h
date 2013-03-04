//***************************************************************************

// Copyright (C) 2009 Realmac Software Ltd
//
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information of Realmac Software Ltd
// and are protected by copyright law. They may not be disclosed
// to third parties or copied or duplicated in any form, in whole or
// in part, without the prior written consent of Realmac Software Ltd.

// Created by Danny Greg on 25/3/2009 

//***************************************************************************

#import <Foundation/Foundation.h>

#import "RMUploadKit/RMUploadTask.h"
#import "RMUploadKit/RMUploadMacros.h"

extern NSString *const RMUploadTaskOperationCountOfCompletedUploadTasksKey;
extern NSString *const RMUploadTaskOperationTotalUploadTasksKey;

/*!
	\brief
	This notification is posted when the batch completes.
	
	\details
	The userInfo dictionary will contain the following keys:
	
	<tt>RMUploadBatchBundleTasksCompletedInfoKey</tt> : array of NSNotification objects from the tasks
	<tt>RMUploadTaskQueueErrorNotificationKey</tt> : NSError indicating that an error occurred whilst uploading.
	
	Posted on the default center, from the currently executing thread; which you may have influenced when calling -startAndInheritRunLoop:.
 */
extern NSString *const RMUploadTaskOperationDidCompleteNotificationName;

	extern NSString *const RMUploadTaskOperationTaskFinishedUploadingNotificationsKey; // NSArray of NSNotification
	extern NSString *const RMUploadTaskOperationErrorKey; // NSError

/*!
	\brief
	This queues a collection of upload tasks, it collates the completion info for presentation at the end of the batch
	
	\brief
	It inherits from NSOperation so that the queue can itself be enqueued easing concurrency graph management.
 */
@interface RMUploadTaskOperation : NSOperation

/*!
	\brief
	This is no longer part of the initialiser so that the operation can be created ahead of time and appended to.
	
	\details
	You must add all the operations you want as part of this operation before it becomes isReady
	Results are undefined if you add an operation after the operation has become ready
	Ensure this operation is dependent on any operation which adds tasks to it
 */
- (void)addUploadTask:(RMUploadTask *)uploadTask;

/*!
	\brief
	Creates a run loop for the tasks.
 */
- (void)start;

/*!
	\brief
	The task queue completion notification is still posted.
 */
- (void)cancel;

/*!
	\brief
	This is intended for providing a current value for a progress bar. It will be a fraction of the <tt>-totalUploadProgress</tt>
 */
@property (readonly, assign, RMUPLOAD_PROPERTY_ATOMIC) NSUInteger countOfCompletedUploadTasks;
/*!
	\brief
	This is intended for providing a maximum value for a progress bar.
 */
@property (readonly, assign, RMUPLOAD_PROPERTY_ATOMIC) NSUInteger totalUploadTasks;

/*!
	\brief
	Results are available as a completionProvider instead of observing the notification
 */
@property (readonly, copy, RMUPLOAD_PROPERTY_ATOMIC) NSArray * (^completionProvider)(NSError **);

@end
