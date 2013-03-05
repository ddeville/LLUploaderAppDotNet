//
//  NSString+Additions.h
//  Amber
//
//  Created by Keith Duncan on 06/12/2007.
//  Copyright 2007 Keith Duncan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMFoundation/RMFoundation-Macros.h"

/*!
	\brief
	This category assists in manipulating KVC dotted paths.
 */
@interface NSString (AFKeyValueCoding)

- (NSArray *)keyPathComponents;
- (NSString *)lastKeyPathComponent;

+ (NSString *)stringWithKeyPathComponents:(NSString *)component, ... NS_REQUIRES_NIL_TERMINATION;

- (NSString *)stringByAppendingKeyPath:(NSString *)keyPath;
- (NSString *)stringByRemovingKeyPathComponentAtIndex:(NSUInteger)index;
- (NSString *)stringByRemovingLastKeyPathComponent;

@end

/*!
	\brief
	Unicode manipulation
 */
@interface NSString (RMUnicode)

/*!
	\brief
	This DOES NOT return UTF-32 encoded Unicode, it returns each composed character as a single Unicode codepoint.
	
	\details
	The codepoints buffer is allocated for you, the parameters are out only.
 */
- (BOOL)getCodepoints:(out uint32_t **)codepointsRef length:(out size_t *)lengthRef;

/*!
	\brief
	Given an array of Unicode codepoints, construct a string object to encode them
	
	Using NSString the codepoints can be encoded as one of the UCS Transformation Format (UTF) encodings.
 */
- (id)initWithCodepoints:(uint32_t *)codepoints length:(size_t)length;

@end

@interface NSString (RMEncoding)

typedef RM_ENUM(NSUInteger, RMStringEncoding) {
	RMStringEncodingPunycode,
};
/*!
	\brief
	Convert to custom encodings not provided by NSString or CFString
 */
- (NSData *)rmfoundation_dataUsingEncoding:(RMStringEncoding)encoding;

@end
