//
//  _RMFTPURIValidator.h
//  FTP
//
//  Created by Keith Duncan on 24/07/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	Check string portions, or whole URI strings, are well formed as defined by IETF RFC 3986 <http://tools.ietf.org/html/rfc3986>
 */
@interface RMURIValidator : NSObject

/*!
	\brief
	Ensure a URI is well formed and that it's consituent parts pass their respective valudation methods.
 */
+ (BOOL)validateURI:(NSString **)URIRef error:(NSError **)errorRef;

/*!
	\brief
	A host can be an IP address or a reg-name, if the host is a reg-name it's validated for DNS lookup too
 */
+ (BOOL)validateHost:(NSString **)hostRef error:(NSError **)errorRef;

/*!
	\brief
	Validating an IP address is useful for distinguishing an IPv4 address from a reg-name
	
	\details
	This intentionally doesn't tell callers whether the input was validated as an IP-literal or IPv4address, because you shouldn't care
	This is only exposed for the purposes of distingusing between host strings that are addresses or names
 */
+ (BOOL)validateIPAddress:(NSString **)addressRef error:(NSError **)errorRef;

/*!
	\brief
	Just validate a string as a the reg-name, without checking whether it can be looked up in DNS
	
	\details
	Don't call this method in isolation, validating as a reg-name isn't that useful in practice.
	Use `+validateHost:error:` if in doubt.
 */
+ (BOOL)validateRegname:(NSString **)nameRef error:(NSError **)errorRef;

@end
