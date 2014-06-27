//
//  NSNumber+DCRandom.h
//  Tourbillon
//
//  Created by Derek Chen on 13-7-11.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (DCRandom)

+ (NSNumber *)randomUnsignedInt;
+ (NSNumber *)randomUnsignedIntForm:(unsigned int)start range:(unsigned int)range;  // [start, (start + range - 1)]
+ (NSNumber *)randomDoubleForm:(double)start range:(double)range;  // [start, (start + range)]

@end
