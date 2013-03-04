//
//  RMUploadPresetConfigurationViewController+Constants.h
//  RMUploadKit
//
//  Created by Damien DeVille on 11/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\file
 */

/*!
	\brief
	Post this once you have completed your work in <tt>-nextStage:</tt> to signal a change in the advancement status.
	
	\details
	If your validation succeeded, post it with an empty userInfo.
	If an error occurs, return it under the error <tt>RMUploadDestinationConfigurationViewControllerCompletionErrorKey</tt> to signal that the view cannot advance.
	
	If your error has domain RMUploadKitBundleIdentifier and code RMUploadPresetConfigurationViewControllerErrorValidation, the error isn't presented, the view doesn't advance and the 'next' button is re-enabled. Use this for a validation error. This error should be used in conjunction with <tt>-[RMUploadPresetConfigurationViewController highlightErrorInView:]</tt>.
 */
extern NSString *const RMUploadPresetConfigurationViewControllerDidCompleteNotificationName;
/*!
	\brief
	An <tt>NSError</tt> object, included in the <tt>RMUploadPresetConfigurationViewControllerDidCompleteNotificationName</tt> <tt>userInfo</tt> dictionary.
 */
extern NSString *const RMUploadPresetConfigurationViewControllerDidCompleteErrorKey;

/*
 *	Keys
 */

extern NSString *const RMUploadPresetConfigurationViewControllerLocalisedAdvanceButtonTitleKey;
