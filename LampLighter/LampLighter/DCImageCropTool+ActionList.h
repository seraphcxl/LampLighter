//
//  DCImageCropTool+ActionList.h
//  LampLighter
//
//  Created by Derek Chen on 7/3/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageCropTool.h"

@interface DCImageCropTool (ActionList)

- (void)actionForMoveWithMouseHitLocation:(NSPoint)mouseHitLoc;
- (void)actionForTopLeftWithMouseHitLocation:(NSPoint)mouseHitLoc;
- (void)actionForBottomLeftWithMouseHitLocation:(NSPoint)mouseHitLoc;
- (void)actionForTopRightWithMouseHitLocation:(NSPoint)mouseHitLoc;
- (void)actionForBottomRightWithMouseHitLocation:(NSPoint)mouseHitLoc;
- (void)actionForTopCenterWithMouseHitLocation:(NSPoint)mouseHitLoc;
- (void)actionForBottomCenterWithMouseHitLocation:(NSPoint)mouseHitLoc;
- (void)actionForLeftCenterWithMouseHitLocation:(NSPoint)mouseHitLoc;
- (void)actionForRightCenterWithMouseHitLocation:(NSPoint)mouseHitLoc;

@end
