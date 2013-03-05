//
//  _RMFTPDNSValidator.h
//  FTP
//
//  Created by Keith Duncan on 24/07/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	Check a string for suitability for passing into a DNS lookup system, as defined in IETF RFC 5892 <http://tools.ietf.org/html/rfc5892>
 */
@interface RMDNSValidator : NSObject

/*!
	\brief
	Before using a host portion parsed from a URI reference as a DNS name, validate that the string can be used as a DNS name.
 */
+ (BOOL)validateNameForDomainNameSystem:(NSString **)regnameRef error:(NSError **)errorRef;

@end
