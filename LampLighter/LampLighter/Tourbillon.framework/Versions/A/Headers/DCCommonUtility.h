//
//  DCCommonUtility.h
//  CodeGear_ObjC
//
//  Created by Derek Chen on 13-6-7.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DCSafeARC.h"

#define DC_GOODPOWER 7
#define DC_GOODMASK ((1 << DC_GOODPOWER) - 1)
#define DC_GOODHASH(x) (((long)x >> 5) & DC_GOODMASK)

@interface DCCommonUtility : NSObject

+ (BOOL)isRetinaDisplay;
+ (NSString *)newUUIDString;
+ (BOOL)isRegisteredURLScheme:(NSString *)urlScheme;

+ (unsigned long)currentTimeInMilliseconds;
+ (NSTimeInterval)randomTimeInterval:(NSTimeInterval)minValue withMaxValue:(NSTimeInterval)maxValue;

+ (NSString *)localizedStringForKey:(NSString *)key withDefault:(NSString *)value inBundle:(NSBundle *)bundle;

@end
