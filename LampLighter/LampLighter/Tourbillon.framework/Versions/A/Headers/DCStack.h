//
//  DCStack.h
//  Tourbillon
//
//  Created by Derek Chen on 13-7-15.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DCSafeARC.h"

@interface DCStack : NSObject <NSFastEnumeration> {
}

@property (nonatomic, assign, readonly) NSUInteger count;

- (id)initWithArray:(NSArray *)array;

- (void)pushObject:(id)object;
- (void)pushObjects:(NSArray *)objects;
- (id)popObject;
- (id)peekObject;

@end
