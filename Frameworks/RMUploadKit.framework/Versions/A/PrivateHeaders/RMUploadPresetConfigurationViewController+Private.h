//
//  RMUploadPresetConfigurationViewController+Private.h
//  RMUploadKit
//
//  Created by Dan Palmer on 19/07/2011.
//  Copyright 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SystemConfiguration/SystemConfiguration.h>

#import "RMUploadKit/RMUploadPresetConfigurationViewController.h"

@interface RMUploadPresetConfigurationViewController (/* RMUploadPrivate */)
@property (retain, nonatomic) id /* SCNetworkReachabilityRef */ reachability;
@property (retain, nonatomic) NSMutableSet *refreshSelectors;
@end

@interface RMUploadPresetConfigurationViewController (RMUploadPrivate)

- (BOOL)_canScheduleReachabilityRefreshForError:(NSError *)error;

- (void)_scheduleReachabilityRefreshWithSelector:(SEL)refreshSelector;
- (void)_unscheduleReachabilityRefreshWithSelector:(SEL)refreshSelector;
- (void)_unscheduleReachabilityRefresh;

- (BOOL)_tryScheduleReachabilityRefreshForError:(NSError *)error refreshSelector:(SEL)refreshSelector;

@end
