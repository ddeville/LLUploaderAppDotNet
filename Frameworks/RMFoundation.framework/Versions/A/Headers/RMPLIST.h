//
//  RMPLIST.h
//  RMFoundation
//
//  Created by Keith Duncan on 13/02/2011.
//  Copyright 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMPLISTArchiver : NSObject

/*!
	\brief
	Plist objects are:
	
	- NSData
	- NSDate
	- NSString
	- NSNumber
	
	- NSArray
		- of PLIST objects
	
	- NSDictionary
		- of NSString keys and PLIST objects
 */
+ (BOOL)canEncodeObject:(id)object;

@end
