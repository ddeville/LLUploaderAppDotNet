//
//  DSErrorRecoverer.h
//  Courier
//
//  Created by Keith Duncan on 04/08/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	For use as an NSRecoveryAttempterErrorKey.
 */
@interface RMErrorRecoveryAttempter : NSObject

/*!
	\brief
	Build up the recovery options.
	
	\details
	The error is passed in as an argument to the block because the error object can't have been created before this block for it to be to captured easily.
 */
- (void)addRecoveryOptionWithLocalizedTitle:(NSString *)localizedTitle recoveryBlock:(BOOL (^)(NSError *recoveryError))recoveryBlock;

/*!
	\brief
	Adds a cancel recovery option that returns `NO` from the recovery block.
 */
- (void)addCancelRecoveryOption;

/*!
	\brief
	Extract the recovery options for use NSLocalizedRecoveryOptionsErrorKey.
 */
- (NSArray *)recoveryOptions;

@end
