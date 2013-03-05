//
//  RMAtomic.h
//  RMFoundation
//
//  Created by Keith Duncan on 24/03/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libkern/OSAtomic.h>

static inline void RMFoundationMemoryBarrierWrite(void) {
	OSMemoryBarrier();
}

static inline void RMFoundationMemoryBarrierRead(void) {
	OSMemoryBarrier();
}
