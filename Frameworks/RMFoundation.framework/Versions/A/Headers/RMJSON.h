//
//  RMJSON.h
//  RMFoundation
//
//  Created by Keith Duncan on 24/10/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RMFoundationJSONErrorDomain;

enum {
	RMFoundationJSONErrorCodeUnknown = 0,
	
	/*
		RMJSONArchiver
		[-1, -199]
	 */
	RMFoundationJSONArchiverErrorCodeInvalidObjectClass = -1,
	RMFoundationJSONArchiverErrorCodeMalformedDataStructure = -2,
	
	/*
		RMJSONUnarchiver
		[-200, -299]
	 */
	
};
typedef NSInteger RMFoundationJSONErrorCode;

@interface RMJSONArchiver : NSObject

/*!
	\brief
	Determine if the argument is (or contains) JSON compatible objects.
 */
+ (BOOL)canEncodeObject:(id)object;

/*!
	\brief
	Encode PLIST objects into a JSON string.
	
	\details
	if <tt>+canEncodeObject:error:</tt> returns <tt>NO</tt> nil is returned.
 */
+ (NSString *)encodeObject:(id)object error:(NSError **)errorRef;

@end

@interface RMJSONUnarchiver : NSObject

/*!
	\brief
	Parse serialised JSON objects into PLIST objects.
	
	\details
	Determines the encoding of the data and passes the result onto <tt>+parseString:error:</tt>.
	
	\param charset
	A hint, if nil, we'll look for a BOM, if neither are provided, we choose UTF-8.
 */
+ (id)parseData:(NSData *)JSONData charset:(NSString *)charset error:(NSError **)errorRef;

/*!
	\brief
	Parse serialised JSON objects into PLIST objects.
 */
+ (id)parseString:(NSString *)JSONString error:(NSError **)errorRef;

@end
