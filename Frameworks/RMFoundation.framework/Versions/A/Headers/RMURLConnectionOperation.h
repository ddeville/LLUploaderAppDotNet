//
//  RMURLConnectionOperation.h
//  RMFoundation
//
//  Created by Damien DeVille on 10/04/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMURLConnectionOperation : NSOperation

- (id)initWithRequest:(NSURLRequest *)request;

@property (readonly, copy, nonatomic) NSURLRequest *request;
@property (readonly, copy, nonatomic) NSURLResponse *response;

@property (readonly, retain, nonatomic) NSError *connectionError;

@property (retain, nonatomic) NSOutputStream *outputStream;	// if no output stream is provided, a default one writing to memory will be created. You can retrieve the data on completion with -propertyForKey:NSStreamDataWrittenToMemoryStreamKey on the stream.

typedef NSData * (^RMURLConnectionOperationResponseProvider)(NSURLResponse **, NSError **);	// you should not rely on the response provider if you provide your own output stream since it will return nil.
@property (readonly, copy, nonatomic) RMURLConnectionOperationResponseProvider responseProvider;

typedef void (^RMURLConnectionOperationAuthenticationChallengeHandler) (NSURLAuthenticationChallenge *challenge);
@property (copy, nonatomic) RMURLConnectionOperationAuthenticationChallengeHandler authenticationChallengeHandler;

typedef BOOL (^RMURLConnectionOperationResponseHandler) (NSURLResponse *response);	// returning NO will cancel the connection and the operation.
@property (copy, nonatomic) RMURLConnectionOperationResponseHandler responseHandler;

typedef void (^RMURLConnectionOperationDownloadProgressHandler) (NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead);
@property (copy, nonatomic) RMURLConnectionOperationDownloadProgressHandler downloadProgressHandler;

typedef void (^RMURLConnectionOperationUploadProgressHandler) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);
@property (copy, nonatomic) RMURLConnectionOperationUploadProgressHandler uploadProgressHandler;

@end
