//
//  DCLogger.h
//  Tourbillon
//
//  Created by Derek Chen on 13-7-1.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DCCommonConstants.h"
//#import "DCSafeARC.h"
#import "DCSingletonTemplate.h"

// A better assert. NSAssert is too runtime dependant, and assert() doesn't log.
// http://www.mikeash.com/pyblog/friday-qa-2013-05-03-proper-use-of-asserts.html
// Accepts both:
// - DCAssert(x > 0);
// - DCAssert(y > 3, @"Bad value for y");
#define DCAssert(expression, ...) \
    do { \
        if (!(expression)) { \
            NSLog(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
            abort(); \
        } \
    } while(NO)

typedef enum {
    DCLL_DEBUG = 0,
    DCLL_INFO,
    DCLL_WARN,
    DCLL_ERROR,
    DCLL_FATAL,
} DCLogLevel;

@interface DCLogger : NSObject {
}

@property (atomic, assign) DCLogLevel logLevel;
@property (atomic, assign) BOOL enableLogToFile;
@property (atomic, assign) BOOL enableTimestamp;
@property (atomic, assign) BOOL enableSourceCodeInfo;
@property (atomic, assign) BOOL enableThreadInfo;
@property (atomic, strong, readonly) NSFileHandle *fileHandle;
@property (atomic, strong, readonly) NSDateFormatter *dateFormatter;

DEFINE_SINGLETON_FOR_HEADER(DCLogger)

+ (void)logWithLevel:(DCLogLevel)level andFormat:(NSString *)format, ...;
+ (void)dumpClass:(Class)cls;

#define DCLog_Debug(format, ...) [DCLogger logWithLevel:DCLL_DEBUG andFormat:format, ## __VA_ARGS__]
#define DCLog_Info(format, ...) [DCLogger logWithLevel:DCLL_INFO andFormat:format, ## __VA_ARGS__]
#define DCLog_Warn(format, ...) [DCLogger logWithLevel:DCLL_WARN andFormat:format, ## __VA_ARGS__]
#define DCLog_Error(format, ...) [DCLogger logWithLevel:DCLL_ERROR andFormat:format, ## __VA_ARGS__]
#define DCLog_Fatal(format, ...) [DCLogger logWithLevel:DCLL_FATAL andFormat:format, ## __VA_ARGS__]

#define DCLog_DumpClass(class) [DCLogger dumpClass:class]

@end
