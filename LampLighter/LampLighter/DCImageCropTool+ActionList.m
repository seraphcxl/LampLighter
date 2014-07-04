//
//  DCImageCropTool+ActionList.m
//  LampLighter
//
//  Created by Derek Chen on 7/3/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageCropTool+ActionList.h"
#import "DCEditableImage.h"

@implementation DCImageCropTool (ActionList)

- (void)actionForMoveWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        ;
    } while (NO);
}

- (void)actionForTopLeftWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        NSPoint bottomRight = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y);
        [self createNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_TopLeft WithHitPoint:mouseHitLoc andLockPoint:bottomRight];
    } while (NO);
}

- (void)actionForBottomLeftWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        NSPoint topRight = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height);
        [self createNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_BottomLeft WithHitPoint:mouseHitLoc andLockPoint:topRight];
    } while (NO);
}

- (void)actionForTopRightWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        NSPoint bottomLeft = self.cropRect.origin;
        [self createNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_TopRight WithHitPoint:mouseHitLoc andLockPoint:bottomLeft];
    } while (NO);
}

- (void)actionForBottomRightWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        NSPoint topLeft = NSMakePoint(self.cropRect.origin.x, self.cropRect.origin.y + self.cropRect.size.height);
        [self createNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_BottomRight WithHitPoint:mouseHitLoc andLockPoint:topLeft];
    } while (NO);
}

- (void)actionForTopCenterWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        switch (self.type) {
            case DCImageCropType_Custom:
            {
            }
                break;
            case DCImageCropType_1x1:
            {
            }
                break;
            case DCImageCropType_2x3:
            {
            }
                break;
            case DCImageCropType_3x5:
            {
            }
                break;
            case DCImageCropType_5x7:
            {
            }
                break;
            case DCImageCropType_4x3_Portait:
            {
            }
                break;
            case DCImageCropType_4x3_Landscape:
            {
            }
                break;
            case DCImageCropType_16x9_Portait:
            {
            }
                break;
            case DCImageCropType_16x9_Landscape:
            {
            }
                break;
            case DCImageCropType_16x10_Portait:
            {
            }
                break;
            case DCImageCropType_16x10_Landscape:
            {
            }
                break;
            case DCImageCropType_A4:
            {
            }
                break;
            default:
                break;
        }
    } while (NO);
}

- (void)actionForBottomCenterWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        switch (self.type) {
            case DCImageCropType_Custom:
            {
            }
                break;
            case DCImageCropType_1x1:
            {
            }
                break;
            case DCImageCropType_2x3:
            {
            }
                break;
            case DCImageCropType_3x5:
            {
            }
                break;
            case DCImageCropType_5x7:
            {
            }
                break;
            case DCImageCropType_4x3_Portait:
            {
            }
                break;
            case DCImageCropType_4x3_Landscape:
            {
            }
                break;
            case DCImageCropType_16x9_Portait:
            {
            }
                break;
            case DCImageCropType_16x9_Landscape:
            {
            }
                break;
            case DCImageCropType_16x10_Portait:
            {
            }
                break;
            case DCImageCropType_16x10_Landscape:
            {
            }
                break;
            case DCImageCropType_A4:
            {
            }
                break;
            default:
                break;
        }
    } while (NO);
}

- (void)actionForLeftCenterWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        switch (self.type) {
            case DCImageCropType_Custom:
            {
            }
                break;
            case DCImageCropType_1x1:
            {
            }
                break;
            case DCImageCropType_2x3:
            {
            }
                break;
            case DCImageCropType_3x5:
            {
            }
                break;
            case DCImageCropType_5x7:
            {
            }
                break;
            case DCImageCropType_4x3_Portait:
            {
            }
                break;
            case DCImageCropType_4x3_Landscape:
            {
            }
                break;
            case DCImageCropType_16x9_Portait:
            {
            }
                break;
            case DCImageCropType_16x9_Landscape:
            {
            }
                break;
            case DCImageCropType_16x10_Portait:
            {
            }
                break;
            case DCImageCropType_16x10_Landscape:
            {
            }
                break;
            case DCImageCropType_A4:
            {
            }
                break;
            default:
                break;
        }
    } while (NO);
}

- (void)actionForRightCenterWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        switch (self.type) {
            case DCImageCropType_Custom:
            {
            }
                break;
            case DCImageCropType_1x1:
            {
            }
                break;
            case DCImageCropType_2x3:
            {
            }
                break;
            case DCImageCropType_3x5:
            {
            }
                break;
            case DCImageCropType_5x7:
            {
            }
                break;
            case DCImageCropType_4x3_Portait:
            {
            }
                break;
            case DCImageCropType_4x3_Landscape:
            {
            }
                break;
            case DCImageCropType_16x9_Portait:
            {
            }
                break;
            case DCImageCropType_16x9_Landscape:
            {
            }
                break;
            case DCImageCropType_16x10_Portait:
            {
            }
                break;
            case DCImageCropType_16x10_Landscape:
            {
            }
                break;
            case DCImageCropType_A4:
            {
            }
                break;
            default:
                break;
        }
    } while (NO);
}

- (void)createNewCropRectByMouseHitLocation:(DCImageCropMouseHitLocation)mouseHitLoc WithHitPoint:(NSPoint)hitPoint andLockPoint:(NSPoint)lockPoint {
    do {
        NSRect newCropBounds = NSMakeRect(MIN(hitPoint.x, lockPoint.x), MIN(hitPoint.y, lockPoint.y), fabsf(hitPoint.x - lockPoint.x), fabsf(hitPoint.y - lockPoint.y));
        [self resetCropRectInRect:newCropBounds withMouseHitLocation:mouseHitLoc andLockPoint:lockPoint];
    } while (NO);
}

@end
