//
//  RMUploadURLEncodedDocument+RMUploadPrivate.h
//  RMUploadKit
//
//  Created by Keith Duncan on 27/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import "RMUploadKit/RMUploadURLEncodedDocument.h"

#import "RMUploadKit/RMUploadAvailability.h"

#if RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1

/*!
	\brief
	
 */
@interface RMUploadURLEncodedDocument ()

@property (retain, nonatomic) NSMutableDictionary *objects;

@property (assign, nonatomic) BOOL cachedFrameLengthIsValid;
@property (assign, nonatomic) NSUInteger cachedFrameLength;

@end

/*!
	\brief
	
 */
@interface RMUploadURLEncodedDocument (RMUploadPrivate)

/*!
	\brief
	Each field is decomposed into at least one packet.
	This first packet will always be the encoded fieldname key.
 */
typedef void (^_RMUploadURLEncodedDocumentEnumerator)(NSString *fieldname, NSArray *packets, BOOL *stopEnumeratingPackets);
/*!
	\brief
	This method is primitive and used internally to count the bytes in a document, you can use it to count the bytes externally ahead of time and enumerate the composed data stream.
 */
- (void)_enumeratePacketsWithContentType:(NSString **)contentTypeRef sortDescriptors:(NSArray *)sortDescriptors usingBlock:(_RMUploadURLEncodedDocumentEnumerator)block;

/*!
	\brief
	Decomposes the document, performs the packets against a no-op stream and counts the bytes.
 */
- (BOOL)_updateCachedFrameLengthIfNeeded:(NSError **)errorRef;

@end

#endif /* RMUPLOADKIT_FRAMEWORK_VERSION_MAX_ALLOWED >= RMUPLOADKIT_FRAMEWORK_VERSION_1_1 */
