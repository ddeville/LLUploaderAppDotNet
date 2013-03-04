//
//  RMUploadMacros.h
//  RMUploadKit
//
//  Created by Keith Duncan on 28/04/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__clang__) && (__clang_major__ >= 3)

	#define RMUPLOAD_PROPERTY_ATOMIC atomic

#else

	#define RMUPLOAD_PROPERTY_ATOMIC

#endif /* defined(__clang__) && (__clang_major__ >= 3) */
