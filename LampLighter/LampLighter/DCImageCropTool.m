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

CGSize DCImageCropRatioAry[] = {{0, 0}, {1, 1}, {2, 3}, {3, 5}, {5, 7}, {3, 4}, {4, 3}, {9, 16}, {16, 9}, {10, 16}, {16, 10}, {210, 297}};

NSString *kImageEditPragma_CropMouseHitLocationX = @"ImageEditPragma_CropMouseHitLocationX";
NSString *kImageEditPragma_CropMouseHitLocationY = @"ImageEditPragma_CropMouseHitLocationY";

@interface DCImageCropTool () {
}

@property (assign, nonatomic) CGFloat scaleBeforeResize;

@end

@implementation DCImageCropTool

@synthesize type = _type;
@synthesize mouseHitLocation = _mouseHitLocation;
@synthesize cropRect = _cropRect;
@synthesize scaleBeforeResize = _scaleBeforeResize;

- (id)init {
    self = [super init];
    if (self) {
        self.type = DCImageCropType_Custom;
        self.mouseHitLocation = DCImageCropMouseHitLoc_Outside;
        self.cropRect = NSMakeRect(0.0f, 0.0f, 0.0f, 0.0f);
        self.scaleBeforeResize = 0.0f;
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
        if (!self.currentImg) {
            break;
        }
        
        if (DC_FloatingNumberEqualToZero(self.cropRect.size.width) && DC_FloatingNumberEqualToZero(self.cropRect.size.height)) {
            [self resetCropRectInRect:self.currentImg.visiableRect withMouseHitLocation:DCImageCropMouseHitLoc_Inside andLockPoint:NSMakePoint(0.0f, 0.0f)];
        }
        
        if (!DC_FloatingNumberEqualToZero(self.scaleBeforeResize)) {
            CGFloat originX = self.cropRect.origin.x * self.currentImg.scaleX / self.scaleBeforeResize;
            CGFloat originY = self.cropRect.origin.y * self.currentImg.scaleX / self.scaleBeforeResize;
            CGFloat sizeW = self.cropRect.size.width * self.currentImg.scaleX / self.scaleBeforeResize;
            CGFloat sizeH = self.cropRect.size.height * self.currentImg.scaleX / self.scaleBeforeResize;
            self.cropRect = NSMakeRect(originX, originY, sizeW, sizeH);
            self.scaleBeforeResize = 0.0f;
        }
        
        CGFloat leftX = self.cropRect.origin.x;
        CGFloat middleX = self.cropRect.origin.x + self.cropRect.size.width / 2.0f;
        CGFloat rightX = self.cropRect.origin.x + self.cropRect.size.width;
        
        CGFloat topY = self.cropRect.origin.y + self.cropRect.size.height;
        CGFloat centerY = self.cropRect.origin.y + self.cropRect.size.height / 2.0f;
        CGFloat bottomY = self.cropRect.origin.y;
        
        // Mask
        maskColor = CGColorCreateGenericRGB(DC_RGB256(25.0f), DC_RGB256(25.0f), DC_RGB256(25.0f), 0.8f);
        CGContextSetFillColorWithColor(context, maskColor);
        // TopLeftRect
        NSRect topLectRect = DCMakeIntegerRect(0.0f, bottomY, leftX, bounds.size.height - bottomY);
        CGContextFillRect(context, topLectRect);
        // BottomLeftRect
        NSRect bottomLeftRect = DCMakeIntegerRect(0.0f, 0.0f, rightX, bottomY);
        CGContextFillRect(context, bottomLeftRect);
        // TopRightRect
        NSRect topRightRect = DCMakeIntegerRect(leftX, topY, bounds.size.width - leftX, bounds.size.height - topY);
        CGContextFillRect(context, topRightRect);
        // BottomRightRect
        NSRect bottomRightRect = DCMakeIntegerRect(rightX, 0.0f, bounds.size.width - rightX, topY);
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
        
        if (self.type == DCImageCropType_Custom) {
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
        }
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
        if (!self.currentImg) {
            break;
        }
        
        [super active];
        
//        self.cropRect = self.currentImg.visiableRect;
        
        self.cropRect = NSMakeRect(0.0f, 0.0f, 0.0f, 0.0f);
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
//        self.cropRect = NSMakeRect(0.0f, 0.0f, 0.0f, 0.0f);
        if (!self.currentImg) {
            break;
        }
        self.scaleBeforeResize = self.currentImg.scaleX;
    } while (NO);
}

- (void)resetCropRectInRect:(NSRect)bounds withMouseHitLocation:(DCImageCropMouseHitLocation)location andLockPoint:(NSPoint)lockPoint {
    do {
        if (!self.currentImg) {
            break;
        }
        NSPoint centerPoint = NSMakePoint(bounds.origin.x + bounds.size.width / 2.0f, bounds.origin.y + bounds.size.height / 2.0f);
        CGFloat ratioForVisiableRect = bounds.size.width / bounds.size.height;
        CGFloat ratioForCropRect = DCImageCropRatioAry[self.type].width / DCImageCropRatioAry[self.type].height;
        CGFloat cropRectWidth = 0.0f;
        CGFloat cropRectHeight = 0.0f;
        switch (self.type) {
            case DCImageCropType_Custom:
            {
                self.cropRect = bounds;
            }
                break;
            case DCImageCropType_1x1:
            case DCImageCropType_2x3:
            case DCImageCropType_3x5:
            case DCImageCropType_5x7:
            case DCImageCropType_4x3_Portait:
            case DCImageCropType_4x3_Landscape:
            case DCImageCropType_16x9_Portait:
            case DCImageCropType_16x9_Landscape:
            case DCImageCropType_16x10_Portait:
            case DCImageCropType_16x10_Landscape:
            case DCImageCropType_A4:
            {
                if (ratioForVisiableRect > ratioForCropRect) {
                    cropRectWidth = bounds.size.height * DCImageCropRatioAry[self.type].width / DCImageCropRatioAry[self.type].height;
                    cropRectHeight = bounds.size.height;
                } else if (ratioForVisiableRect < ratioForCropRect) {
                    cropRectWidth = bounds.size.width;
                    cropRectHeight = bounds.size.width * DCImageCropRatioAry[self.type].height / DCImageCropRatioAry[self.type].width;
                } else {
                    cropRectWidth = bounds.size.width;
                    cropRectHeight = bounds.size.height;
                }
//                self.cropRect = NSMakeRect(centerPoint.x - cropRectWidth / 2.0f, centerPoint.y - cropRectHeight / 2.0f, cropRectWidth, cropRectHeight);
            }
                break;
            default:
                break;
        }
        
        if (self.type != DCImageCropType_Custom) {
            switch (location) {
                case DCImageCropMouseHitLoc_TopLeft:
                {
                    self.cropRect = NSMakeRect(lockPoint.x - cropRectWidth, lockPoint.y, cropRectWidth, cropRectHeight);
                }
                    break;
                case DCImageCropMouseHitLoc_BottomLeft:
                {
                    self.cropRect = NSMakeRect(lockPoint.x - cropRectWidth, lockPoint.y - cropRectHeight, cropRectWidth, cropRectHeight);
                }
                    break;
                case DCImageCropMouseHitLoc_TopRight:
                {
                    self.cropRect = NSMakeRect(lockPoint.x, lockPoint.y, cropRectWidth, cropRectHeight);
                }
                    break;
                case DCImageCropMouseHitLoc_BottomRight:
                {
                    self.cropRect = NSMakeRect(lockPoint.x, lockPoint.y - cropRectHeight, cropRectWidth, cropRectHeight);
                }
                    break;
                case DCImageCropMouseHitLoc_Inside:
                {
                    self.cropRect = NSMakeRect(centerPoint.x - cropRectWidth / 2.0f, centerPoint.y - cropRectHeight / 2.0f, cropRectWidth, cropRectHeight);
                }
                    break;
                default:
                    break;
            }
        }
        
    } while (NO);
}

- (BOOL)isEdited {
    BOOL result = NO;
    do {
        if (!self.currentImg) {
            break;
        }
        if (DC_FloatingNumberEqualToZero(self.cropRect.size.width) && DC_FloatingNumberEqualToZero(self.cropRect.size.height)) {
            break;
        }
        CGFloat width = self.cropRect.size.width / self.currentImg.scaleX;
        CGFloat height = self.cropRect.size.height / self.currentImg.scaleX;
        if (DC_FloatingNumberEqual(width, self.currentImg.editedImageSize.width) && DC_FloatingNumberEqual(height, self.currentImg.editedImageSize.height)) {
            ;
        } else {
            result = YES;
        }
    } while (NO);
    return result;
}

- (void)resetCropType:(DCImageCropType)newType {
    do {
        if (self.type == newType) {
            break;
        }
        self.type = newType;
        self.cropRect = NSMakeRect(0.0f, 0.0f, 0.0f, 0.0f);
    } while (NO);
}

#pragma mark - Private

@end
