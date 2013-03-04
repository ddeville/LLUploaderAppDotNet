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

#import "RMFoundation/RMFoundation.h"

@class RMUploadPluginsController;

@interface RMUploadPluginBundlesController : RMPluginBundlesController

+ (id)sharedInstance;

@property (readonly, nonatomic) RMUploadPluginsController *pluginsController;

@end
