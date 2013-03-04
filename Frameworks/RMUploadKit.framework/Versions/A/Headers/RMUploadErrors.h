//
//  RMUploadErrors.h
//  RMUploadKit
//
//  Created by Keith Duncan on 05/08/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	These correspond to the <tt>RMUploadKitBundleIdentifier</tt> domain.
 */
enum {
	/* */
	RMUploadErrorUnknown = 0,
	
	/* [-100, -199] */
	/*
		Note
		
		when synchronous validation of the view controller's fields is possible i.e. a field cannot be blank
		re-enable configuration view buttons after validation failed, this error isn't presented
		
		you should couple the use of this error with <tt>-[RMUploadPresetConfigurationViewController highlightErrorInView:]</tt>.
		
		If you include an error recovery attempter, it will be ignored.
	 */
	RMUploadPresetConfigurationViewControllerErrorValidation = -100,
	
	/* [-200, -299] */
	/*
		Note
		
		credential re-authentication is required
		
		this error code is context specific, if returned from -
		
		- credential configuration view controller, the controller remains presented
		- preset configuration view controller, the credentials view controller is presented
		- upload task, the credentials view controller is shown and the task retried if success
		
		If you include an error recovery attempter, it will be ignored.
	 */
	RMUploadCredentialsErrorRequiresReauthentication = -200,
	
	/* [-300, -399] */
	/*
		Note
		
		preset re-configuration is required
		
		this error code is context specific, if returned from -
		
		- preset configuration view controller, the preset configuration view controller remains presented
		- upload task, the preset configuration view is shown, and the task retried if success
		
		If you include an error recovery attempter, it will be ignored.
	 */
	RMUploadPresetErrorRequiresReconfiguration = -300,
};
typedef NSInteger RMUploadKitErrorCode;
