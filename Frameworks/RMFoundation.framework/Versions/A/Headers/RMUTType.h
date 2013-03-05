//
//  RMUTType.h
//  RMFoundation
//
//  Created by Keith Duncan on 01/05/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	`UTTypeConformsTo()` doesn't decode dynamic UTType strings.
	
	this function calls `UTTypeConformsTo()` first then attempts to determine conformance on it's own.
 */
extern BOOL RMUTTypeConformsTo(CFStringRef testType, CFStringRef predicateType);

/*!
	\brief
	Callers often have a collection of types supported, this makes conformance checking quicker.
 */
extern BOOL RMUTTypeConformsToAnyInCollection(NSString *type, id <NSFastEnumeration> collection);
