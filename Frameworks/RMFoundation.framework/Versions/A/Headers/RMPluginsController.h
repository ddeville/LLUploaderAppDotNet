//***************************************************************************

// Copyright (C) 2009 Realmac Software Ltd
//
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information of Realmac Software Ltd
// and are protected by copyright law. They may not be disclosed
// to third parties or copied or duplicated in any form, in whole or
// in part, without the prior written consent of Realmac Software Ltd.

// Created by Keith Duncan on 22/05/2009

//***************************************************************************

#import <Foundation/Foundation.h>

extern NSString *const RMPluginsControllerPluginsIndexKey;
extern NSString *const RMPluginsControllerPluginsKey;

/*!
	\brief
	This is an abstract class which is likely to be of little use on it's own.
 */
@interface RMPluginsController : NSObject

/*!
	\brief
	If you support concurrent plugin loading, return YES from this method.
 
	\details
	This may be ignored, depending on the implementation state of the plugins controller, it simply indicates that the subclass supports concurrent initialization.
 */
+ (BOOL)canConcurrentlyLoadPlugins;

/*!
	\brief
	Typically called from the bundles controller.
 */
- (BOOL)loadPluginsFromBundle:(NSBundle *)bundle error:(NSError **)errorRef;

/*!
	\brief
	If called by <tt>-loadPluginsFromBundle:errors:</tt> it might be called on a background queue. Your custom implementation shouldn't assume it's execution environment.
 
	Override this to <b>actually</b> instantiate plugin(s), <tt>-loadPlugins:</tt> method uses this for each of the bundles in <tt>+[RMPluginController allPluginBundles:]</tt>.
	The default implementation instantiates the NSPrincipalClass using -init which is rarely applicable, but may be useful in simple cases.
	You should perform your validity checks in this method.
	
	\details
	It doesn't check that the bundle identifier hasn't already been loaded you MUST NOT try to reload a plugin using this method.
	This method loads the current accounts from disk, but it doesn't observe the plugin for changes. This allows for plugins to be used outside the account sharing environment.
 */
- (NSSet *)initializePluginsFromBundle:(NSBundle *)bundle error:(NSError **)errorRef;

/*!
	\brief
	Plugins returned from <tt>initializePluginsFromBundle:error:</tt> are stored in this property indexed by the bundle they came from.
 */
@property (readonly, nonatomic) NSDictionary *pluginsIndex;

/*!
	\brief
	Flattened collection from the pluginsIndex.
 */
@property (readonly, nonatomic) NSSet *plugins;

@end
