//***************************************************************************

// Copyright (C) 2009 Realmac Software Ltd
//
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information of Realmac Software Ltd
// and are protected by copyright law. They may not be disclosed
// to third parties or copied or duplicated in any form, in whole or
// in part, without the prior written consent of Realmac Software Ltd.

// Created by Danny Greg on 24/7/2009 

//***************************************************************************

#import <Foundation/Foundation.h>

#import "RMUploadKit/RMUploadAvailability.h"

/*!
	\file
 */

//***************************************************************************

typedef void (^RMUploadURLConnectionCompletionBlock)(NSData *responseData, NSError *responseError);

//***************************************************************************

@protocol RMUploadURLConnectionDelegate;

/*!
	\brief
	A replacement for <tt>NSURLConnection</tt>, wrapping it with a different API.
	
	This is a single-shot class, sending more than one request using it will throw an exception.
	
	It uses a similar delegate system as NSURLConnection but provides different information as you go.
	
	The connection is implicitly scheduled in the current run loop.
*/
@interface RMUploadURLConnection : NSObject

/*!
	\brief
	Convenience constructor.
 */
+ (RMUploadURLConnection *)connectionWithRequest:(NSURLRequest *)request delegate:(id <RMUploadURLConnectionDelegate>)delegate;

/*!
	\brief
	Convenience constructor.
 */
+ (RMUploadURLConnection *)connectionWithRequest:(NSURLRequest *)request completionBlock:(RMUploadURLConnectionCompletionBlock)completionBlock;

/*!
	\brief
	The connection's delegate.
 */
@property (assign, nonatomic) id <RMUploadURLConnectionDelegate> delegate;

/*!
	\brief
	A block called when the connection completes, either successfully or unsuccessfully.
	
	\details
	Both this block and the delegate method <tt>-connection:didFailWithError:</tt> or <tt>-connection:didCompleteWithData:</tt> are invoked on connection completion.
 */
@property (copy, nonatomic) RMUploadURLConnectionCompletionBlock completionBlock;

/*!
	\brief
	Convenience property to associate any userInfo, handy for delegate callbacks.
 */
@property (retain, nonatomic) id userInfo;

/*!
	\brief
	Set to YES when the connection has finished or has received an error.
 */
@property (readonly, nonatomic) BOOL completed;

/*!
	\brief
	The response received is held you to you use in the completion notifications.
 */
@property (readonly, retain, nonatomic) NSURLResponse *receivedResponse AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_1_AND_LATER;

/*!
	\brief
	Sends the provided request, the delegate will begin to receive notifications.
	
	\param request
	An <tt>NSURLRequest</tt> that you wish to send.
*/
- (void)sendURLRequest:(NSURLRequest *)request;

/*!
	\brief
	Cancels the connection.
	
	\details
	The <tt>delegate</tt> will not receive any further callbacks.
	The <tt>completionBlock</tt> will not be invoked.
*/
- (void)cancel;

@end

/*!
	\brief
	The delegate for <tt>RMUploadURLConnection</tt>.
*/
@protocol RMUploadURLConnectionDelegate <NSObject>

 @optional

/*!
	\brief
	Behaves identically to the <tt>NSURLConnection</tt> delegate equivalent.
	
	\details
	Only guaranteed to be sent from RMUploadKit version 1.1 and greater.
 */
- (NSURLRequest *)connection:(RMUploadURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_1_AND_LATER;

/*!
	\brief
	Behaves identically to the <tt>NSURLConnection</tt> delegate equivalent.
 */
- (void)connection:(RMUploadURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

/*!
	\brief
	Behaves identically to the <tt>NSURLConnection</tt> delegate equivalent.
	
	\details
	Only guaranteed to be sent for all authentication challenges in RMUploadKit version 1.1 and greater.
	
	We only support `Basic' and `Digest' authentication methods. Please file an enhancement request if you require support for other authentication methods.
 */
- (BOOL)connection:(RMUploadURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_1_AND_LATER;

/*!
	\brief
	Behaves identically to the <tt>NSURLConnection</tt> delegate equivalent.
 */
- (void)connection:(RMUploadURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

/*!
	\brief
	Behaves identically to the <tt>NSURLConnection</tt> delegate equivalent.
 */
- (void)connection:(RMUploadURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

/*!
	\brief
	Behaves identically to the <tt>NSURLConnection</tt> delegate equivalent.
 */
- (void)connection:(RMUploadURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

/*!
	\brief
	
 */
- (void)connection:(RMUploadURLConnection *)connection didReceiveDataOfLength:(NSUInteger)length AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_1_AND_LATER;

 @required

/*!
	\brief
	Sent if the request fails, providing an NSError with the cause.
	
	\param connection
	The <tt>RMUploadURLConnection</tt> sending the message.
	
	\param error
	An <tt>NSError</tt> object representing the error that caused the connection to fail.
 */
- (void)connection:(RMUploadURLConnection *)connection didFailWithError:(NSError *)error;

/*!
	\brief
	Sent once the connection completes successfully.
	
	\param connection
	The <tt>RMUploadURLConnection</tt> sending the message.
	
	\param data
	The response <tt>NSData</tt> returned by the server.
 */
- (void)connection:(RMUploadURLConnection *)connection didCompleteWithData:(NSData *)responseData;

@end


/*!
	\brief
	These methods are deprecated and <b>should not</b> be implemented.
 */
@protocol RMUploadURLConnectionDelegateDeprecated <NSObject>

/*!
	\brief
	Called periodically as a download progresses.
	
	\details
	You will only receive this notification for downloads of determinate length.
	
	\param connection
	The <tt>RMUploadURLConnection</tt> sending the message.
	
	\param currentProgress
	The current progress, between 0.0 and 1.0.
	
	\deprecated
	Use <tt>-[NSURLResponse expectedContentLength]</tt> and <tt>-connection:didReceiveDataOfLength:</tt> to calculate download progress.
	This message will not be sent if <tt>-connection:didReceiveDataOfLength:</tt> is implemented.
 */
- (void)connection:(RMUploadURLConnection *)connection downloadProgressed:(float)currentProgress DEPRECATED_IN_RMUPLOADKIT_FRAMEWORK_VERSION_1_1_AND_LATER;

/*!
	\brief
	Called periodically as an upload progresses.
	
	\param connection
	The <tt>RMUploadURLConnection</tt> sending the message.
	
	\param currentProgress
	The current progress, between 0.0 and 1.0.
	
	\deprecated
	Implement <tt>-connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:</tt> for accurate progress notifications.
	This message will not be sent if <tt>-connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:</tt> is implemented.
 */
- (void)connection:(RMUploadURLConnection *)connection uploadProgressed:(float)currentProgress DEPRECATED_IN_RMUPLOADKIT_FRAMEWORK_VERSION_1_1_AND_LATER;

@end

/*!
	\brief
	These methods are deprecated and <b>should not</b> be used.
 */
@interface RMUploadURLConnection (RMUploadDeprecated)

/*!
	\brief
	This method is deprecated, use <tt>+[NSURLRequest getRequestWithParameters:toURL:]</tt> instead.
 */
- (void)sendGetRequestWithParameters:(NSDictionary *)parameters toURL:(NSURL *)url RMUPLOADKIT_DEPRECATED_ATTRIBUTE;

/*!
	\brief
	This method is deprecated, use <tt>+[NSURLRequest filePostRequestWithParameters:toURL:]</tt> instead.
 */
- (void)sendFilePostRequestWithParameters:(NSArray *)parameters toURL:(NSURL *)url RMUPLOADKIT_DEPRECATED_ATTRIBUTE;

/*!
	\brief
	This method is deprecated, use <tt>+[NSURLRequest postRequestWithParameters:toURL:]</tt> instead.
 */
- (void)sendPostRequestWithParameters:(NSDictionary *)parameters toURL:(NSURL *)url RMUPLOADKIT_DEPRECATED_ATTRIBUTE;

@end
