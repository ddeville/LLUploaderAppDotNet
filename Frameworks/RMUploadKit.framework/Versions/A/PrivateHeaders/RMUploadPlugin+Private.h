//
//  RMUploadPlugin+Private.h
//  RMUploadKit
//
//  Created by Keith Duncan on 16/01/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import "RMUploadKit/RMUploadPlugin.h"

@class RMUploadPreset;
@class RMUploadTask;

/*!
	\brief
	
 */
@interface RMUploadPlugin (RMUploadPrivate)

/*!
	\brief
	This method creates a new preset of the given preset class for the plugin.
 */
- (RMUploadPreset *)_presetWithClass:(Class)presetClass;

/*!
	\brief
	This exposes the element acceptance check logic separately for preflighting.
	
	\details
	If NO is returned, the errorRef will be populated. The error has a <tt>localizedFailureReason</tt>  that is suitable for including in other errors.
 */
+ (BOOL)_validatePreset:(RMUploadPreset *)preset acceptsUploadInfo:(id)uploadInfo error:(NSError **)errorRef;

/*!
	\brief
	This is private to ensure that plugin developers don't override it. Overrides provide them with two locations to filter the uploadInfos into tasks, the acceptedTypes and this method - we want both approaches to be consistent.
	Used to return instances of your upload task class when about to upload the passed uploadInfo objects.
 */
+ (RMUploadTask *)_generateUploadTaskForPreset:(RMUploadPreset *)preset uploadInfo:(id)uploadInfo error:(NSError **)errorRef;

/*!
	\brief
	Allows a plugin to restrict the preset types at runtime.
	
	\return
	Either an `NSString` object, or an `NSArray` of `NSString` objects, which can be provided to NSClassFromString
 */
- (id)_destinationTypes;

/*!
	\brief
	Allows a plugin to filter it's credentials at load time, throwing out duplicates and expired copies.
 */
- (void)_setCredentials:(NSSet *)credentials withPresets:(NSSet *)presets;

extern NSString *const _RMUploadPluginHasExpiredKey;
/*!
	\brief
	Plugins that have expired (not available anymore, such as MobileMe) should return YES.
	
	NO by default.
 */
- (BOOL)_hasExpired;

@end
