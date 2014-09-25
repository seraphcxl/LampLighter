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

- (void)actionForMoveWithMouseHitLocationPointDeltaX:(CGFloat)deltaX andDeltaY:(CGFloat)deltaY {
    do {
        NSRect visiableRect = self.currentImg.visiableRect;
        CGFloat newOrignX = self.cropRect.origin.x + deltaX;
        newOrignX = MAX(visiableRect.origin.x, newOrignX);
        newOrignX = MIN(visiableRect.origin.x + visiableRect.size.width - self.cropRect.size.width, newOrignX);
        
        CGFloat newOrignY = self.cropRect.origin.y - deltaY;
        newOrignY = MAX(visiableRect.origin.y, newOrignY);
        newOrignY = MIN(visiableRect.origin.y + visiableRect.size.height - self.cropRect.size.height, newOrignY);
        
        self.cropRect = NSMakeRect(newOrignX, newOrignY, self.cropRect.size.width, self.cropRect.size.height);
    } while (NO);
}

- (void)actionForTopLeftWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        NSPoint bottomRight = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y);
        [self cornerAnchorCreateNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_TopLeft WithHitPoint:mouseHitLoc andLockPoint:bottomRight];
    } while (NO);
}

- (void)actionForBottomLeftWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        NSPoint topRight = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height);
        [self cornerAnchorCreateNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_BottomLeft WithHitPoint:mouseHitLoc andLockPoint:topRight];
    } while (NO);
}

- (void)actionForTopRightWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        NSPoint bottomLeft = self.cropRect.origin;
        [self cornerAnchorCreateNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_TopRight WithHitPoint:mouseHitLoc andLockPoint:bottomLeft];
    } while (NO);
}

- (void)actionForBottomRightWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        NSPoint topLeft = NSMakePoint(self.cropRect.origin.x, self.cropRect.origin.y + self.cropRect.size.height);
        [self cornerAnchorCreateNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_BottomRight WithHitPoint:mouseHitLoc andLockPoint:topLeft];
    } while (NO);
}

- (void)actionForTopCenterWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        [self centerAnchorCreateNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_TopCenter WithHitPoint:mouseHitLoc];
    } while (NO);
}

- (void)actionForBottomCenterWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        [self centerAnchorCreateNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_BottomCenter WithHitPoint:mouseHitLoc];
    } while (NO);
}

- (void)actionForLeftCenterWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        [self centerAnchorCreateNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_LeftCenter WithHitPoint:mouseHitLoc];
    } while (NO);
}

- (void)actionForRightCenterWithMouseHitLocation:(NSPoint)mouseHitLoc {
    do {
        [self centerAnchorCreateNewCropRectByMouseHitLocation:DCImageCropMouseHitLoc_RightCenter WithHitPoint:mouseHitLoc];
    } while (NO);
}

- (void)cornerAnchorCreateNewCropRectByMouseHitLocation:(DCImageCropMouseHitLocation)mouseHitLoc WithHitPoint:(NSPoint)hitPoint andLockPoint:(NSPoint)lockPoint {
    do {
        NSRect newCropBounds = NSMakeRect(MIN(hitPoint.x, lockPoint.x), MIN(hitPoint.y, lockPoint.y), fabsf(hitPoint.x - lockPoint.x), fabsf(hitPoint.y - lockPoint.y));
        [self resetCropRectInRect:newCropBounds withMouseHitLocation:mouseHitLoc andLockPoint:lockPoint];
    } while (NO);
}

- (void)centerAnchorCreateNewCropRectByMouseHitLocation:(DCImageCropMouseHitLocation)mouseHitLoc WithHitPoint:(NSPoint)hitPoint {
    do {
        NSRect newCropBounds = NSMakeRect(0.0f, 0.0f, 0.0f, 0.0f);
        
        CGFloat leftX = self.cropRect.origin.x;
        CGFloat middleX = self.cropRect.origin.x + self.cropRect.size.width / 2.0f;
        CGFloat rightX = self.cropRect.origin.x + self.cropRect.size.width;
        
        CGFloat topY = self.cropRect.origin.y + self.cropRect.size.height;
        CGFloat centerY = self.cropRect.origin.y + self.cropRect.size.height / 2.0f;
        CGFloat bottomY = self.cropRect.origin.y;
        
        CGFloat imageMiddleX = self.currentImg.visiableRect.origin.x + self.currentImg.visiableRect.size.width / 2.0f;
        CGFloat imageCenterY = self.currentImg.visiableRect.origin.y + self.currentImg.visiableRect.size.height / 2.0f;
        
        switch (mouseHitLoc) {
            case DCImageCropMouseHitLoc_TopCenter:
            {
                NSPoint bottomCenter = NSMakePoint(middleX, bottomY);
                newCropBounds = NSMakeRect(self.cropRect.origin.x, self.cropRect.origin.y, self.cropRect.size.width, fabsf(hitPoint.y - self.cropRect.origin.y));
                if (self.cropType == DCImageCropType_Custom) {
                    ;
                } else {
                    if (newCropBounds.size.height > self.cropRect.size.height) {
                        newCropBounds = NSMakeRect(middleX - imageMiddleX < 0 ? self.currentImg.visiableRect.origin.x : ABS(imageMiddleX - middleX) * 2, bottomY, self.currentImg.visiableRect.size.width - ABS(imageMiddleX - middleX) * 2, newCropBounds.size.height);
                    } else {
                        
                    }
                }
                
                [self resetCropRectInRect:newCropBounds withMouseHitLocation:mouseHitLoc andLockPoint:bottomCenter];
            }
                break;
            case DCImageCropMouseHitLoc_BottomCenter:
            {
                NSPoint topCenter = NSMakePoint(middleX, topY);
                newCropBounds = NSMakeRect(self.cropRect.origin.x, hitPoint.y, self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height - hitPoint.y);
                if (self.cropType == DCImageCropType_Custom) {
                    ;
                } else {
                    if (newCropBounds.size.height > self.cropRect.size.height) {
                        newCropBounds = NSMakeRect(middleX - imageMiddleX < 0 ? self.currentImg.visiableRect.origin.x : ABS(imageMiddleX - middleX) * 2, hitPoint.y, self.currentImg.visiableRect.size.width - ABS(imageMiddleX - middleX) * 2, newCropBounds.size.height);
                    }
                }
                
                [self resetCropRectInRect:newCropBounds withMouseHitLocation:mouseHitLoc andLockPoint:topCenter];
            }
                break;
            case DCImageCropMouseHitLoc_LeftCenter:
            {
                NSPoint rightCenter = NSMakePoint(rightX, centerY);
                newCropBounds = NSMakeRect(hitPoint.x, self.cropRect.origin.y, self.cropRect.origin.x + self.cropRect.size.width - hitPoint.x, self.cropRect.size.height);
                if (self.cropType == DCImageCropType_Custom) {
                    ;
                } else {
                    if (newCropBounds.size.width > self.cropRect.size.width) {
                        newCropBounds = NSMakeRect(hitPoint.x, centerY - imageCenterY > 0 ? ABS(imageCenterY - centerY) * 2 : self.currentImg.visiableRect.origin.x, newCropBounds.size.width, self.currentImg.visiableRect.size.height - ABS(imageCenterY - centerY) * 2);
                    }
                }
                
                [self resetCropRectInRect:newCropBounds withMouseHitLocation:mouseHitLoc andLockPoint:rightCenter];
            }
                break;
            case DCImageCropMouseHitLoc_RightCenter:
            {
                NSPoint leftCenter = NSMakePoint(leftX, centerY);
                newCropBounds = NSMakeRect(self.cropRect.origin.x, self.cropRect.origin.y, fabsf(hitPoint.x - self.cropRect.origin.x), self.cropRect.size.height);
                if (self.cropType == DCImageCropType_Custom) {
                    ;
                } else {
                    if (newCropBounds.size.width > self.cropRect.size.width) {
                        newCropBounds = NSMakeRect(leftX, centerY - imageCenterY > 0 ? ABS(imageCenterY - centerY) * 2 : self.currentImg.visiableRect.origin.x, newCropBounds.size.width, self.currentImg.visiableRect.size.height - ABS(imageCenterY - centerY) * 2);
                    }
                }
                
                [self resetCropRectInRect:newCropBounds withMouseHitLocation:mouseHitLoc andLockPoint:leftCenter];
            }
                break;
            default:
                break;
        }
        
    } while (NO);
}

@end
