//
//  DSMultipartFormDocument.h
//  Courier
//
//  Created by Keith Duncan on 29/04/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMUploadKit/RMUploadAvailability.h"

#if RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1

/*!
	\brief
	Base class for upload documents.
 */
@interface RMUploadDocument : NSObject

@end

#endif // RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1

/*!
	\brief
	This format is described in IETF-RFC-2388 <http://tools.ietf.org/html/rfc2388>
	
	\details
	The order you add values in is unpreserved.
 */
@interface RMUploadMultipartFormDocument : 
#if RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1
	RMUploadDocument
#else
	NSObject
#endif /* RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1 */

/*!
	\brief
	Returns the order fields were added in, and the order they'll be serialised in.
 */
- (NSArray *)fieldOrder AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_1_AND_LATER;

/*!
	\brief
	Returns the value associated with a given fieldname.
 */
- (NSString *)valueForField:(NSString *)fieldname;

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
- (void)setValue:(NSString *)value forField:(NSString *)fieldname;

/*!
	\brief
	Unordered collection of previously added URLs using <tt>-addFileByReferencingURL:withFilename:toField:</tt>.
 */
- (NSSet *)fileLocationsForField:(NSString *)fieldname;

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
- (void)addFileByReferencingURL:(NSURL *)location withFilename:(NSString *)filename toField:(NSString *)fieldname;

@end

@interface RMUploadMultipartFormDocument (RMUploadDeprecated)

/*!
	\brief
	Serialise the field values into a data object.
	
	\details
	This method isn't invoked in RMUploadKit 1.1 and later, override <tt>-getData:contentType:</tt> instead.
	
	\deprecated
	Deprecated with no replacement. Use the <tt>-[NSURLRequest HTTPBodyDocument]</tt> property and <tt>RMUploadURLConnection</tt> instead of serialising the document yourself.
	
	\param contentTypeRef
	This is the MIME type of the output. It contains the generated multipart boundary.
	
	\returns
	Returns NO if any of the file parts cannot be loaded.
	Returns YES on success.
 */
- (BOOL)getFormData:(NSData **)dataRef contentType:(NSString **)contentTypeRef DEPRECATED_IN_RMUPLOADKIT_FRAMEWORK_VERSION_1_1_AND_LATER;

@end

#if RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1

/*!
	\brief
	This format is described in IETF-RFC-2387 <http://tools.ietf.org/html/rfc2387>
	
	\details
	Starting in RMUploadKit 1.1, the order in which data is added is preserved.
 */
@interface RMUploadMultipartRelatedDocument : RMUploadDocument

/*!
	\brief
	Designated Initialiser.
 */
- (id)init;

/*!
	\brief
	If your document is self referrential, use this initialiser to specify the index content identifier.
 */
- (id)initWithStartContentIdentifier:(NSString *)startContentIdentifier;

/*!
	\brief
	The data will appear in the serialised document.
	
	\param contentType
	Defaults to 'application/octet-stream' if nil.
	
	\param contentIdentifier
	Pass nil to omit the 'Content-ID' header.
	A contentIdentifier must be unique per document, adding another part with the same content identifier will throw an exception.
 */
- (void)addPartWithData:(NSData *)data withContentType:(NSString *)contentType forContentIdentifier:(NSString *)contentIdentifier;

/*!
	\brief
	The content type is inferred.
	
	\param contentIdentifier
	Pass nil to omit the 'Content-ID' header.
	A contentIdentifier must be unique per document, adding another part with the same content identifier will throw an exception.
 */
- (void)addPartByReferencingContentsOfURL:(NSURL *)location forContentIdentifier:(NSString *)contentIdentifier;

/*!
	\brief
	Removes a previously added part for the content identifier.
 */
- (void)removePartForContentIdentifier:(NSString *)contentIdentifier;

@end

/*!
	\brief
	For services that don't support `Transfer-Encoding: chunked` as <tt>NSURLConnection</tt> uses when given an <tt>HTTPBodyStream<tt>.
	
	\details
	Allows for efficient streaming without chunking the data.
 */
@interface RMUploadFileDocument : RMUploadDocument

- (id)initByReferencingContentsOfURL:(NSURL *)location;

@end

#endif // RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1
