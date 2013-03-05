//
//  RMSerialQueue.h
//  Serial Queue to Secondary Run Loop
//
//  Created by Keith Duncan on 22/12/2011.
//  Copyright (c) 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
	\brief
	Provides a uniform interface to dequeue blocks serially on a dispatch queue and to switch to a CFRunLoop.
	
	After returning from a switch-to-run-loop mode method, the serial queue will dequeue your submitted blocks on a thread with a serviced run loop.
	
	The queue asserts that blocks are dequeued on the environment the caller assumes is present.
	- A newly instantiated queue will assert that submitted blocks are being dequeued on a dispatch queue
	- After receiving -inheritRunLoop or -startRunLoop the queue asserts that subsequently enqueued blocks are actually dequeued on a run loop
	- After receiving -stopRunLoop the queue asserts that subsequently submitted blocks aren't dequeued on a run loop
 */
@interface RMSerialQueue : NSObject

/*!
	\brief
	Blocks are dequeued on a serial dispatch queue by default
 */
- (void)performBlock:(void (^)(void))block;

/*!
	\brief
	If you already have a serviced run loop, and you wish to redirect blocks to it, call this method.
	
	Subsequently enqueued blocks will be dequeued on your CFRunLoop.
 */
- (void)inheritRunLoop;
/*!
	\brief
	Subsequently enqueued blocks will be dequeued on a background CFRunLoop
	
	This enables an NSOperation to extablish a non-main CFRunLoop to -
	a) schedule objects that can only be scheduled on an NSRunLoop on
	b) provide a run loop environment to execute code which expects a serviced run loop
 */
- (void)startRunLoop;

/*!
	\brief
	Subsequently enqueued blocks will be dequeued on a serial dispatch queue.
	This method should be invoked to switch back from an inherited or started run loop.
	
	If they use `CFRunLoopGetCurrent()` the run loop it returns is unserviced.
 */
- (void)stopRunLoop;

@end
