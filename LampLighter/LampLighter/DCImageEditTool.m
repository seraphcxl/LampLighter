//
//  DCImageEditTool.m
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditTool.h"

const CGFloat kImageEditor_DefaultAnchorRadius = 8.0f;

@interface DCImageEditTool () {
}

@property (strong, nonatomic) DCEditableImage *currentImg;
@property (assign, nonatomic) BOOL actived;

@end

@implementation DCImageEditTool

@synthesize actionDelegate = _actionDelegate;
@synthesize type = _type;
@synthesize currentImg = _currentImg;
@synthesize actived = _actived;
@synthesize edited = _edited;
@synthesize anchorRadius = _anchorRadius;

+ (NSString *)getImageEditToolGUID:(Class)imageEditToolClass {
    NSString *result = nil;
    do {
        if (!imageEditToolClass) {
            break;
        }
        result = [imageEditToolClass description];
    } while (NO);
    return result;
}

#pragma mark - Lifecycle
- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage {
    self = [self init];
    if (self) {
        if (editableImage) {
            self.currentImg = editableImage;
            self.anchorRadius = kImageEditor_DefaultAnchorRadius;
            _anchorRadiusSqrt = powf(_anchorRadius, 2);
        }
    }
    return self;
}

#pragma mark - Public
- (void)setAnchorRadius:(CGFloat)anchorRadius {
    do {
        if (DCFloatingNumberEqualToZero(anchorRadius)) {
            break;
        }
        _anchorRadius = anchorRadius;
        _anchorRadiusSqrt = powf(_anchorRadius, 2);
    } while (NO);
}

- (void)resetEditableImage:(DCEditableImage *)editableImage {
    do {
        if (editableImage) {
            self.currentImg = editableImage;
            [self reset];
        }
    } while (NO);
}

- (NSString *)imageEditToolDescription {
    return [self className];
}

- (void)reset {
    do {
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageEditToolReseted:)]) {
            [self.actionDelegate imageEditToolReseted:self];
        }
    } while (NO);
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        ;
    } while (NO);
}

- (void)active {
    do {
        self.actived = YES;
    } while (NO);
}

- (void)deactive {
    do {
        self.actived = NO;
    } while (NO);
}

- (void)imageEditorViewDidResized:(NSNotification *)notification {
    do {
        ;
    } while (NO);
}

- (NSRect)createRectForAnchorByCenterPoint:(NSPoint)center {
    CGFloat diameter = self.anchorRadius * 2;
    return NSMakeRect(center.x - self.anchorRadius, center.y - self.anchorRadius, diameter, diameter);
}

- (BOOL)isMouseHitLocation:(NSPoint)loc inAnchor:(NSPoint)anchor {
    BOOL result = NO;
    do {
        CGFloat tmp = powf(fabsf(loc.x - anchor.x), 2) + powf(fabsf(loc.y - anchor.y), 2);
        if (tmp > _anchorRadiusSqrt) {
            ;
        } else {
            result = YES;
        }
    } while (NO);
    return result;
}

#pragma mark - Responder
- (BOOL)handleMouseDown:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleRightMouseDown:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseUp:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleRightMouseUp:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseMoved:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseDragged:(NSEvent *)theEvent {
    return NO;
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

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return nil;
}
@end
