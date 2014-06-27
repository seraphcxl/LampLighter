//
//  DCWebUtility.h
//  CodeGear_ObjC
//
//  Created by Derek Chen on 13-6-7.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DCSafeARC.h"

extern NSString * const kGetHTTPMethod;
extern NSString * const kPostHTTPMethod;

@interface DCWebUtility : NSObject

+ (NSDictionary *)dictionaryByParsingURLQueryPart:(NSString *)encodedString;
+ (NSString *)stringBySerializingQueryParameters:(NSDictionary *)queryParameters;

+ (void)deleteCookies:(NSString *)baseURL;

@end
