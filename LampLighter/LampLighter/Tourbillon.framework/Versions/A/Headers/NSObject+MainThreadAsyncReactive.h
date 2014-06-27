//
//  NSObject+MainThreadAsyncReactive.h
//  Tourbillon
//
//  Created by Derek Chen on 5/16/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MainThreadAsyncReactive) {
}

- (instancetype)mainThreadAsyncReactive_init;
- (void)mainThreadAsyncReactive_dealloc;

- (void)addOperationForAsyncReactiveInMainThreadWithBlock:(void (^)(id strongSelf))block;

@end
