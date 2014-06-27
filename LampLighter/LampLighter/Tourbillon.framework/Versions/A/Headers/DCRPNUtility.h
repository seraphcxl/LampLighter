//
//  DCRPNUtility.h
//  Tourbillon
//
//  Created by Derek Chen on 13-7-15.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DCSafeARC.h"

extern NSString *const DCRPNUtilityUnknownOperatorException;
extern NSString *const DCRPNUtilityInvalidInstructionException;
extern NSString *const DCRPNUtilityInstuctionUnderrunException;

@interface DCRPNUtility : NSObject {
}

@property (nonatomic, strong, readonly) NSNumber *currentResult;

- (id)initWithInstructions:(NSArray* )instructions;

- (void)addInstruction:(id)instruction;
- (void)addInstructions:(NSArray *)instructions;
- (NSNumber *)performInstructions;

@end
