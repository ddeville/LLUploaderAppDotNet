//
//  RMUploadDocuments+Private.h
//  RMUploadKit
//
//  Created by Keith Duncan on 14/10/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import "RMUploadKit/RMUploadDocuments.h"

#import "RMUploadKit/RMUploadAvailability.h"

@class AFNetworkPacket;
@protocol AFNetworkPacketWriting;

/*!
	\brief
	
 */
@interface RMUploadDocument (RMUploadPrivate)

/*!
	\brief
	Used to convert the document into a wire format. This efficiently decomposes the document into multiple packets.
	
	\param contentTypeRef
	The MIME type of the serialised document. Must not be NULL.
	
	\param frameLengthRef
	The combined frame length of the packets. Must not be NULL.
	
	\return
	An ordered collection of <tt>AFPacket <AFPacketWriting></tt> objects which should be replayed over a write stream, nil if the document couldn't be serialised.
 */
- (NSArray *)serialisedPacketsWithContentType:(NSString **)contentTypeRef frameLength:(NSUInteger *)frameLengthRef error:(NSError **)errorRef;

/*!
	\brief
	Used to convert the document into a wire format. This efficiently decomposes the document into multiple packets.
	
	\details
	Relies on the frame length to be set externally.
	
	\param contentTypeRef
	The MIME type of the serialised document. Must not be NULL.
	
	\return
	An ordered collection of <tt>AFPacket <AFPacketWriting></tt> objects which should be replayed over a write stream, nil if the document couldn't be serialised.
 */
- (NSArray *)serialisedPacketsWithContentType:(NSString **)contentTypeRef error:(NSError **)errorRef;

/*!
	\brief
	Used to convert the document into a wire format. This inefficiently decomposes the document into a single data object.
	
	\details
	The default implementation is suitable for inheriting, it uses <tt>serialisedPacketsWithContentType:frameLength:</tt> to generate the packets, then accumulates them in an in-memory stream returning the result.
	
	\param contentTypeRef
	The MIME type of the serialised document. Must not be NULL.
	
	\return
	The serialised document, nil if the document couldn't be serialised.
 */
- (NSData *)serialisedDataWithContentType:(NSString **)contentTypeRef error:(NSError **)errorRef;

/*!
	\brief
	Common packet enumeration method, can be used to collapse the packet stream into linear data, or count the bytes in the packet stream.
 */
- (BOOL)_enumeratePacketsForCompletion:(NSArray *)packets outputStream:(NSOutputStream *)outputStream error:(NSError **)errorRef;

@end

@interface RMUploadMultipartFormDocument (RMUploadPrivate)

/*!
	\brief
	Add a file with specified content type, allowing for overrides.
 */
- (void)_addFileByReferencingURL:(NSURL *)fileLocation contentType:(NSString *)contentType filename:(NSString *)filename toField:(NSString *)fieldname;

/*!
	\brief
	Add a file inline.
	
	\details
	This is an inefficient way of uploading a file and SHOULD only be used for uploading <tt>NSXMLDocument</tt> objects as files.
 */
- (void)_addFileByIncludingData:(NSData *)fileData contentType:(NSString *)contentType filename:(NSString *)filename toField:(NSString *)fieldname;

/*!
	\brief
	Sets a flag for Twitter compatability in generating the upload document
	
	\details
	see: https://realmacsoftware.lighthouseapp.com/projects/28169/tickets/179
 */
- (void)_addTwitterCompatibility;

@end
