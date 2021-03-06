//
//  LLUploaderAppDotNetUploadTask.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetUploadTask.h"

#import "RMUploadKit/RMUploadKit+Private.h"

#import "LLAppDotNetContext.h"
#import "LLUploaderAppDotNet.h"
#import "LLUploaderAppDotNetPreset.h"

#import "LLUploaderAppDotNet-Constants.h"

@interface LLUploaderAppDotNetUploadTask () <RMUploadURLConnectionDelegate>

@property (readonly, retain, nonatomic) LLUploaderAppDotNetPreset *destination;

@property (retain, nonatomic) LLAppDotNetContext *context;

@property (retain, nonatomic) RMUploadURLConnection *metadataUploadConnection;
@property (retain, nonatomic) RMUploadURLConnection *contentUploadConnection;
@property (retain, nonatomic) RMUploadURLConnection *postConnection;

@end

@implementation LLUploaderAppDotNetUploadTask

@dynamic destination;

- (void)dealloc
{
	[_context release];
	[_metadataUploadConnection release];
	[_contentUploadConnection release];
	[_postConnection release];
	
	[super dealloc];
}

- (void)upload
{
	LLAppDotNetContext *context = [[[LLAppDotNetContext alloc] init] autorelease];
	
	NSError *authenticationError = nil;
	BOOL authenticated = [LLUploaderAppDotNet authenticateContext:context withCredentials:[[self destination] authentication] error:&authenticationError];
	if (!authenticated) {
		[self _failWithError:authenticationError];
		return;
	}
	
	[self setContext:context];
	
	[self _startFileUpload];
}

- (void)cancel
{
	[super cancel];
	
	[[self metadataUploadConnection] cancel];
	[[self contentUploadConnection] cancel];
	[[self postConnection] cancel];
	
	[self _postCompletionNotification];
}

#pragma mark - Private (Upload)

- (void)_startFileUpload
{
	NSURL *fileURL = [[self uploadInfo] valueForKey:RMUploadFileURLKey];
	
	NSError *fileUploadRequestError = nil;
	NSURLRequest *fileUploadRequest = [[self context] requestUploadFileContent:fileURL error:&fileUploadRequestError];
	if (fileUploadRequest == nil) {
		[self _failWithError:fileUploadRequestError];
		return;
	}
	
	[self setContentUploadConnection:[RMUploadURLConnection connectionWithRequest:fileUploadRequest delegate:self]];
}

- (void)_startFileMetadataUpdate:(NSString *)fileID
{
	NSError *metadataUploadRequestError = nil;
	NSURLRequest *metadataUploadRequest = [[self context] requestUploadFileMetadata:fileID title:[[self uploadInfo] valueForKey:RMUploadFileTitleKey] description:[[self uploadInfo] valueForKey:RMUploadFileDescriptionKey] tags:[[self uploadInfo] valueForKey:RMUploadFileTagsKey] privacy:[[self destination] privacy] error:&metadataUploadRequestError];
	if (metadataUploadRequest == nil) {
		[self _failWithError:metadataUploadRequestError];
		return;
	}
	
	[self setMetadataUploadConnection:[RMUploadURLConnection _connectionWithRequest:metadataUploadRequest responseProviderBlock:^ (_RMUploadURLConnectionResponseProviderBlock responseProvider) {
		[self setMetadataUploadConnection:nil];
		
		NSError *fileURLParsingError = nil;
		NSString *fileToken = nil;
		NSURL *fileURL = [LLAppDotNetContext parseUploadedFileMetadataResponseWithProvider:responseProvider fileToken:&fileToken error:&fileURLParsingError];
		if (fileURL == nil) {
			[self _failWithError:fileURLParsingError];
			return;
		}
		
		NSDictionary *notificationInfo = @{RMUploadTaskResourceLocationKey : fileURL};
		[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadTaskDidFinishTransactionNotificationName object:self userInfo:notificationInfo];
		
		[self _startPostUpdate:fileID fileToken:fileToken];
	}]];
}

- (void)_startPostUpdate:(NSString *)fileID fileToken:(NSString *)fileToken
{
	BOOL shouldPost = [[[self uploadInfo] valueForKey:LLUploaderAppDotNetMetadataPostConfirmationKey] boolValue];
	NSString *postContent = [[self uploadInfo] valueForKey:LLUploaderAppDotNetMetadataPostContentKey];
	
	if (!shouldPost || [postContent length] == 0) {
		[self _postCompletionNotification];
		return;
	}
	
	NSString *fileUTI = (NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[[[self uploadInfo] fileURL] pathExtension], NULL);
	
	NSError *postRequestError = nil;
	NSURLRequest *postRequest = [[self context] requestPost:postContent fileID:fileID fileToken:fileToken fileUTI:fileUTI error:&postRequestError];
	if (postRequest == nil) {
		[self _failWithError:postRequestError];
		return;
	}
	
	[self setPostConnection:[RMUploadURLConnection _connectionWithRequest:postRequest responseProviderBlock:^ (_RMUploadURLConnectionResponseProviderBlock responseProvider) {
		[self setPostConnection:nil];
		
		NSError *postParsingError = nil;
		NSString *postID = [LLAppDotNetContext parsePostResponseWithProvider:responseProvider error:&postParsingError];
		if (postID == nil) {
			[self _failWithError:postParsingError];
			return;
		}
		
		[self _postCompletionNotification];
	}]];
}

#pragma mark - Private

- (void)_failWithError:(NSError *)error
{
	if ([[error domain] isEqualToString:LLUploaderAppDotNetErrorDomain] && [error code] == LLUploaderAppDotNetErrorCodeInvalidCredentials) {
		NSDictionary *errorInfo = @{
			NSLocalizedDescriptionKey : [error localizedDescription],
			NSLocalizedRecoverySuggestionErrorKey : [error localizedRecoverySuggestion],
			NSUnderlyingErrorKey : error,
		};
		error = [NSError errorWithDomain:RMUploadKitBundleIdentifier code:RMUploadCredentialsErrorRequiresReauthentication userInfo:errorInfo];
	}
	
	NSDictionary *notificationInfo = @{RMUploadTaskErrorKey : error};
	[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadTaskDidFinishTransactionNotificationName object:self userInfo:notificationInfo];
	
	[self _postCompletionNotification];
}

- (void)_postCompletionNotification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadTaskDidCompleteNotificationName object:self];
}

#pragma mark - RMUploadURLConnectionDelegate

- (void)connection:(RMUploadURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	NSDictionary *notificationInfo = @{
		RMUploadTaskProgressCurrentKey : @(totalBytesWritten),
		RMUploadTaskProgressTotalKey : @(totalBytesExpectedToWrite),
	};
	[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadTaskDidReceiveProgressNotificationName object:self userInfo:notificationInfo];
}

- (void)connection:(RMUploadURLConnection *)connection didCompleteWithData:(NSData *)responseData
{
	LLAppDotNetResponseProvider responseProvider = ^ NSData * (NSURLResponse **responseRef, NSError **errorRef) {
		if (responseRef != NULL) {
			*responseRef = [connection receivedResponse];
		}
		return responseData;
	};
	
	NSError *fileIDParsingError = nil;
	NSString *fileID = [LLAppDotNetContext parseUploadFileContentResponseWithProvider:responseProvider error:&fileIDParsingError];
	if (fileID == nil) {
		[self _failWithError:fileIDParsingError];
		return;
	}
	
	[self _startFileMetadataUpdate:fileID];
}

- (void)connection:(RMUploadURLConnection *)connection didFailWithError:(NSError *)error
{
	[self _failWithError:error];
}

@end
