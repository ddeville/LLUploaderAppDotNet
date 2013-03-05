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

#import "RMFoundation/RMFoundation-Macros.h"

@interface NSObject (RMAdditions)

/*!
	\brief
	This method is inspired from the Object root class but not taken over into Cocoa.
 */
- (void)subclassShouldImplementSelector:(SEL)selector RM_ANALYSER_NORETURN;

@end
