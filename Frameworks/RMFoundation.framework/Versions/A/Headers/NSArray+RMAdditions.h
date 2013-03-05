//
//  NSArray+RMLiveViewAdditions.h
//  Analog
//
//  Created by Keith Duncan on 03/04/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_INLINE BOOL RMArrayContainsIndex(NSArray *array, NSUInteger idx) {
	return NSLocationInRange(idx, NSMakeRange(0, [array count]));
}

NS_INLINE id RMSafeObjectAtIndex(NSArray *array, NSUInteger idx) {
	return (RMArrayContainsIndex(array, idx) ? [array objectAtIndex:idx] : nil);
}

@interface NSArray (RMAdditions)

/*!
	\brief
	Calculate all combinations of the input arrays.
	
	\param combinations
	NSArray object of NSArray objects of NSString objects.
 */
+ (id)rmfoundation_combinationsJoined:(NSArray *)combinations;

@end
