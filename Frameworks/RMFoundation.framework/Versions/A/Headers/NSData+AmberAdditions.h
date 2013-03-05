//
//  NSData+Additions.h
//  Amber
//
//  Created by Keith Duncan on 04/01/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	Wrapper around the CommonCrypto hashing functions.
	These data objects are unlikely to be used raw, there are a number of base conversion methods in the <tt>AFBaseConversion</tt> NSData category.
 */
@interface NSData (AFHashing)
- (NSData *)MD5Hash;
- (NSData *)SHA1Hash;

- (NSData *)HMAC_SHA1_WithSecretKey:(NSData *)secretKey;
@end

@interface NSData (RMBaseConversion)

/*!
	\brief
	Uses the Base64 alphabet defined in IETF-RFC-4648 §4 <http://tools.ietf.org/html/rfc4648#section-4>
	
	\return
	nil if the string isn't valid Base64.
 */
+ (id)dataWithBase64String:(NSString *)base64String;

/*!
	\brief
	Uses the alphabet defined in the documentation for <tt>+dataWithBase64String:</tt>.
 */
- (NSString *)base64String;

/*!
	\brief
	Uses the Base32 alphabet defined in IETF-RFC-4648 §6 <http://tools.ietf.org/html/rfc4648#section-6>
	
	\details
	NB: this is <b>not</b> the 'Base 32 Encoding with Extended Hex Alphabet' defined in IETF-RFC-4648 §7 <http://tools.ietf.org/html/rfc4648#section-7>
	
	\return
	nil if the string isn't valid Base32.
 */
+ (id)dataWithBase32String:(NSString *)base32String;

/*!
	\brief
	Uses the alphabet defined in the documentation for <tt>+dataWithBase32String:</tt>.
 */
- (NSString *)base32String;

/*!
	\brief
	Uses the Base16 alphabet defined in IETF-RFC-4648 §8 <http://tools.ietf.org/html/rfc4648#section-8>
	
	\return
	nil if the string isn't valid Base16.
 */
+ (id)dataWithBase16String:(NSString *)base16String;

/*!
	\brief
	Uses the alphabet defined in the documentation for <tt>+dataWithBase16String:</tt>.
 */
- (NSString *)base16String;

/*!
	\brief
	Uses [0, 1] to print the data in binary, only useful for debugging.
 */
- (NSString *)base2String;

@end
