//
//  DCSafeARC.h
//  CodeGear_ObjC
//
//  Created by Derek Chen on 13-6-7.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#ifndef CodeGear_ObjC_DCSafeARC_h
#define CodeGear_ObjC_DCSafeARC_h

/**** **** **** **** **** **** **** ****/
#if !defined(__clang__) || __clang_major__ < 3
#ifndef __bridge
#define __bridge
#endif

#ifndef __bridge_retain
#define __bridge_retain
#endif

#ifndef __bridge_retained
#define __bridge_retained
#endif

#ifndef __autoreleasing
#define __autoreleasing
#endif

#ifndef __strong
#define __strong
#endif

#ifndef __unsafe_unretained
#define __unsafe_unretained
#endif

#ifndef __weak
#define __weak
#endif
#endif

/**** **** **** **** **** **** **** ****/
#ifndef SAFE_ARC_DEFINES
#define SAFE_ARC_DEFINES

#if __has_feature(objc_arc)
#define SAFE_ARC_PROP_STRONG strong
#define SAFE_ARC_RETAIN(x)
#define SAFE_ARC_RELEASE(x)
#define SAFE_ARC_SAFERELEASE(x)
#define SAFE_ARC_AUTORELEASE(x)
#define SAFE_ARC_BLOCK_COPY(x)
#define SAFE_ARC_BLOCK_RELEASE(x)
#define SAFE_ARC_SUPER_DEALLOC()
#define SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
#define SAFE_ARC_AUTORELEASE_POOL_END() }
#define SAFE_ARC_BRIDGE __bridge

#if TARGET_OS_IPHONE
// Compiling for iOS
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
// iOS 6.0 or later
#define SAFE_ARC_DISPATCHQUEUERELEASE(x)
#else
// iOS 5.X or earlier
#define SAFE_ARC_DISPATCHQUEUERELEASE(x) (dispatch_release(x));
#endif
#else
// Compiling for Mac OS X
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080
// Mac OS X 10.8 or later
#define SAFE_ARC_DISPATCHQUEUERELEASE(x)
#else
// Mac OS X 10.7 or earlier
#define SAFE_ARC_DISPATCHQUEUERELEASE(x) (dispatch_release(x));
#endif
#endif

#else
#define SAFE_ARC_PROP_STRONG retain
#define SAFE_ARC_RETAIN(x) ([(x) retain])
#define SAFE_ARC_RELEASE(x) ([(x) release])
#define SAFE_ARC_SAFERELEASE(x) ({[(x) release]; (x) = nil;})
#define SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
#define SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
#define SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
#define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
#define SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#define SAFE_ARC_AUTORELEASE_POOL_END() [pool drain];
#define SAFE_ARC_BRIDGE
#define SAFE_ARC_DISPATCHQUEUERELEASE(x) (dispatch_release(x));
#endif

#if __has_feature(objc_arc_weak)
#define SAFE_ARC_PROP_WEAK weak
#define __SAFE_ARC_PROP_WEAK __weak
#elif __has_feature(objc_arc)
#define SAFE_ARC_PROP_WEAK unsafe_unretained
#define __SAFE_ARC_PROP_WEAK __unsafe_unretained
#else
#define SAFE_ARC_PROP_WEAK assign
#define __SAFE_ARC_PROP_WEAK __unsafe_unretained
#endif

#endif

/**** **** **** **** **** **** **** ****/
#endif
