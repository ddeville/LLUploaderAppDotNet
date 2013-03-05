//***************************************************************************

// Copyright (C) 2009 Realmac Software Ltd
//
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information of Realmac Software Ltd
// and are protected by copyright law. They may not be disclosed
// to third parties or copied or duplicated in any form, in whole or
// in part, without the prior written consent of Realmac Software Ltd.

// Created by Danny Greg on 15/03/2010. 

//***************************************************************************

#import <Foundation/Foundation.h>

@class RMPluginsController;

/*!
	\brief
	Setting this option to kCFBooleanTrue in the options dictionary will cause invocations of <tt>-loadPlugins:errors:</tt> to ignore plugins external to the host application's <tt>+[NSBundle builtInPlugInsURL]</tt>.
	
	\details
	If the option isn't specified or the options dictionary is nil, all plugins are loaded.
 */
extern NSString *const RMPluginBundlesControllerLoadInternalOnlyOption;
extern NSString *const RMPluginBundlesControllerAdditionalURLsLookUpKey;	// An NSArray of NSURL objects

extern NSString *const RMPluginBundlesControllerBundleTypeKey;

/*!
	\brief
	Plug-in bundles controller manages the `NSBundle` instances from which plug-ins can be instantiated
 */
@interface RMPluginBundlesController : NSObject

/*!
	\brief
	Contains some default plugin search locations other than the Realmac plugin repository.
	
	\details
	This can be overrided by any subclasses looking to add their own custom search locations.
 */
+ (NSArray *)bundleSearchLocations;

/*
	Override Methods
 */

/*!
	\brief
	Should be overridden by subclasses to specify what extension the bundles we are loading are.
*/
+ (NSString *)bundleType;

/*!
	\brief
	Bundle controllers have a plugins controller, allowing for an included global plugins controller.
 */
+ (Class)pluginsControllerClass;

/*
	Common Interface
 */

/*!
	\brief
	Looks through all plugin locations etc. and loads bundles.
	
	\details
	This also contains our fancy logic to navigate our versioned plugin repository.
*/
- (void)loadPluginBundlesWithOptions:(NSDictionary *)options errors:(NSArray **)errorsRef;

/*!
	\brief
	Overridden by subclasses that decide whether a bundle should be loaded.
	
	\details
	An override is optional, subclasses should call super first.
 */
- (BOOL)validatePluginBundleAtLocation:(NSURL *)bundleLocation error:(NSError **)errorRef;

/*!
	\brief
	Called by `-validatePluginBundleAtLocation:error:` and provided as an override point.
	
	\details
	The error returned by this method IS NOT presented to the user, this is expected to be a developer level error.
	RMPluginBundlesController will wrap any errrors returned in a presentable fashion.
 */
- (BOOL)validatePluginInfoDictionary:(NSDictionary *)infoDictionary error:(NSError **)errorRef;

/*!
	\brief
	If you install a new plugin at runtime, call this method to perform the global initialization.
	
	\details
	This calles -validateBundleAtLocation:error: for you.
	
	A bundle will NOT be re-loaded if the <tt>bundleIndex</tt> already contains the bundle identifier, it will return an error.
	
	Once it's been checked that the bundle hasn't already been loaded into this plugin controller, it performs a preflight operation on the bundle.
 */
- (BOOL)loadPluginBundleAtLocation:(NSURL *)bundleLocation error:(NSError **)errorRef;

/*!
	\brief
	If we have already loaded a bundle with the passed ID we will return it here.
	
	\details
	Returns nil if nothing with that ID has been loaded.
*/
- (NSBundle *)loadedBundleForIdentifier:(NSString *)bundleIdentifier;

/*!
	\brief
	Any currently loaded bundles for this controller.
 */
- (NSSet *)loadedBundleInstances;

/*!
	\brief
	The default plugins controller, loaded bundles will be passed onto this controller.
 */
@property (readonly, nonatomic) /* RMPluginsController* */ id pluginsController;

@end
