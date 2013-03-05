//
//  NSNumberFormatter+RMAdditions.h
//  RMFoundation
//
//  Created by Keith Duncan on 16/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumberFormatter (RMAdditions)

+ (NSString *)localisedDisplayStringForFileSizeBytes:(NSNumber *)number;

@end
