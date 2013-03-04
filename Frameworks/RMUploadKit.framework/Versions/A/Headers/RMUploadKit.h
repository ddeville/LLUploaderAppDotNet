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

// Model

#import "RMUploadKit/AFPropertyListProtocol.h"

#import "RMUploadKit/RMUploadPlugin.h"
#import "RMUploadKit/RMUploadPreset.h"
#import "RMUploadKit/RMUploadCredentials.h"

// Controller

#if !TARGET_OS_IPHONE
	#import "RMUploadKit/RMUploadPresetConfigurationViewController.h"
	#import "RMUploadKit/RMUploadMetadataConfigurationViewController.h"
#else
	#import "RMUploadKit/RMUploadPresetConfigurationViewController~UIKit.h"
	#import "RMUploadKit/RMUploadMetadataConfigurationViewController~UIKit.h"
#endif /* !TARGET_OS_IPHONE */

// View

#if !TARGET_OS_IPHONE
	#import "RMUploadKit/RMUploadPopupButtonCell.h"
	#import "RMUploadKit/RMUploadButtonCell.h"
	#import "RMUploadKit/RMUploadTextCell.h"
#else
	#import "RMUploadKit/RMUploadTouchViewControllerAppearanceProtocol.h"
	#import "RMUploadKit/RMUploadTableViewCell.h"
	#import "RMUploadKit/RMUploadTextInputTableViewCell.h"
	#import "RMUploadKit/RMUploadSwitchInputTableViewCell.h"
#endif /* !TARGET_OS_IPHONE */

// Upload

#import "RMUploadKit/RMUploadTask.h"

#import "RMUploadKit/RMUploadURLConnection.h"
#import "RMUploadKit/NSURLRequest+RMUploadAdditions.h"

#import "RMUploadKit/RMUploadDocuments.h"
#import "RMUploadKit/RMUploadURLEncodedDocument.h"

// Other

#import "RMUploadKit/RMUploadConstants.h"
#import "RMUploadKit/RMUploadErrors.h"
#import "RMUploadKit/RMUploadAvailability.h"
#import "RMUploadKit/RMUploadMacros.h"
