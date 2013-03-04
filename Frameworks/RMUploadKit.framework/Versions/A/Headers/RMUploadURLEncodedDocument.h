//
//  RMUploadURLEncodedDocument.h
//  RMUploadKit
//
//  Created by Keith Duncan on 27/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import "RMUploadKit/RMUploadDocuments.h"

#import "RMUploadKit/RMUploadAvailability.h"

#if RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1

/*!
	\brief
	
 */
@interface RMUploadURLEncodedDocument : RMUploadDocument <NSCopying>

/*!
	\brief
	The fieldname should be unique per document, setting a value for an existing fieldname will overwrite the previous value.
	
	\details
	This will clear any files added to the same fieldname.
	
	\param value
	Can be nil, will remove existing value.
	
	\param fieldname
	Cannot be nil.
 */
- (void)addValue:(NSString *)value forField:(NSString *)fieldname;

/*!
	\brief
	Form documents support multiple files per-fieldname.
	
	\details
	Multiple files per fieldname are supported.
	This will clear any string values set for the same fieldname.
	
	\param filename
	This is optional, excluding it will use the last path component.
	
	\param fieldname
	To leave the 'name' value blank in the generated document, pass <tt>+[NSNull null]</tt> for the fieldname.
 */
- (void)addFileByReferencingURL:(NSURL *)location toField:(NSString *)fieldname;

/*!
	\brief
	Order isn't currently presered.
 */
- (id <NSFastEnumeration>)objectsForField:(NSString *)field;

@end

#endif /* RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1 */
