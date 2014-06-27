//
//  DCUIMainThreadGuard.h
//  Tourbillon
//
//  Created by Derek Chen on 10/13/13.
//  Copyright (c) 2013 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

// Compile-time selector checks.
#if DEBUG
#define PROPERTY(propName) NSStringFromSelector(@selector(propName))
#else
#define PROPERTY(propName) @#propName
#endif

static void DCAssertIfNotMainThread(void);
__attribute__((constructor)) static void DCUIMainThreadGuard(void);
