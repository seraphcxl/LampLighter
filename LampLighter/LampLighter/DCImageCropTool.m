//
//  DCImageCropTool.m
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageCropTool.h"
#import "DCEditableImage.h"
#import "DCImageCropTool+ActionList.h"

CGSize DCImageCropRatioAry[] = {{0, 0}, {1, 1}, {2, 3}, {3, 5}, {5, 7}, {4, 3}, {3, 4}, {16, 9}, {9, 16}, {16, 10}, {10, 16}, {210, 297}};

NSString *kImageEditPragma_CropMouseHitLocationX = @"ImageEditPragma_CropMouseHitLocationX";
NSString *kImageEditPragma_CropMouseHitLocationY = @"ImageEditPragma_CropMouseHitLocationY";

@interface DCImageCropTool () {
}

@property (assign, nonatomic) DCImageCropType type;
@property (assign, nonatomic) DCImageCropMouseHitLocation mouseHitLocation;

// Corner anchor
@property (assign, nonatomic) NSRect cropRect;

@end

@implementation DCImageCropTool

@synthesize type = _type;
@synthesize mouseHitLocation = _mouseHitLocation;
@synthesize cropRect = _cropRect;

- (id)init {
    self = [super init];
    if (self) {
        self.type = DCImageCropType_Custom;
        self.mouseHitLocation = DCImageCropMouseHitLoc_Outside;
        self.cropRect = NSMakeRect(0.0f, 0.0f, 0.0f, 0.0f);
    }
    return self;
}

#pragma mark - Public
+ (NSString *)descriptionForImageCropType:(DCImageCropType)type {
    NSString *result = nil;
    do {
        switch (type) {
            case DCImageCropType_Custom:
            {
                result = @"Custom";
            }
                break;
            case DCImageCropType_1x1:
            {
                result = @"1 x 1";
            }
                break;
            case DCImageCropType_2x3:
            {
                result = @"2 x 3";
            }
                break;
            case DCImageCropType_3x5:
            {
                result = @"3 x 5";
            }
                break;
            case DCImageCropType_5x7:
            {
                result = @"5 x 7";
            }
                break;
            case DCImageCropType_4x3_Portait:
            {
                result = @"4 x 3 Portait";
            }
                break;
            case DCImageCropType_4x3_Landscape:
            {
                result = @"4 x 3 Landscape";
            }
                break;
            case DCImageCropType_16x9_Portait:
            {
                result = @"16 x 9 Portait";
            }
                break;
            case DCImageCropType_16x9_Landscape:
            {
                result = @"16 x 9 Landscape";
            }
                break;
            case DCImageCropType_16x10_Portait:
            {
                result = @"16 x 10 Portait";
            }
                break;
            case DCImageCropType_16x10_Landscape:
            {
                result = @"16 x 10 Landscape";
            }
                break;
            case DCImageCropType_A4:
            {
                result = @"A4";
            }
                break;
            default:
            {
                NSAssert(0, @"no support!");
            }
                break;
        }
    } while (NO);
    return result;
}

- (NSString *)imageEditToolDescription {
    return @"Crop";
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    CGColorRef maskColor = NULL;
    CGColorRef cropRectColor = NULL;
    CGColorRef cornerAnchorColor = NULL;
    CGColorRef centerAnchorColor = NULL;
    do {
        if (self.cropRect.size.width == 0 && self.cropRect.size.height == 0) {
            [self resetCropRect];
        }
        
        CGFloat leftX = self.cropRect.origin.x;
        CGFloat middleX = self.cropRect.origin.x + self.cropRect.size.width / 2.0f;
        CGFloat rightX = self.cropRect.origin.x + self.cropRect.size.width;
        
        CGFloat topY = self.cropRect.origin.y + self.cropRect.size.height;
        CGFloat centerY = self.cropRect.origin.y + self.cropRect.size.height / 2.0f;
        CGFloat bottomY = self.cropRect.origin.y;
        
        // Mask
        maskColor = CGColorCreateGenericRGB(DC_RGB256(0.0f), DC_RGB256(64.0f), DC_RGB256(128.0f), 0.5f);
        CGContextSetFillColorWithColor(context, maskColor);
        // TopLeftRect
        NSRect topLectRect = NSMakeRect(0.0f, bottomY, self.cropRect.origin.x, bounds.size.height - self.cropRect.origin.y);
        CGContextFillRect(context, topLectRect);
        // BottomLeftRect
        NSRect bottomLeftRect = NSMakeRect(0.0f, 0.0f, self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y);
        CGContextFillRect(context, bottomLeftRect);
        // TopRightRect
        NSRect topRightRect = NSMakeRect(leftX, topY, bounds.size.width - self.cropRect.origin.x, bounds.size.height - self.cropRect.origin.y - self.cropRect.size.height);
        CGContextFillRect(context, topRightRect);
        // BottomRightRect
        NSRect bottomRightRect = NSMakeRect(rightX, 0.0f, bounds.size.width - self.cropRect.origin.x - self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height);
        CGContextFillRect(context, bottomRightRect);
        // CropRect
        cropRectColor = CGColorCreateGenericRGB(DC_RGB256(128.0f), DC_RGB256(64.0f), DC_RGB256(0.0f), 1.0f);
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, cropRectColor);
        CGContextAddRect(context, self.cropRect);
        CGContextStrokePath(context);
        // Corner anchor
        cornerAnchorColor = CGColorCreateGenericRGB(DC_RGB256(255.0f), DC_RGB256(102.0f), DC_RGB256(102.0f), 1.0f);
        CGContextSetFillColorWithColor(context, cornerAnchorColor);
        // TopLeftAnchor
        NSPoint topLeftAnchor = NSMakePoint(leftX, topY);
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:topLeftAnchor]);
        // BottomLeftAnchor
        NSPoint bottomLeftAnchor = NSMakePoint(leftX, bottomY);
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:bottomLeftAnchor]);
        // TopRightAnchor
        NSPoint topRightAnchor = NSMakePoint(rightX, topY);
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:topRightAnchor]);
        // BottomRightAnchor
        NSPoint bottomRightAnchor = NSMakePoint(rightX, bottomY);
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:bottomRightAnchor]);
        // Center anchor
        centerAnchorColor = CGColorCreateGenericRGB(DC_RGB256(255.0f), DC_RGB256(255.0f), DC_RGB256(0.0f), 1.0f);
        CGContextSetFillColorWithColor(context, centerAnchorColor);
        // TopCenterAnchor
        NSPoint topCenterAnchor = NSMakePoint(middleX, topY);
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:topCenterAnchor]);
        // BottomCenterAnchor
        NSPoint bottomCenterAnchor = NSMakePoint(middleX, bottomY);
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:bottomCenterAnchor]);
        // LeftCenterAnchor
        NSPoint leftCenterAnchor = NSMakePoint(leftX, centerY);
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:leftCenterAnchor]);
        // RightCenterAnchor
        NSPoint rightCenterAnchor = NSMakePoint(rightX, centerY);
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:rightCenterAnchor]);
    } while (NO);
    if (maskColor) {
        CGColorRelease(maskColor);
        maskColor = NULL;
    }
    if (cropRectColor) {
        CGColorRelease(cropRectColor);
        cropRectColor = NULL;
    }
    if (cornerAnchorColor) {
        CGColorRelease(cornerAnchorColor);
        cornerAnchorColor = NULL;
    }
    if (centerAnchorColor) {
        CGColorRelease(centerAnchorColor);
        centerAnchorColor = NULL;
    }
}

- (void)active {
    do {
        [super active];
    } while (NO);
}

- (void)deactive {
    do {
        self.cropRect = NSMakeRect(0.0f, 0.0f, 0.0f, 0.0f);
        
        [super deactive];
    } while (NO);
}

- (void)imageEditorViewDidResized:(NSNotification *)notification {
    do {
        self.cropRect = NSMakeRect(0.0f, 0.0f, 0.0f, 0.0f);
    } while (NO);
}

- (void)resetCropRect {
    do {
        if (!self.currentImg) {
            break;
        }
        self.cropRect = self.currentImg.visiableRect;
    } while (NO);
}

#pragma mark - Private

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
    BOOL result = NO;
    do {
        if (!theEvent) {
            break;
        }
        self.mouseHitLocation = DCImageCropMouseHitLoc_Outside;
        result = YES;
    } while (NO);
    return result;
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
