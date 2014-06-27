//
//  DCTestBlocker.h
//  Tourbillon
//
//  Created by Derek Chen on 13-7-8.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCTestBlocker;

typedef void (^DCTestBlockerPeriodicHandler)(DCTestBlocker *blocker);

// DCTestBlocker class
//
// Summary:
// Lightweight helper to make unit tests more linear and readable; currently supports blocks,
// can be extended to support delegates as needed
// NOTE: Not safe to call outside the context of unit tests, as [FBTestBlocker wait] runs
// the currentRunLoop, and framework code, etc., is not guaranteed to be re-entrant.
// SenTestKit does not run tests in the context of a run loop.
// Also, not thread-safe, expects all signaling to happen on the same thread.
@interface DCTestBlocker : NSObject {
}

- (id)init;
- (id)initWithExpectedSignalCount:(NSInteger)expectedSignalCount;
- (BOOL)wait;
- (BOOL)waitWithTimeout:(NSTimeInterval)timeout;
- (BOOL)waitWithPeriodicHandler:(DCTestBlockerPeriodicHandler)handler;
- (BOOL)waitWithTimeout:(NSTimeInterval)timeout periodicHandler:(DCTestBlockerPeriodicHandler)handler;
- (NSInteger)signal;

@end
