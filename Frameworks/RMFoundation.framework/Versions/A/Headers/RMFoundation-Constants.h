//***************************************************************************

// Copyright (C) 2009 Realmac Software Ltd
//
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information of Realmac Software Ltd
// and are protected by copyright law. They may not be disclosed
// to third parties or copied or duplicated in any form, in whole or
// in part, without the prior written consent of Realmac Software Ltd.

// Created by Keith Duncan on 20/05/2009

//***************************************************************************

#import <Foundation/Foundation.h>

/*!
	\brief
	This can be used to find the bundle at runtime.
 */
extern NSString *const RMFoundationBundleIdentifier;

/*!
	\brief
	This exception should be thrown when a subclass should have implemented a selector.
	It is particularly useful for plugin architectures.
 */
extern NSString *const RMSubclassResponsibilityException;

/*
	Errors
 */

enum {
	RMFoundationErrorCodeUnknown = 0,
	
	/*
		Plugins
		[-100, -199]
	 */
	RMPluginBundlesControllerErrorCodeLoadRequiresNewerFrameworkVersion = -100,
	RMPluginBundlesControllerErrorCodeInstallationRequiresRelaunch = -101,
	RMPluginBundlesControllerErrorCodeLoadRequiresRelaunch = -102,
	
	/*
		Keychain
		[-200, -299]
	 */
	RMKeychainItemErrorCodeUnknown = -200,
	RMKeychainItemErrorCodeItemNotFound = -201,
};
typedef NSInteger RMFoundationErrorCode;
