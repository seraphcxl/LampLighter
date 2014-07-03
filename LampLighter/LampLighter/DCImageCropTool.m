//
//  DCImageCropTool.m
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageCropTool.h"
#import "DCImageCropTool+ActionList.h"

CGSize DCImageCropRatioAry[] = {{0, 0}, {1, 1}, {2, 3}, {3, 5}, {5, 7}, {4, 3}, {3, 4}, {16, 9}, {9, 16}, {16, 10}, {10, 16}, {210, 297}};

const NSUInteger kImageEditor_Crop_DefaultAnchorRadius = 8;

NSString *kImageEditPragma_CropMouseHitLocationX = @"ImageEditPragma_CropMouseHitLocationX";
NSString *kImageEditPragma_CropMouseHitLocationY = @"ImageEditPragma_CropMouseHitLocationY";

@interface DCImageCropTool () {
}

@property (assign, nonatomic) DCImageCropType type;
@property (assign, nonatomic) DCImageCropMouseHitLocation mouseHitLocation;

// Corner anchor
@property (assign, nonatomic) NSRect cropRect;

- (NSRect)createRectForAnchorByCenterPoint:(NSPoint)center;

@end

@implementation DCImageCropTool

@synthesize anchorRadius = _anchorRadius;
@synthesize type = _type;
@synthesize mouseHitLocation = _mouseHitLocation;
@synthesize cropRect = _cropRect;

- (id)init {
    self = [super init];
    if (self) {
        self.anchorRadius = kImageEditor_Crop_DefaultAnchorRadius;
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
    do {
        ;
    } while (NO);
}

#pragma mark - Private
- (NSRect)createRectForAnchorByCenterPoint:(NSPoint)center {
    NSUInteger diameter = self.anchorRadius * 2;
    return NSMakeRect(center.x - self.anchorRadius, center.y - self.anchorRadius, diameter, diameter);
}

#pragma mark - NSResponder
- (void)mouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        NSPoint loc = theEvent.locationInWindow;
        
        do {
            NSPoint topLeft = NSMakePoint(self.cropRect.origin.x, self.cropRect.origin.y + self.cropRect.size.height);
            if (NSPointInRect(loc, [self createRectForAnchorByCenterPoint:topLeft])) {
                self.mouseHitLocation = DCImageCropMouseHitLoc_TopLeft;
                break;
            } else {
                NSPoint bottomLeft = self.cropRect.origin;
                if (NSPointInRect(loc, [self createRectForAnchorByCenterPoint:bottomLeft])) {
                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomLeft;
                    break;
                } else {
                    NSPoint topRight = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height);
                    if (NSPointInRect(loc, [self createRectForAnchorByCenterPoint:topRight])) {
                        self.mouseHitLocation = DCImageCropMouseHitLoc_TopRight;
                        break;
                    } else {
                        NSPoint bottomRight = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y);
                        if (NSPointInRect(loc, [self createRectForAnchorByCenterPoint:bottomRight])) {
                            self.mouseHitLocation = DCImageCropMouseHitLoc_BottomRight;
                            break;
                        } else {
                            NSPoint topCenter = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width / 2.0f, self.cropRect.origin.y + self.cropRect.size.height);
                            if (NSPointInRect(loc, [self createRectForAnchorByCenterPoint:topCenter])) {
                                self.mouseHitLocation = DCImageCropMouseHitLoc_TopCenter;
                                break;
                            } else {
                                NSPoint bottomCenter = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width / 2.0f, self.cropRect.origin.y);
                                if (NSPointInRect(loc, [self createRectForAnchorByCenterPoint:bottomCenter])) {
                                    self.mouseHitLocation = DCImageCropMouseHitLoc_BottomCenter;
                                    break;
                                } else {
                                    NSPoint leftCenter = NSMakePoint(self.cropRect.origin.x, self.cropRect.origin.y + self.cropRect.size.height / 2.0f);
                                    if (NSPointInRect(loc, [self createRectForAnchorByCenterPoint:leftCenter])) {
                                        self.mouseHitLocation = DCImageCropMouseHitLoc_LeftCenter;
                                        break;
                                    } else {
                                        NSPoint rightCenter = NSMakePoint(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y + self.cropRect.size.height / 2.0f);
                                        if (NSPointInRect(loc, [self createRectForAnchorByCenterPoint:rightCenter])) {
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
        
    } while (NO);
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)otherMouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)mouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        self.mouseHitLocation = DCImageCropMouseHitLoc_Outside;
    } while (NO);
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)otherMouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)mouseMoved:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)mouseDragged:(NSEvent *)theEvent {
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
    } while (NO);
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageEditTool:valueChanged:)]) {
        [self.actionDelegate imageEditTool:self valueChanged:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:loc.x], kImageEditPragma_CropMouseHitLocationX, [NSNumber numberWithFloat:loc.y], kImageEditPragma_CropMouseHitLocationY, nil]];
    }
}

- (void)scrollWheel:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)rightMouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)otherMouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)mouseEntered:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)mouseExited:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)keyDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

- (void)keyUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
}

@end
