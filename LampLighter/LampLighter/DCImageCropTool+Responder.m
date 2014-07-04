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
            NSPoint topLeft = NSMakePoint(leftX, topY);
            if ([self isMouseHitLocation:loc inAnchor:topLeft]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_TopLeft;
                break;
            } else {
                NSPoint bottomLeft = NSMakePoint(leftX, bottomY);
                if ([self isMouseHitLocation:loc inAnchor:bottomLeft]) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomLeft;
                    break;
                } else {
                    NSPoint topRight = NSMakePoint(rightX, topY);
                    if ([self isMouseHitLocation:loc inAnchor:topRight]) {
                        self.mouseHitLocation = DCImageCropMouseHitLoc_TopRight;
                        break;
                    } else {
                        NSPoint bottomRight = NSMakePoint(rightX, bottomY);
                        if ([self isMouseHitLocation:loc inAnchor:bottomRight]) {
                            self.mouseHitLocation = DCImageCropMouseHitLoc_BottomRight;
                            break;
                        } else {
                            NSPoint topCenter = NSMakePoint(middleX, topY);
                            if ([self isMouseHitLocation:loc inAnchor:topCenter]) {
                                self.mouseHitLocation = DCImageCropMouseHitLoc_TopCenter;
                                break;
                            } else {
                                NSPoint bottomCenter = NSMakePoint(middleX, bottomY);
                                if ([self isMouseHitLocation:loc inAnchor:bottomCenter]) {
                                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomCenter;
                                    break;
                                } else {
                                    NSPoint leftCenter = NSMakePoint(leftX, centerY);
                                    if ([self isMouseHitLocation:loc inAnchor:leftCenter]) {
                                        self.mouseHitLocation = DCImageCropMouseHitLoc_LeftCenter;
                                        break;
                                    } else {
                                        NSPoint rightCenter = NSMakePoint(rightX, centerY);
                                        if ([self isMouseHitLocation:loc inAnchor:rightCenter]) {
                                            self.mouseHitLocation = DCImageCropMouseHitLoc_RightCenter;
                                            break;
                                        } else if (NSPointInRect(loc, self.cropRect)) {
                                            self.mouseHitLocation = DCImageCropMouseHitLoc_Inside;
                                            break;
                                        } else {
                                            self.mouseHitLocation = DCImageCropMouseHitLoc_Outside;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
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
    CGFloat mouseHitLocX = 0.0f;
    CGFloat mouseHitLocY = 0.0f;
    do {
        if (!theEvent || !self.currentImg) {
            break;
        }
        
        loc = theEvent.locationInWindow;
        
        CGFloat leftX = self.cropRect.origin.x;
//        CGFloat middleX = self.cropRect.origin.x + self.cropRect.size.width / 2.0f;
        CGFloat rightX = self.cropRect.origin.x + self.cropRect.size.width;
        
        CGFloat topY = self.cropRect.origin.y + self.cropRect.size.height;
//        CGFloat centerY = self.cropRect.origin.y + self.cropRect.size.height / 2.0f;
        CGFloat bottomY = self.cropRect.origin.y;
        
        mouseHitLocX = MAX(loc.x, self.currentImg.visiableRect.origin.x);
        mouseHitLocX = MIN(mouseHitLocX, (self.currentImg.visiableRect.origin.x + self.currentImg.visiableRect.size.width));
        
        mouseHitLocY = MAX(loc.y, self.currentImg.visiableRect.origin.y);
        mouseHitLocY = MIN(mouseHitLocY, (self.currentImg.visiableRect.origin.y + self.currentImg.visiableRect.size.height));
        
        NSPoint mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
        
        switch (self.mouseHitLocation) {
            case DCImageCropMouseHitLoc_Outside:
            {
            }
                break;
            case DCImageCropMouseHitLoc_Inside:
            {
                [self actionForMoveWithMouseHitLocation:mouseHitLoc];
            }
                break;
            case DCImageCropMouseHitLoc_TopLeft:
            {
                mouseHitLocX = MIN(mouseHitLocX, rightX - 1);
                mouseHitLocY = MAX(mouseHitLocY, bottomY + 1);
                mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
                [self actionForTopLeftWithMouseHitLocation:mouseHitLoc];
            }
                break;
            case DCImageCropMouseHitLoc_BottomLeft:
            {
                mouseHitLocX = MIN(mouseHitLocX, rightX - 1);
                mouseHitLocY = MIN(mouseHitLocY, topY - 1);
                mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
                
                [self actionForBottomLeftWithMouseHitLocation:mouseHitLoc];
            }
                break;
            case DCImageCropMouseHitLoc_TopRight:
            {
                mouseHitLocX = MAX(mouseHitLocX, leftX + 1);
                mouseHitLocY = MAX(mouseHitLocY, bottomY + 1);
                mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
                [self actionForTopRightWithMouseHitLocation:mouseHitLoc];
            }
                break;
            case DCImageCropMouseHitLoc_BottomRight:
            {
                mouseHitLocX = MAX(mouseHitLocX, leftX + 1);
                mouseHitLocY = MIN(mouseHitLocY, topY - 1);
                mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
                [self actionForBottomRightWithMouseHitLocation:mouseHitLoc];
            }
                break;
            case DCImageCropMouseHitLoc_TopCenter:
            {
                mouseHitLocY = MAX(mouseHitLocY, bottomY + 1);
                mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
                [self actionForTopCenterWithMouseHitLocation:mouseHitLoc];
            }
                break;
            case DCImageCropMouseHitLoc_BottomCenter:
            {
                mouseHitLocY = MIN(mouseHitLocY, topY - 1);
                mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
                [self actionForBottomCenterWithMouseHitLocation:mouseHitLoc];
            }
                break;
            case DCImageCropMouseHitLoc_LeftCenter:
            {
                mouseHitLocX = MIN(mouseHitLocX, rightX - 1);
                mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
                [self actionForLeftCenterWithMouseHitLocation:mouseHitLoc];
            }
                break;
            case DCImageCropMouseHitLoc_RightCenter:
            {
                mouseHitLocX = MAX(mouseHitLocX, leftX + 1);
                mouseHitLoc = NSMakePoint(mouseHitLocX, mouseHitLocY);
                [self actionForRightCenterWithMouseHitLocation:mouseHitLoc];
            }
                break;
            default:
                break;
        }
        if (self.mouseHitLocation != DCImageCropMouseHitLoc_Outside) {
            result = YES;
        }
    } while (NO);
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageEditTool:valueChanged:)]) {
        [self.actionDelegate imageEditTool:self valueChanged:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:mouseHitLocX], kImageEditPragma_CropMouseHitLocationX, [NSNumber numberWithFloat:mouseHitLocY], kImageEditPragma_CropMouseHitLocationY, nil]];
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

@end
