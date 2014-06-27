//
//  NSDictionary+DCSortable.h
//  Tourbillon
//
//  Created by Derek Chen on 13-7-11.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DCSortable)

- (NSArray *)sortedKeysUsingComparator:(NSComparator)comparator;
- (NSArray *)sortedValuesUsingKeyComparator:(NSComparator)comparator;
- (void)enumerateSortedKeysAndObjectsUsingComparator:(NSComparator)comparator usingBlock:(void (^)(id key, id value, BOOL *stop))block;

@end
