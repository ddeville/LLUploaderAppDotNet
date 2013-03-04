//***************************************************************************

// Copyright (C) 2009 Realmac Software Ltd
//
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information of Realmac Software Ltd
// and are protected by copyright law. They may not be disclosed
// to third parties or copied or duplicated in any form, in whole or
// in part, without the prior written consent of Realmac Software Ltd.

// Created by Keith Duncan on 25/03/2009

//***************************************************************************

#import <Foundation/Foundation.h>

#import "RMFoundation/RMFoundation.h"

@class RMUploadCredentials;
@class RMUploadPreset;

@class RMUploadConfinementPlugin;

extern NSString *const RMUploadPluginsControllerStoreReadOnlyOption;

extern NSString *const RMUploadPluginsControllerDestinationTypesKey;

/*!
	\brief
	This is a hybrid context object which loads specific plugin code and fetches their data from a specified disk location.
 */
@interface RMUploadPluginsController : RMPluginsController

/*!
	\brief
	Designated Initialiser.
	
	\param storeLocation
	Plugin controller will create a directory at the URL and load/store the plugin data inside.
 */
- (BOOL)loadStoreAtLocation:(NSURL *)location options:(NSDictionary *)storeOptions error:(NSError **)errorRef;

/*!
	\brief
	Persists the context data to the store location.
 */
- (BOOL)saveStore:(NSError **)errorRef;

/*
 
 */

extern NSString *const RMUploadDestinationTypePluginKey;
extern NSString *const RMUploadDestinationTypePresetClassNameKey;

/*!
	\brief
	This is extracted from the <tt>RMUploadPluginDestinationTypes</tt> key from a plugin bundle's Info.plist. See the documentation for that key.
	The objects in the collection are suitable for displaying to the user as options for creating a new preset.
	
	\details
	The RMUploadPluginDestinationTypes key is transformed into an <tt>NSSet</tt> of <tt>NSDictionary</tt> objects:
		RMUploadDestinationTypePluginKey : RMUploadPlugin, parent instance
		RMUploadDestinationTypePresetClassNameKey : NSStringFromClass([RMUploadPreset<Subclass> class])
 */
@property (readonly, nonatomic) NSSet *destinationTypes;

/*
	An internal associative array maintains string <=> destination type relationship.
	This is for dragging destination types.
 */
- (NSURL *)identifierForDestinationType:(id)destinationType;
- (id)destinationTypeForIdentifier:(NSURL *)identifier;

/*
 
 */

/*!
	\brief
	Should be used to remove a preset or credentials object from a plug-in's object graph.
	This ensures the object graph is consistent.
	
	\param object
	Can be an <tt>RMUploadPreset</tt> or <tt>RMUploadCredentials</tt> object.
 */
- (void)deleteObject:(id)object;

/*!
	\brief
	Applications should store references to presets as their URIRepresentation
	
	This method will return nil of the preset cannot be found
 */
- (RMUploadPreset *)presetForURIRepresentation:(NSURL *)URIRepresentation error:(NSError **)errorRef;

/*!
	\brief
	Upload tasks should be provided with confinement copies of presets and their authentication data
 */
- (RMUploadConfinementPlugin *)confinementForPreset:(RMUploadPreset *)preset;

@end


#if TARGET_OS_MAC && !TARGET_OS_IPHONE

/*
	Image look up behaviours
 */

@class NSImage;

@interface RMUploadPluginsController (RMUploadAppKitIntegration)

/*!
	\brief
	Returns a specific freestanding image if available, an generic one if not.
 */
+ (NSImage *)freestandingImageForDestinationType:(id)destinationType;

/*!
	\brief
	Returns a specific freestanding image if available, an generic one if not.
 */
+ (NSImage *)freestandingImageForPreset:(RMUploadPreset *)preset;

@end

@interface RMUploadPluginsController (RMUploadCourierIntegration)

/*
	\param destinationType
	Returns the default frill if the preset class doesn't provide one, or the destination type is nil.
 */
+ (NSImage *)stampBackgroundImageForDestinationType:(id)destinationType;

/*
	\param destinationType
	Returns the missing image if the preset class doesn't provide one, or the destination type is nil.
 */
+ (NSImage *)stampImageForDestinationType:(id)destinationType;

@end

#endif /* TARGET_OS_MAC && !TARGET_OS_IPHONE */
