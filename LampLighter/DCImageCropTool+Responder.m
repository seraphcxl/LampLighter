//
//  DCImageCropTool+Responder.m
//  LampLighter
//
//  Created by Derek Chen on 7/4/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageCropTool+Responder.h"
#import "DCImageCropTool+ActionList.h"
#import "DCEditableImage.h"

@implementation DCImageCropTool (Responder)

#pragma mark - Responder
- (BOOL)handleMouseDown:(NSEvent *)theEvent {
    BOOL result = NO;
    do {
        if (!theEvent) {
            break;
        }
        
        NSPoint loc = theEvent.locationInWindow;
        
        CGFloat leftX = self.cropRect.origin.x;
        CGFloat middleX = self.cropRect.origin.x + self.cropRect.size.width / 2.0f;
        CGFloat rightX = self.cropRect.origin.x + self.cropRect.size.width;
        
        CGFloat topY = self.cropRect.origin.y + self.cropRect.size.height;
        CGFloat centerY = self.cropRect.origin.y + self.cropRect.size.height / 2.0f;
        CGFloat bottomY = self.cropRect.origin.y;
        
        do {
            // corner anchor
            NSPoint topLeft = NSMakePoint(leftX, topY);
            if ([self isMouseHitLocation:loc inAnchor:topLeft]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_TopLeft;
                break;
            }
            
            NSPoint bottomLeft = NSMakePoint(leftX, bottomY);
            if ([self isMouseHitLocation:loc inAnchor:bottomLeft]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_BottomLeft;
                break;
            }
            
            NSPoint topRight = NSMakePoint(rightX, topY);
            if ([self isMouseHitLocation:loc inAnchor:topRight]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_TopRight;
                break;
            }
            
            NSPoint bottomRight = NSMakePoint(rightX, bottomY);
            if ([self isMouseHitLocation:loc inAnchor:bottomRight]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_BottomRight;
                break;
            }
            
            // line anchor
            NSPoint topCenter = NSMakePoint(middleX, topY);
            if ([self isMouseHitLocation:loc inAnchor:topCenter]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_TopCenter;
                break;
            }
            
            NSPoint bottomCenter = NSMakePoint(middleX, bottomY);
            if ([self isMouseHitLocation:loc inAnchor:bottomCenter]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_BottomCenter;
                break;
            }
            
            NSPoint leftCenter = NSMakePoint(leftX, centerY);
            if ([self isMouseHitLocation:loc inAnchor:leftCenter]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_LeftCenter;
                break;
            }
            
            NSPoint rightCenter = NSMakePoint(rightX, centerY);
            if ([self isMouseHitLocation:loc inAnchor:rightCenter]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_RightCenter;
                break;
            }
            
            // horizontal line
            if ([self isMouseHitLocation:loc onHorizontalLineStart:topLeft end:topCenter]) {
                if (self.cropType == DCImageCropType_Custom) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_TopCenter;
                } else {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_TopLeft;
                }
                break;
            }
            
            if ([self isMouseHitLocation:loc onHorizontalLineStart:topCenter end:topRight]) {
                if (self.cropType == DCImageCropType_Custom) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_TopCenter;
                } else {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_TopRight;
                }
                break;
            }
            
            if ([self isMouseHitLocation:loc onHorizontalLineStart:bottomLeft end:bottomCenter]) {
                if (self.cropType == DCImageCropType_Custom) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomCenter;
                } else {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomLeft;
                }
                break;
            }
            
            if ([self isMouseHitLocation:loc onHorizontalLineStart:bottomCenter end:bottomRight]) {
                if (self.cropType == DCImageCropType_Custom) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomCenter;
                } else {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomRight;
                }
                break;
            }
            
            // vertical line
            if ([self isMouseHitLocation:loc onVerticalLineStart:topLeft end:leftCenter]) {
                if (self.cropType == DCImageCropType_Custom) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_LeftCenter;
                } else {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_TopLeft;
                }
                break;
            }
            
            if ([self isMouseHitLocation:loc onVerticalLineStart:leftCenter end:bottomLeft]) {
                if (self.cropType == DCImageCropType_Custom) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_LeftCenter;
                } else {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomLeft;
                }
                break;
            }
            
            if ([self isMouseHitLocation:loc onVerticalLineStart:topRight end:rightCenter]) {
                if (self.cropType == DCImageCropType_Custom) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_RightCenter;
                } else {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_TopRight;
                }
                break;
            }
            
            if ([self isMouseHitLocation:loc onVerticalLineStart:rightCenter end:bottomRight]) {
                if (self.cropType == DCImageCropType_Custom) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_RightCenter;
                } else {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomRight;
                }
                break;
            }
            
            // inside or outside
            if (NSPointInRect(loc, self.cropRect)) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_Inside;
                break;
            } else {
                self.mouseHitLocation = DCImageCropMouseHitLoc_Outside;
                break;
            }
            
        } while (NO);
        if (self.mouseHitLocation != DCImageCropMouseHitLoc_Outside) {
            result = YES;
        }
    } while (NO);
    return result;
}

- (BOOL)handleRightMouseDown:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseUp:(NSEvent *)theEvent {
    self.mouseHitLocation = DCImageCropMouseHitLoc_Outside;
    return NO;
}

- (BOOL)handleRightMouseUp:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseMoved:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseDragged:(NSEvent *)theEvent {
    BOOL result = NO;
    NSPoint loc = NSMakePoint(0.0f, 0.0f);
    NSPoint mouseHitLocPoint = NSMakePoint(0.0f, 0.0f);
    do {
        if (!theEvent || !self.currentImg) {
            break;
        }
        
        loc = theEvent.locationInWindow;
        
        switch (self.mouseHitLocation) {
            case DCImageCropMouseHitLoc_Outside:
            {
            }
                break;
            case DCImageCropMouseHitLoc_Inside:
            {
                [self actionForMoveWithMouseHitLocationPointDeltaX:theEvent.deltaX andDeltaY:theEvent.deltaY];
            }
                break;
            case DCImageCropMouseHitLoc_TopLeft:
            {
                mouseHitLocPoint = [self fitinMouseHitLocationPointBy:DCImageCropMouseHitLoc_TopLeft andHitPoint:loc];
                [self actionForTopLeftWithMouseHitLocation:mouseHitLocPoint];
            }
                break;
            case DCImageCropMouseHitLoc_BottomLeft:
            {
                mouseHitLocPoint = [self fitinMouseHitLocationPointBy:DCImageCropMouseHitLoc_BottomLeft andHitPoint:loc];
                [self actionForBottomLeftWithMouseHitLocation:mouseHitLocPoint];
            }
                break;
            case DCImageCropMouseHitLoc_TopRight:
            {
                mouseHitLocPoint = [self fitinMouseHitLocationPointBy:DCImageCropMouseHitLoc_TopRight andHitPoint:loc];
                [self actionForTopRightWithMouseHitLocation:mouseHitLocPoint];
            }
                break;
            case DCImageCropMouseHitLoc_BottomRight:
            {
                mouseHitLocPoint = [self fitinMouseHitLocationPointBy:DCImageCropMouseHitLoc_BottomRight andHitPoint:loc];
                [self actionForBottomRightWithMouseHitLocation:mouseHitLocPoint];
            }
                break;
            case DCImageCropMouseHitLoc_TopCenter:
            {
                mouseHitLocPoint = [self fitinMouseHitLocationPointBy:DCImageCropMouseHitLoc_TopCenter andHitPoint:loc];
                [self actionForTopCenterWithMouseHitLocation:mouseHitLocPoint];
            }
                break;
            case DCImageCropMouseHitLoc_BottomCenter:
            {
                mouseHitLocPoint = [self fitinMouseHitLocationPointBy:DCImageCropMouseHitLoc_BottomCenter andHitPoint:loc];
                [self actionForBottomCenterWithMouseHitLocation:mouseHitLocPoint];
            }
                break;
            case DCImageCropMouseHitLoc_LeftCenter:
            {
                mouseHitLocPoint = [self fitinMouseHitLocationPointBy:DCImageCropMouseHitLoc_LeftCenter andHitPoint:loc];
                [self actionForLeftCenterWithMouseHitLocation:mouseHitLocPoint];
            }
                break;
            case DCImageCropMouseHitLoc_RightCenter:
            {
                mouseHitLocPoint = [self fitinMouseHitLocationPointBy:DCImageCropMouseHitLoc_RightCenter andHitPoint:loc];
                [self actionForRightCenterWithMouseHitLocation:mouseHitLocPoint];
            }
                break;
            default:
                break;
        }
        self.mouseHitLocPoint = mouseHitLocPoint;
        if (self.mouseHitLocation != DCImageCropMouseHitLoc_Outside) {
            result = YES;
        }
    } while (NO);
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageEditTool:valueChanged:)]) {
        [self.actionDelegate imageEditTool:self valueChanged:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.mouseHitLocPoint.x], kImageEditPragma_CropMouseHitLocationX, [NSNumber numberWithFloat:self.mouseHitLocPoint.y], kImageEditPragma_CropMouseHitLocationY, nil]];
    }
    return result;
}

- (BOOL)handleScrollWheel:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleRightMouseDragged:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseEntered:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseExited:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleKeyDown:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleKeyUp:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleZoomImage {
    BOOL result = NO;
    do {
        if (NSPointInRect(self.cropRect.origin, self.currentImg.visiableRect) && NSPointInRect(NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height), self.currentImg.visiableRect)) {
            ;
        } else {
            CGFloat x = self.cropRect.origin.x;
            CGFloat y = self.cropRect.origin.y;
            CGFloat w = self.cropRect.size.width;
            CGFloat h = self.cropRect.size.height;
            if (x < self.currentImg.visiableRect.origin.x) {
                x = self.currentImg.visiableRect.origin.x;
            }
            
            CGFloat visiableRectRight = self.currentImg.visiableRect.origin.x + self.currentImg.visiableRect.size.width;
            if (x + w > visiableRectRight) {
                w = visiableRectRight - x;
            }
            
            if (y < self.currentImg.visiableRect.origin.y) {
                y = self.currentImg.visiableRect.origin.y;
            }
            
            CGFloat visiableRectTop = self.currentImg.visiableRect.origin.y + self.currentImg.visiableRect.size.height;
            if (y + h > visiableRectTop) {
                h = visiableRectTop - y;
            }
            
            self.cropRect = NSMakeRect(x, y, w, h);
//            [self resetCropRectInRect:self.currentImg.visiableRect withMouseHitLocation:DCImageCropMouseHitLoc_Inside andLockPoint:NSMakePoint(0.0f, 0.0f)];
        }
        result = YES;
    } while (NO);
    return result;
}

- (NSPoint)fitinMouseHitLocationPointBy:(DCImageCropMouseHitLocation)mouseHitLoc andHitPoint:(NSPoint)hitPoint {
    CGFloat mouseHitLocX = 0.0f;
    CGFloat mouseHitLocY = 0.0f;
    do {
        CGFloat leftX = self.cropRect.origin.x;
        CGFloat rightX = self.cropRect.origin.x + self.cropRect.size.width;
        
        CGFloat topY = self.cropRect.origin.y + self.cropRect.size.height;
        CGFloat bottomY = self.cropRect.origin.y;
        
        // fit in current image visiable rect
        mouseHitLocX = MAX(hitPoint.x, self.currentImg.visiableRect.origin.x);
        mouseHitLocX = MIN(mouseHitLocX, (self.currentImg.visiableRect.origin.x + self.currentImg.visiableRect.size.width));
        
        mouseHitLocY = MAX(hitPoint.y, self.currentImg.visiableRect.origin.y);
        mouseHitLocY = MIN(mouseHitLocY, (self.currentImg.visiableRect.origin.y + self.currentImg.visiableRect.size.height));
        
        // fit in self crop rect
        // mouseHitLocX
        switch (mouseHitLoc) {
            case DCImageCropMouseHitLoc_TopLeft:
            case DCImageCropMouseHitLoc_BottomLeft:
            case DCImageCropMouseHitLoc_LeftCenter:
            {
                mouseHitLocX = MIN(mouseHitLocX, rightX - 1);
            }
                break;
            case DCImageCropMouseHitLoc_TopRight:
            case DCImageCropMouseHitLoc_BottomRight:
            case DCImageCropMouseHitLoc_RightCenter:
            {
                mouseHitLocX = MAX(mouseHitLocX, leftX + 1);
            }
                break;
            default:
                break;
        }
        // mouseHitLocY
        switch (self.mouseHitLocation) {
            case DCImageCropMouseHitLoc_TopLeft:
            case DCImageCropMouseHitLoc_TopRight:
            case DCImageCropMouseHitLoc_TopCenter:
            {
                mouseHitLocY = MAX(mouseHitLocY, bottomY + 1);
            }
                break;
            case DCImageCropMouseHitLoc_BottomLeft:
            case DCImageCropMouseHitLoc_BottomRight:
            case DCImageCropMouseHitLoc_BottomCenter:
            {
                mouseHitLocY = MIN(mouseHitLocY, topY - 1);
            }
                break;
            default:
                break;
        }
    } while (NO);
    return NSMakePoint(mouseHitLocX, mouseHitLocY);
}

@end
