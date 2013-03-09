//
//  LLUploaderAppDotNetPreset.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Lick a Lemon. All rights reserved.
//

#import "LLUploaderAppDotNetPreset.h"

#import "LLUploaderAppDotNetCredentials.h"
#import "LLUploaderAppDotNetUploadTask.h"

NSString * const LLUploaderAppDotNetPresetPrivacyKey = @"privacy";

@implementation LLUploaderAppDotNetPreset

@dynamic authentication;

+ (NSString *)localisedName
{
	return @"App.net";
}

+ (NSString *)iconResource
{
	return @"ADN";
}

+ (NSString *)_freestandingIconResource
{
	return @"ADN_rounded";
}

+ (Class)uploadTaskClass
{
	return [LLUploaderAppDotNetUploadTask class];
}

+ (Class)credentialsClass
{
	return [LLUploaderAppDotNetCredentials class];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSMutableSet *keyPaths = [NSMutableSet setWithSet:[super keyPathsForValuesAffectingValueForKey:key]];
	
	if ([key isEqualToString:RMUploadPresetDirtyKey]) {
		[keyPaths addObject:LLUploaderAppDotNetPresetPrivacyKey];
	}
	
	return keyPaths;
}

- (id)initWithPropertyListRepresentation:(id)values
{
	id superRepresentation = [values objectForKey:@"super"];
	self = [super initWithPropertyListRepresentation:superRepresentation];
	if (self == nil) {
		return nil;
	}
	
	[self setValue:[values valueForKey:LLUploaderAppDotNetPresetPrivacyKey] forKey:LLUploaderAppDotNetPresetPrivacyKey];
	
	return self;
}

- (id)propertyListRepresentation
{
	id superRepresentation = [super propertyListRepresentation];
	
	NSMutableDictionary *plist = [NSMutableDictionary dictionary];
	[plist setObject:superRepresentation forKey:@"super"];
	
	[plist setValue:@([self privacy]) forKey:LLUploaderAppDotNetPresetPrivacyKey];
	
	return plist;
}

- (void)setNilValueForKey:(NSString *)key
{
	if ([key isEqualToString:LLUploaderAppDotNetPresetPrivacyKey]) {
		[self setValue:@(LLUploaderAppDotNetPresetPrivacyPublic) forKey:LLUploaderAppDotNetPresetPrivacyKey];
	}
	else {
		[super setNilValueForKey:key];
	}
}

- (NSSet *)acceptedTypes
{
	NSMutableSet *acceptedTypes = [NSMutableSet setWithSet:[super acceptedTypes]];
	[acceptedTypes addObject:(id)kUTTypeData];
	return acceptedTypes;
}

- (NSURL *)serviceURL
{
	return [[[NSURL alloc] initWithScheme:@"http" host:@"app.net" path:@"/"] autorelease];
}

@end
