//
//  DCImageRotateTool.m
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageRotateTool.h"
#import "DCEditableImage.h"

NSString *kImageEditPragma_Rotation = @"ImageEditPragma_Rotation";

NSString *kDCImageRotateToolRotation = @"DCImageRotateToolRotation";

const CGFloat kDCImageRotateTool_BaseRadius = 64.0f;
const CGFloat kDCImageRotateTool_ArcLength = kDCImageRotateTool_BaseRadius;
const CGFloat kDCImageRotateTool_BaseLineLength = kDCImageRotateTool_BaseRadius * 2;
const CGFloat kDCImageRotateTool_HandleLineLength = kDCImageRotateTool_BaseRadius * 3;

@interface DCImageRotateTool () {
}

@property (assign, nonatomic) NSPoint centerPoint;
@property (assign, nonatomic) NSPoint handleLocation;
@property (assign, nonatomic) BOOL canDragHandle;

@end

@implementation DCImageRotateTool

@synthesize rotation = _rotation;
@synthesize centerPoint = _centerPoint;
@synthesize handleLocation = _handleLocation;
@synthesize canDragHandle = _canDragHandle;

- (id)init {
    self = [super init];
    if (self) {
        self.type = DCImageEditToolType_Rotate;
        self.rotation = 0.0f;
        self.centerPoint = NSMakePoint(0.0f, 0.0f);
        self.handleLocation = NSMakePoint(0.0f, 0.0f);
        self.canDragHandle = NO;
    }
    return self;
}

#pragma mark - Public
- (BOOL)loadFormDict:(NSDictionary *)dict {
    BOOL result = NO;
    do {
        if (!dict) {
            break;
        }
        if (![super loadFormDict:dict]) {
            break;
        }
        self.rotation = ABS(360.0f - [[dict objectForKey:kDCImageRotateToolRotation] floatValue]);
    } while (NO);
    return result;
}

- (NSDictionary *)getInfo {
    NSMutableDictionary *result = nil;
    do {
        NSDictionary *tmp = [super getInfo];
        if (!tmp) {
            break;
        }
        
        result = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.rotation], kDCImageRotateToolRotation, nil];
        
        [result addEntriesFromDictionary:tmp];
    } while (NO);
    return result;
}

- (NSString *)imageEditToolDescription {
    return @"Rotate";
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        CGRect imageVisiableRect = self.currentImg.visiableRect;
        self.centerPoint = NSMakePoint(imageVisiableRect.origin.x + imageVisiableRect.size.width / 2.0f, imageVisiableRect.origin.y + imageVisiableRect.size.height / 2.0f);
        
        // Line
        CGContextSetLineWidth(context, 2.0f);
        // BaseLine
        [[NSColor maraschinoColor] set];
        CGContextMoveToPoint(context, self.centerPoint.x, self.centerPoint.y);
        NSPoint baseLineLocation = NSMakePoint(self.centerPoint.x, (self.centerPoint.y + kDCImageRotateTool_BaseLineLength > bounds.size.height ? bounds.size.height : self.centerPoint.y + kDCImageRotateTool_BaseLineLength));
        CGContextAddLineToPoint(context, baseLineLocation.x, baseLineLocation.y);
        CGContextStrokePath(context);
        // HandleLine
        [[NSColor aquaColor] set];
        CGContextMoveToPoint(context, self.centerPoint.x, self.centerPoint.y);
        
        CGFloat radian = DCDegreesToRadians(self.rotation);
        NSPoint handleLineLocation = NSMakePoint(0.0f, 0.0f);
        
        handleLineLocation.x = self.centerPoint.x - sinf(radian) * kDCImageRotateTool_HandleLineLength;
//        if (handleLineLocation.x < 0.0f) {
//            handleLineLocation.x = 0.0f;
//        }
//        if (handleLineLocation.x > bounds.size.width) {
//            handleLineLocation.x = bounds.size.width;
//        }
        
        handleLineLocation.y = self.centerPoint.y + cosf(radian) * kDCImageRotateTool_HandleLineLength;
//        if (handleLineLocation.y < 0.0f) {
//            handleLineLocation.y = 0.0f;
//        }
//        if (handleLineLocation.y > bounds.size.height) {
//            handleLineLocation.y = bounds.size.height;
//        }
        
        self.handleLocation = handleLineLocation;
        CGContextAddLineToPoint(context, handleLineLocation.x, handleLineLocation.y);
        CGContextStrokePath(context);
        // Handle
        CGContextFillEllipseInRect(context, [self createRectForAnchorByCenterPoint:handleLineLocation]);
        // Arc
        [[NSColor mochaColor] set];
        if (self.rotation < 360.0f) {
            CGContextAddArc(context, self.centerPoint.x, self.centerPoint.y, kDCImageRotateTool_ArcLength, 0.0f + M_PI_2, radian + M_PI_2, 0);
            CGContextStrokePath(context);
        }
        // HandlePoint
//        [[NSColor redColor] set];
//        CGContextFillRect(context, NSMakeRect(handleLineLocation.x, handleLineLocation.y, 1, 1));
    } while (NO);
}

- (void)setRotation:(CGFloat)rotation {
    do {
        CGFloat r = 0.0f;
        r = fmodf(rotation, 360.0f);
        if (r < 0.0f) {
            r += 360.0f;
        }
        _rotation = 360.0f - r;
        
        if ((_rotation > 0.0f || _rotation < 0.0f) && (_rotation > 360.0f || _rotation < 360.0f)) {
            [self setEdited:YES];
        } else {
            [self setEdited:NO];
        }
        
        [self applyEditionToImage];
    } while (NO);
}

#pragma mark - Private
- (void)applyEditionToImage {
    do {
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageEditTool:valueChanged:)]) {
            [self.actionDelegate imageEditTool:self valueChanged:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:_rotation], kImageEditPragma_Rotation, nil]];
        }
    } while (NO);
}

#pragma mark - Responder
- (BOOL)handleMouseDown:(NSEvent *)theEvent {
    BOOL result = NO;
    do {
        if (!theEvent) {
            break;
        }
        
        NSPoint loc = theEvent.locationInWindow;
        if ([self isMouseHitLocation:loc inAnchor:self.handleLocation]) {
            self.canDragHandle = YES;
            result = YES;
        }
        
    } while (NO);
    return result;
}

- (BOOL)handleRightMouseDown:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)handleMouseUp:(NSEvent *)theEvent {
    self.canDragHandle = NO;
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
    do {
        if (!theEvent) {
            break;
        }
        if (self.canDragHandle) {
            NSPoint loc = theEvent.locationInWindow;
            CGFloat degreeNow = DCRadiansToDegrees(atanf((loc.y - self.centerPoint.y) / (loc.x - self.centerPoint.x)));
            
            if (loc.x > self.centerPoint.x) {
                self.rotation = 90.0f - degreeNow;
            } else {
                self.rotation = 360.0f - (degreeNow + 90.0f);
            }
            
            result = YES;
        }
        
    } while (NO);
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

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    do {
        if (!aCoder || ![aCoder allowsKeyedCoding]) {
            break;
        }
        [super encodeWithCoder:aCoder];
        [aCoder encodeFloat:self.rotation forKey:kDCImageRotateToolRotation];
    } while (NO);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        DCAssert(aDecoder != nil && [aDecoder allowsKeyedCoding]);
        self.rotation = ABS(360.0f - [aDecoder decodeFloatForKey:kDCImageRotateToolRotation]);
    }
    return self;
}

@end
