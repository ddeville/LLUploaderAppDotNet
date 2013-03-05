//
//  NSDate+RMAdditions.h
//  RMFoundation
//
//  Created by Keith Duncan on 30/11/2011.
//  Copyright (c) 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RMAdditions)

+ (id)parseRFC3339String:(NSString *)dateString;

@end
