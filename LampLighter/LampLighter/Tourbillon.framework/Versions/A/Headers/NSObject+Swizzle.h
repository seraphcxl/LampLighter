//
//  NSObject+Swizzle.h
//  Tourbillon
//
//  Created by Derek Chen on 13-7-16.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL DCReplaceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block);

@interface NSObject (Swizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;

@end
