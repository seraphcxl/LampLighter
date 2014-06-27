//
//  DCImageUtility.h
//  Tourbillon
//
//  Created by Derek Chen on 13-7-15.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <ImageIO/ImageIO.h>
#else
#endif

//#import "DCSafeARC.h"
#import "DCCommonConstants.h"

@interface DCImageUtility : NSObject

+ (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize;
+ (CGSize)fitoutSize:(CGSize)thisSize inSize:(CGSize)aSize;
+ (CGRect)frameSize:(CGSize)thisSize inSize:(CGSize)aSize;

+ (CGFloat)degreesToRadians:(CGFloat)degrees;

+ (CGImageRef)loadImageFromContentsOfFile:(NSString *)path withMaxPixelSize:(CGFloat)pixelSize;
+ (CGImageSourceRef)loadImageSourceFromContentsOfFile:(NSString *)path;

@end
