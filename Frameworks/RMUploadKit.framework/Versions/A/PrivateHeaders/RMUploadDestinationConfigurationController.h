//
//  RMUploadDestinationConfigurationController.h
//  RMUploadKit
//
//  Created by Keith Duncan on 24/09/2009.
//  Copyright 2009 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMUploadPreset;
@class RMUploadPluginsController;

extern NSString *const RMUploadDestinationConfigurationControllerDidCompleteNotificationName;
	extern NSString *const RMUploadDestinationConfigurationControllerDidCompletePresetKey; // RMUploadPreset

enum {
	RMUploadDestinationConfigurationControllerTypeInitialSetup,
	RMUploadDestinationConfigurationControllerTypeInspect,
};
typedef NSUInteger RMUploadDestinationConfigurationControllerType;

enum {
	RMUploadDestinationConfigurationControllerConfigurationStateInvalid = 0,
	RMUploadDestinationConfigurationControllerConfigurationStateCredentialsSetup = 1,
	RMUploadDestinationConfigurationControllerConfigurationStatePresetSetup = 2,
};
typedef NSUInteger RMUploadDestinationConfigurationControllerConfigurationState;

/*!
	\brief
	Creating an configuring presets is handled by this controller.
 */
@interface RMUploadDestinationConfigurationController : NSObject

/*!
	\brief
	 
 */
- (void)configureForSetupWithDestinationType:(id)destinationType;

/*!
	\brief
	Inspect mode, the preset configuration view is shown.
 */
- (void)configureForInspectionWithPreset:(RMUploadPreset *)existingPreset configurationState:(RMUploadDestinationConfigurationControllerConfigurationState)configurationState;

extern NSString *const RMUploadDestinationConfigurationControllerCurrentViewControllerKey;
/*!
	\brief
	Should be observed and set as the content view controller of a container view controller.
 */
@property (readonly, retain, nonatomic) id currentViewController;

/*!
	\brief
	If the destination configuration controller's view controllers are being removed externally:
	- NSPopover closing
	- UINavigationController back button
	Call this method to clean up internally (forward the cancellation onto configuration view controllers so that they cancel their connections)
	It then also posts the RMUploadDestinationConfigurationControllerShouldCloseNotificationName notification.
 */
- (void)cancelConfiguration;

@end
