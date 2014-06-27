//
//  DCRunLoopOperation.h
//  Tourbillon
//
//  Created by Derek Chen on 13-10-16.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DCSafeARC.h"

typedef enum DCRunLoopOperationState {
    kDCRunLoopOperationStateInited,
    kDCRunLoopOperationStateExecuting,
    kDCRunLoopOperationStateFinished
} DCRunLoopOperationState;

@interface DCRunLoopOperation : NSOperation {
@private
#if !defined(NDEBUG)
    BOOL _debugCancelSelfBeforeSchedulingStart;
    BOOL _debugCancelSelfAfterSchedulingStart;
    NSTimeInterval _debugSecondaryThreadCancelDelay;
    NSMutableArray *_debugEventLog;
#endif
}

@property (atomic, copy, readwrite) NSString *debugName;

// IMPORTANT: Do not change these after queuing the operation; it's very likely that
// bad things will happen if you do.

@property (atomic, strong, readwrite) NSThread *runLoopThread;  // default is nil, implying main thread
@property (atomic, copy, readwrite) NSSet *runLoopModes;  // default is nil, implying set containing NSDefaultRunLoopMode

@property (atomic, copy, readonly) NSError *error;

@property (atomic, assign, readonly) DCRunLoopOperationState state;
@property (atomic, strong, readonly) NSThread *actualRunLoopThread;  // main thread if runLoopThread is nil, runLoopThread otherwise
@property (atomic, assign, readonly) BOOL isActualRunLoopThread;  // YES if the current thread is the actual run loop thread
@property (atomic, copy, readonly) NSSet *actualRunLoopModes;  // set containing NSDefaultRunLoopMode if runLoopModes is nil or empty, runLoopModes otherwise

@end

@interface DCRunLoopOperation (SubClassSupport)

// Override points

// A subclass will probably need to override -operationDidStart and -operationWillFinish
// to set up and tear down its run loop sources, respectively.  These are always called
// on the actual run loop thread.
//
// Note that -operationWillFinish will be called even if the operation is cancelled.
//
// -operationWillFinish can check the error property to see whether the operation was
// successful.  error will be NSCocoaErrorDomain/NSUserCancelledError on cancellation.
//
// -operationDidStart is allowed to call -finishWithError:.

- (void)operationDidStart;
- (void)operationWillFinish;

// Support methods

// A subclass should call finishWithError: when the operation is complete, passing nil
// for no error and an error otherwise.  It must call this on the actual run loop thread.
//
// Note that this will call -operationWillFinish before returning.

- (void)finishWithError:(NSError *)error;

@end

#if !defined(NDEBUG)

@interface DCRunLoopOperation (UnitTestSupport)

@property (atomic, assign, readwrite) BOOL debugCancelSelfBeforeSchedulingStart;
@property (atomic, assign, readwrite) BOOL debugCancelSelfAfterSchedulingStart;
@property (atomic, assign, readwrite) NSTimeInterval debugSecondaryThreadCancelDelay;

@property (atomic, assign, readonly) NSArray *debugEventLog;

- (void)debugEnableEventLog;


@end

#endif

