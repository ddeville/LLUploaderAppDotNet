//
//  RMKeychainItem.h
//  RMFoundation
//
//  Created by Damien DeVille on 12/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
	\brief
	Provides a Create Read Update Delete API for the Keychain Store
	
	\details
	- Allocating and initialising a keychain item object won't add it to the keychain store, you have to call -addItemToKeychain: and handle errors
	- The +find: methods don't retrieve the password, only the keychain attributes and thus won't prompt the user to unlock their keychain.
	- The +retrieve: methods will actually retrieve the password and will prompt the user to unlock their keychain.
	
 */
@interface RMKeychainItem : NSObject

/*
	Note
	
	items are faults when they are created locally and have unsaved changes
	
	this state changes when -
	adding or updating, which pushes the values into the server, making it false
	refreshing, which overwrites the local values, making it false
	deleting, which puts the item into a pre-added state, making it true
	
	This property is NOT key value observing compliant, the return value is computed on demand
 */
@property (readonly, assign, getter=isFault, nonatomic) BOOL fault;

/*
	State
 */

@property (copy, nonatomic) NSString *label;

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSData *data;

/*
 
 */

/*
	Create
 */
- (BOOL)addItemToKeychain:(NSError **)errorRef;

/*
	Read
	
	Refresh the current values from the keychain for an item that has previously been found.
 */
- (BOOL)refreshItemFromKeychainIncludeData:(BOOL)includeData error:(NSError **)errorRef;

/*
	Update
 */
- (BOOL)updateItemInKeychain:(NSError **)errorRef;

/*
	Delete
 */
- (BOOL)deleteItemFromKeychain:(NSError **)errorRef;

@end


@interface RMPasswordKeychainItem : RMKeychainItem

@property (copy, nonatomic) NSString *password;

- (BOOL)refreshItemFromKeychainIncludePassword:(BOOL)includePassword error:(NSError **)errorRef;

@end



@interface RMGenericKeychainItem : RMPasswordKeychainItem

@property (copy, nonatomic) NSString *serviceName;

+ (id)findKeychainItemForUsername:(NSString *)username serviceName:(NSString *)serviceName;

+ (id)keychainItemWithUsername:(NSString *)username password:(NSString *)password label:(NSString *)label serviceName:(NSString *)serviceName;
- (id)initWithUsername:(NSString *)username password:(NSString *)password label:(NSString *)label serviceName:(NSString *)serviceName;

@end


@interface RMInternetKeychainItem : RMPasswordKeychainItem 

@property (copy, nonatomic) NSString *server;
@property (copy, nonatomic) NSString *path;
@property (assign, nonatomic) NSInteger port;

enum {
	RMInternetKeychainItemProtocolUnknown = 0,
	RMInternetKeychainItemProtocolHTTP,
	RMInternetKeychainItemProtocolHTTPS,
	RMInternetKeychainItemProtocolFTP,
	RMInternetKeychainItemProtocolSSH,
};
typedef NSUInteger RMInternetKeychainItemProtocol;
@property (nonatomic) RMInternetKeychainItemProtocol protocol;

+ (id)findKeychainItemForUsername:(NSString *)username server:(NSString *)server path:(NSString *)path port:(NSInteger)port protocol:(RMInternetKeychainItemProtocol)protocol;

+ (id)keychainItemWithUsername:(NSString *)username password:(NSString *)password label:(NSString *)label server:(NSString *)server path:(NSString *)path port:(NSInteger)port protocol:(RMInternetKeychainItemProtocol)protocol;
- (id)initWithUsername:(NSString *)username password:(NSString *)password label:(NSString *)label server:(NSString *)server path:(NSString *)path port:(NSInteger)port protocol:(RMInternetKeychainItemProtocol)protocol;

@end
