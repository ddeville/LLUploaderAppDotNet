//
//  NSURLResponse+RMAdditions.h
//  RMFoundation
//
//  Created by Keith Duncan on 13/01/2011.
//  Copyright 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (RMAdditions)

/*
	\brief
	Headers should be compared in a case-insensitive manner.
 */
- (id)valueForHTTPHeaderField:(NSString *)header;

@end
