//
//  DCImageEditTool.m
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditTool.h"

const CGFloat kImageEditor_DefaultAnchorRadius = 8.0f;

NSString *kDCImageEditToolCodingType = @"DCImageEditToolCodingType";
NSString *kDCImageEditToolCodingEdited = @"DCImageEditToolCodingEdited";
NSString *kDCImageEditToolCodingAnchorRadius = @"DCImageEditToolCodingAnchorRadius";

@interface DCImageEditTool () {
}

@property (strong, nonatomic) DCEditableImage *currentImg;

- (void)applyEditionToImage;

@end

@implementation DCImageEditTool

@synthesize actionDelegate = _actionDelegate;
@synthesize type = _type;
@synthesize currentImg = _currentImg;
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
- (id)init {
    self = [super init];
    if (self) {
        self.anchorRadius = kImageEditor_DefaultAnchorRadius;
        _anchorRadiusSqrt = powf(_anchorRadius, 2);
    }
    return self;
}

- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage {
    self = [self init];
    if (self) {
        if (editableImage) {
            self.currentImg = editableImage;
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
//            [self reset];
        }
        
        if ([self isEdited]) {
            [self applyEditionToImage];
        }
    } while (NO);
}

- (BOOL)loadFormDict:(NSDictionary *)dict {
    BOOL result = NO;
    do {
        if (!dict) {
            break;
        }
        
        self.type = (DCImageEditToolType)[[dict objectForKey:kDCImageEditToolCodingType] integerValue];
        self.edited = [[dict objectForKey:kDCImageEditToolCodingEdited] boolValue];
        self.anchorRadius = [[dict objectForKey:kDCImageEditToolCodingAnchorRadius] floatValue];
        result = YES;
    } while (NO);
    return result;
}

- (NSDictionary *)getInfo {
    NSDictionary *result = nil;
    do {
        result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.type], kDCImageEditToolCodingType, [NSNumber numberWithBool:self.edited], kDCImageEditToolCodingEdited, [NSNumber numberWithFloat:self.anchorRadius], kDCImageEditToolCodingAnchorRadius, nil];
    } while (NO);
    return result;
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

- (BOOL)isMouseHitLocation:(NSPoint)loc onHorizontalLineStart:(NSPoint)start end:(NSPoint)end {
    BOOL result = NO;
    do {
        if (loc.x < start.x || loc.x > end.x) {
            break;
        }
        if (loc.y < start.y - self.anchorRadius || loc.y > start.y + self.anchorRadius) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)isMouseHitLocation:(NSPoint)loc onVerticalLineStart:(NSPoint)start end:(NSPoint)end {
    BOOL result = NO;
    do {
        if (loc.y > start.y || loc.y < end.y) {
            break;
        }
        if (loc.x < start.x - self.anchorRadius || loc.x > start.x + self.anchorRadius) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

#pragma mark - Private
- (void)applyEditionToImage {
    do {
        ;
    } while (NO);
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

- (BOOL)handleImageVisiableRectChanged {
    return NO;
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    do {
        if (!aCoder || ![aCoder allowsKeyedCoding]) {
            break;
        }
        [aCoder encodeInteger:self.type forKey:kDCImageEditToolCodingType];
        [aCoder encodeBool:self.edited forKey:kDCImageEditToolCodingEdited];
        [aCoder encodeFloat:self.anchorRadius forKey:kDCImageEditToolCodingAnchorRadius];
    } while (NO);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        DCAssert(aDecoder != nil && [aDecoder allowsKeyedCoding]);
        self.type = [aDecoder decodeIntegerForKey:kDCImageEditToolCodingType];
        self.edited = [aDecoder decodeBoolForKey:kDCImageEditToolCodingEdited];
        self.anchorRadius = [aDecoder decodeFloatForKey:kDCImageEditToolCodingAnchorRadius];
    }
    return self;
}
@end
