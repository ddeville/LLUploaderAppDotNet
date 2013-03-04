//
//  RMUploadURLConnection+Private.h
//  RMUploadKit
//
//  Created by Keith Duncan on 19/01/2011.
//  Copyright 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RMUploadKit/RMUploadURLConnection.h"

@interface RMUploadURLConnection (RMUploadPrivate)

typedef NSData * (^_RMUploadURLConnectionResponseProviderBlock)(NSURLResponse **, NSError **);

/*!
	\brief
	If you use this method, the completionBlock WILL NOT be called.
	
	\details
	The default implementation uses this implementation to call the completionBlock from the responseProviderBlock.
	The responseProvider API provides a similar to the synchronous NSURLConnection API, but is actually properly asynchronous.
 */
+ (RMUploadURLConnection *)_connectionWithRequest:(NSURLRequest *)request responseProviderBlock:(void (^)(_RMUploadURLConnectionResponseProviderBlock))responseProviderBlock;

@end
