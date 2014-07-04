//
//  DCImageCropTool+Responder.m
//  LampLighter
//
//  Created by Derek Chen on 7/4/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageCropTool+Responder.h"
#import "DCImageCropTool+ActionList.h"

@implementation DCImageCropTool (Responder)

#pragma mark - Responder
- (BOOL)handleMouseDown:(NSEvent *)theEvent {
    BOOL result = NO;
    do {
        if (!theEvent) {
            break;
        }
        
        NSPoint loc = theEvent.locationInWindow;
        
        do {
            NSPoint topLeft = NSMakePoint(self.cropRect.origin.x, self.cropRect.origin.y + self.cropRect.size.height);
            if ([self isMouseHitLocation:loc inAnchor:topLeft]) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_TopLeft;
                break;
            } else {
                NSPoint bottomLeft = self.cropRect.origin;
                if ([self isMouseHitLocation:loc inAnchor:bottomLeft]) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomLeft;
                    break;
                } else {
                    NSPoint topRight = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height);
                    if ([self isMouseHitLocation:loc inAnchor:topRight]) {
                        self.mouseHitLocation = DCImageCropMouseHitLoc_TopRight;
                        break;
                    } else {
                        NSPoint bottomRight = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y);
                        if ([self isMouseHitLocation:loc inAnchor:bottomRight]) {
                            self.mouseHitLocation = DCImageCropMouseHitLoc_BottomRight;
                            break;
                        } else {
                            NSPoint topCenter = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width / 2.0f, self.cropRect.origin.y + self.cropRect.size.height);
                            if ([self isMouseHitLocation:loc inAnchor:topCenter]) {
                                self.mouseHitLocation = DCImageCropMouseHitLoc_TopCenter;
                                break;
                            } else {
                                NSPoint bottomCenter = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width / 2.0f, self.cropRect.origin.y);
                                if ([self isMouseHitLocation:loc inAnchor:bottomCenter]) {
                                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomCenter;
                                    break;
                                } else {
                                    NSPoint leftCenter = NSMakePoint(self.cropRect.origin.x, self.cropRect.origin.y + self.cropRect.size.height / 2.0f);
                                    if ([self isMouseHitLocation:loc inAnchor:leftCenter]) {
                                        self.mouseHitLocation = DCImageCropMouseHitLoc_LeftCenter;
                                        break;
                                    } else {
                                        NSPoint rightCenter = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height / 2.0f);
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
    do {
        if (!theEvent) {
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
                [self actionForMoveWithMouseHitLocation:loc];
            }
                break;
            case DCImageCropMouseHitLoc_TopLeft:
            {
                [self actionForTopLeftWithMouseHitLocation:loc];
            }
                break;
            case DCImageCropMouseHitLoc_BottomLeft:
            {
                [self actionForBottomLeftWithMouseHitLocation:loc];
            }
                break;
            case DCImageCropMouseHitLoc_TopRight:
            {
                [self actionForTopRightWithMouseHitLocation:loc];
            }
                break;
            case DCImageCropMouseHitLoc_BottomRight:
            {
                [self actionForBottomRightWithMouseHitLocation:loc];
            }
                break;
            case DCImageCropMouseHitLoc_TopCenter:
            {
                [self actionForTopCenterWithMouseHitLocation:loc];
            }
                break;
            case DCImageCropMouseHitLoc_BottomCenter:
            {
                [self actionForBottomCenterWithMouseHitLocation:loc];
            }
                break;
            case DCImageCropMouseHitLoc_LeftCenter:
            {
                [self actionForLeftCenterWithMouseHitLocation:loc];
            }
                break;
            case DCImageCropMouseHitLoc_RightCenter:
            {
                [self actionForRightCenterWithMouseHitLocation:loc];
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
        [self.actionDelegate imageEditTool:self valueChanged:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:loc.x], kImageEditPragma_CropMouseHitLocationX, [NSNumber numberWithFloat:loc.y], kImageEditPragma_CropMouseHitLocationY, nil]];
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
