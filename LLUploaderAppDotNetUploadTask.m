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

@property (retain, nonatomic) RMUploadURLConnection *appDotNetConnection;

@end

@implementation LLUploaderAppDotNetUploadTask

@dynamic destination;

- (void)dealloc
{
	[_context release];
	[_appDotNetConnection release];
	
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
	
	[self _continueUpload];
}

- (void)cancel
{
	[super cancel];
	
	[[self appDotNetConnection] cancel];
	
	[self _postCompletionNotification];
}

#pragma mark - Private

- (void)_continueUpload
{
	NSURL *fileURL = [[self uploadInfo] valueForKey:RMUploadFileURLKey];
	NSString *title = [[self uploadInfo] valueForKey:RMUploadFileTitleKey];
	id description = [[self uploadInfo] valueForKey:RMUploadFileDescriptionKey];
	NSArray *tags = [[self uploadInfo] valueForKey:RMUploadFileTagsKey];
	LLUploaderAppDotNetPresetPrivacy privacy = [[self destination] privacy];
	
	NSError *requestUploadError = nil;
	NSURLRequest *requestUpload = [[self context] requestUploadFileAtURL:fileURL title:title description:description tags:tags privacy:privacy error:&requestUploadError];
	if (requestUpload == nil) {
		[self _failWithError:requestUploadError];
		return;
	}
	
	[self setAppDotNetConnection:[RMUploadURLConnection connectionWithRequest:requestUpload delegate:self]];
}

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
	RMAppDotNetResponseProvider responseProvider = ^ NSData * (NSURLResponse **responseRef, NSError **errorRef) {
		if (responseRef != NULL) {
			*responseRef = [connection receivedResponse];
		}
		return responseData;
	};
	
	NSError *postLocationError = nil;
	NSURL *postLocation = [LLAppDotNetContext parseUploadFileResponseWithProvider:responseProvider error:&postLocationError];
	if (postLocation == nil) {
		[self _failWithError:postLocationError];
		return;
	}
	
	NSDictionary *notificationInfo = @{RMUploadTaskResourceLocationKey : postLocation};
	[[NSNotificationCenter defaultCenter] postNotificationName:RMUploadTaskDidFinishTransactionNotificationName object:self userInfo:notificationInfo];
	
	[self _postCompletionNotification];
}

- (void)connection:(RMUploadURLConnection *)connection didFailWithError:(NSError *)error
{
	[self _failWithError:error];
}

@end
