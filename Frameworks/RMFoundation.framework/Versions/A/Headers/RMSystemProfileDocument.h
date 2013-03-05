//
//  DSSystemProfileDocument.h
//  Courier
//
//  Created by Keith Duncan on 25/10/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMSystemProfileDocument : NSObject

/*!
	\brief
	Hardware platform such as "MacBook8,2"
	
	\return
	May return nil
 */
+ (NSString *)hardwareModel;

/*!
	\brief
	User visible operating system display version such as "10.8.2"
	
	\return
	May return nil
 */
+ (NSString *)operatingSystemDisplayVersion;

extern NSString *const RMSystemProfileDocumentMIMEType;
/*!
	\brief
	Generates an `application/xml+vnd.realmac.systemProfile` document.
 */
+ (NSXMLDocument *)systemProfileDocument;

@end
