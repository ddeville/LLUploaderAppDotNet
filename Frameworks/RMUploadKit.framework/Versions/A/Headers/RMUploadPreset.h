//***************************************************************************

// Copyright (C) 2009 Realmac Software Ltd
//
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information of Realmac Software Ltd
// and are protected by copyright law. They may not be disclosed
// to third parties or copied or duplicated in any form, in whole or
// in part, without the prior written consent of Realmac Software Ltd.

// Created by Keith Duncan on 26/03/2009

//***************************************************************************

#import <Foundation/Foundation.h>

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#endif /* !TARGET_OS_IPHONE */

#import "RMUploadKit/RMUploadAvailability.h"
#import "RMUploadKit/AFPropertyListProtocol.h"

@class RMUploadCredentials;
@class RMUploadPlugin;

/*!
	\file
 */

/*
	Instance Keys
 */

extern NSString *const RMUploadPresetDirtyKey;

extern NSString *const RMUploadPresetUserIdentifierKey;

extern NSString *const RMUploadPresetAcceptedTypesKey;

/*
	Class Keys
 */

extern NSString *const RMUploadPresetClassLocalisedNameKey;

/*
 
 */

/*!
	\brief
	A representation of configurable options for a service.
 */
@interface RMUploadPreset : NSObject <AFPropertyList>

/*!
 \brief The designated initialiser
 
 Called when the framework wishes to create a new preset instead of loading one from disk.
 */
- (id)init;

/*!
	\brief
	Initialise a preset from a serialised representation.
	
	We provide you with the representation that you return in <tt>propertyListRepresentation</tt> to hand off to the framework for saving.
	
	If you follow the <tt>-propertyListRepresentation</tt> example implementation, be sure to pass only the superclass representation to the superclass inititializer.
 
	An example implementation would be:
\code
- (id)initWithPropertyListRepresentation:(id)values {
	id superRepresentation = [values objectForKey:@"super"];

	self = [super initWithPropertyListRepresentation:superRepresentation];
	if (self == nil) return nil;
	
	[self setProperty:[values objectForKey:@"myKey"]];
	
	return self;
}
\endcode
 
	\param values
	The property list representation that was returned from <tt>propertyListRepresentation</tt>.
 */
- (id)initWithPropertyListRepresentation:(id)values;

/*!
	\brief
	A representation of the instance that can be saved to a plist.
	
	In order to save presets they will be turned into a plist, therefore here you need to return a representation of your object that can be saved safely into one. You must also call the super's implementation at the top of the method.
	
	It is essential that you include, and namespace the representation of the superclass. You <b>must not</b> assume the class of the superclass' representation, simply that it is suitable for inclusion in a property list written to disk.
	
	An example implementation would be:
\code
- (id)propertyListRepresentation {
	id superRepresentation = [super propertyListRepresentation];

	NSMutableDictionary *propertyListRepresentation = [NSMutableDictionary dictionary];
	[propertyListRepresentation setObject:superRepresentation forKey:@"super"];

	[propertyListRepresentation setValue:[self property] forKey:@"myKey"];

	return propertyListRepresentation;
}
\endcode
 */
- (id)propertyListRepresentation;

/*!
	\brief
	The credentials the preset should use. This is a to-one relationship.
 */
@property (readonly, assign, nonatomic) RMUploadCredentials *authentication;

/*!
	\brief
	The plugin that owns the preset.
 */
@property (readonly, assign, nonatomic) RMUploadPlugin *plugin;

/*!
	\brief
	Set this key to <tt>YES</tt> to cause the preset to be persisted to disk.
	
	This method is observed using key-value observing, when triggered your account will be saved.
	
	\details
	If you want to trigger a save automatically, you can return dependent keys in <tt>+keyPathsForValuesAffectingValueForKey:</tt> ensuring that you include the results from super.
 */
@property (getter=isDirty, nonatomic) BOOL dirty;

/*!
	\brief
	The UTTypes that the account supports.
	
	This method is <b>required</b>.
	
	The default implementation returns an empty set.
	
	\return
	A set of UTType strings which the preset supports.
 */
@property (readonly, nonatomic) NSSet *acceptedTypes;

/*!
	\brief
	This method <b>must</b> return a valid, non-nil <tt>NSURL</tt>.
	
	Overriding this method is optional <em>if</em> it can construct the <tt>NSURL</tt> from your Info.plist.
	If the preset's plug-in whose bundle's <tt>RMUploadPluginServiceHostKey</tt> is nil, it will throw an exception.
	
	\details
	This is used to graph and determine the geographical destination of the files.
 */
@property (readonly, nonatomic) NSURL *serviceURL;

/*!
	\brief
	This is the user provided userIdentifier for the preset.
	
	\details
	Default implementation will return the userIdentifier of the presetCredentials, unless overridden by setUserIdentifier;
 */
@property (copy, nonatomic) NSString *userIdentifier;

@end


/*!
	\brief
	These methods are used for preset setup and presentation.
 */
@interface RMUploadPreset (RMUploadMetadata)

/*!
	\brief
	Used to determine if your preset requires credentials, and which credentials it can share with other preconfigured presets.
	
	\details
	The default implementation returns Nil, return an RMUploadCredentials class if you support credentials.
 */
+ (Class)credentialsClass;

/*!
	\brief
	The <tt>RMUploadTask</tt> class for this preset.
	
	This method is <b>required</b>, if not implemented the framework throws an exception.
	
	\return
	An <tt>RMUploadTask</tt> subclass.
 */
+ (Class)uploadTaskClass;

/*!
	\brief
	The name for the preset type, preferably localised.
 */
+ (NSString *)localisedName;

/*!
	\brief
	The icon name for the destination type.
 */
+ (NSString *)iconResource;

@end


/*!
	\brief
	These are Courier only APIs, they have no effect on the functionality of your plugin.
 */
@interface RMUploadPreset (RMUploadCourierIntegration)

/*!
	\brief
	If you include envelope images in your uploader, you can override this method to return the key from the <tt>DSTrayBundleImages</tt> element that should be autoselected for your preset.
	
	\details
	Envelope images included in the uploader plugins aren't presented for selection in the interface, they are only available for autoselection.
	
	\return
	Returns nil by default.
 */
+ (NSString *)autoselectTrayImageKey;

@end

#if !TARGET_OS_IPHONE

/*!
	\brief
	These methods are deprecated and <b>should not</b> be used.
*/
@interface RMUploadPreset (RMUploadDeprecated)

/*!
	\brief
	The icon for the destination type. This image should be square and <em>at least</em> 100px in dimension.
	Any decoration added is application specific.
	
	\details
	This was deprecated to remove the assumption that `[NSBundle bundleForClass:]` returns the correct bundle in all cases.
 */
+ (NSImage *)icon AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_0_AND_LATER_BUT_DEPRECATED_IN_RMUPLOADKIT_FRAMEWORK_VERSION_1_1;

/*!
	\brief
	This was deprecated to remove the assumption that `[NSBundle bundleForClass:]` returns the correct bundle in all cases.
 */
+ (NSURL *)serviceURL AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_0_AND_LATER_BUT_DEPRECATED_IN_RMUPLOADKIT_FRAMEWORK_VERSION_1_1;

extern NSString *const RMUploadPresetNameKey AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_0_AND_LATER_BUT_DEPRECATED;
/*!
	\brief
	This is the user provided name for the preset.
	
	\details
	This has been replaced with <tt>userIdentifier</tt>, values stored as this property are loaded into <tt>userIdentifier</tt>.
 */
@property (copy, nonatomic) NSString *name AVAILABLE_RMUPLOADKIT_FRAMEWORK_VERSION_1_0_AND_LATER_BUT_DEPRECATED;

@end

#endif /* !TARGET_OS_IPHONE */
