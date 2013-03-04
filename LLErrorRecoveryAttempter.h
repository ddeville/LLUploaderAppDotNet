//
//  LLErrorRecoveryAttempter.h
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Damien DeVille. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLErrorRecoveryAttempter : NSObject

- (void)addRecoveryOptionWithLocalizedTitle:(NSString *)localizedTitle recoveryBlock:(BOOL (^)(NSError *recoveryError))recoveryBlock;
- (void)addCancelRecoveryOption;

- (NSArray *)recoveryOptions;

@end