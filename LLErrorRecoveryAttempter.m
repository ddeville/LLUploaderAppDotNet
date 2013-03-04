//
//  LLErrorRecoveryAttempter.m
//  AppDotNet
//
//  Created by Damien DeVille on 3/4/13.
//  Copyright (c) 2013 Damien DeVille. All rights reserved.
//

#import "LLErrorRecoveryAttempter.h"

#import <objc/message.h>

#import "LLAppDotNet-Constants.h"

@interface LLErrorRecoveryAttempter ()

@property (assign, nonatomic) NSMutableArray *titles, *blocks;

@end

@implementation LLErrorRecoveryAttempter

- (id)init
{
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_titles = [[NSMutableArray alloc] init];
	_blocks = [[NSMutableArray alloc] init];
	
	return self;
}

- (void)dealloc
{
	[_titles release];
	[_blocks release];
	
	[super dealloc];
}

- (void)addRecoveryOptionWithLocalizedTitle:(NSString *)localizedTitle recoveryBlock:(BOOL (^)(NSError *recoveryError))recoveryBlock
{
	NSParameterAssert(localizedTitle != nil);
	NSParameterAssert(recoveryBlock != nil);
	
	[[self titles] addObject:localizedTitle];
	[[self blocks] addObject:[[recoveryBlock copy] autorelease]];
}

- (void)addCancelRecoveryOption
{
	[self addRecoveryOptionWithLocalizedTitle:NSLocalizedStringFromTableInBundle(@"Cancel", nil, [NSBundle bundleWithIdentifier:LLUploaderAppDotNetBundleIdentifier], @"LLErrorRecoveryAttempter 'cancel' recovery option") recoveryBlock:^ BOOL (NSError *error) {
		return NO;
	}];
}

- (NSArray *)recoveryOptions
{
	return [[_titles copy] autorelease];
}

#pragma mark - NSErrorRecoveryAttempting

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex
{
	return ((BOOL (^)(NSError *))[[self blocks] objectAtIndex:recoveryOptionIndex])(error);
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo
{
	void (^originalDidRecover)(BOOL) = ^ (BOOL didRecover) {
		((void (*)(id, SEL, BOOL, void *))objc_msgSend)(delegate, didRecoverSelector, didRecover, contextInfo);
	};
	
	BOOL didRecover = ((BOOL (^)(NSError *))[[self blocks] objectAtIndex:recoveryOptionIndex])(error);
	originalDidRecover(didRecover);
}

@end
