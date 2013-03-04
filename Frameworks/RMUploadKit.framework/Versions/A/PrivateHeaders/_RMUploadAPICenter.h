//
//  _RMUploadAPICenter.h
//  RMUploadKit
//
//  Created by Keith Duncan on 19/05/2011.
//  Copyright 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	Passive class used to load API details from host applications.
	
	\details
	The host doesn't have to register anything with this object.
	It should include a Plist dictionary document in it's binary, in the __RMUPLOAD,__api section.
	
	The main function in the host application has to be made __attribute__((visibility("default")))
	to make sure a pointer to it can be retrieved even when the debug symbols are stripped.
 */
@interface _RMUploadAPICenter : NSObject

+ (id)defaultCenter;

- (id)objectForBundleIdentifier:(NSString *)bundleIdentifier;

@end
