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

const CGFloat kDCImageRotateTool_BaseRadius = 64.0f;
const CGFloat kDCImageRotateTool_ArcLength = kDCImageRotateTool_BaseRadius;
const CGFloat kDCImageRotateTool_BaseLineLength = kDCImageRotateTool_BaseRadius * 2;
const CGFloat kDCImageRotateTool_HandleLineLength = kDCImageRotateTool_BaseRadius * 3;

@interface DCImageRotateTool () {
}

@property (assign, nonatomic) NSPoint handleLocation;

@end

@implementation DCImageRotateTool

@synthesize rotation = _rotation;
@synthesize handleLocation = _handleLocation;

- (id)init {
    self = [super init];
    if (self) {
        self.rotation = 0.0f;
        self.handleLocation = NSMakePoint(0.0f, 0.0f);
    }
    return self;
}

#pragma mark - Public
- (NSString *)imageEditToolDescription {
    return @"Rotate";
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        CGRect imageVisiableRect = self.currentImg.visiableRect;
        NSPoint center = NSMakePoint(imageVisiableRect.origin.x + imageVisiableRect.size.width / 2.0f, imageVisiableRect.origin.y + imageVisiableRect.size.height / 2.0f);
        
        CGContextSetLineWidth(context, 2.0f);
        // BaseLine
        [[NSColor maraschinoColor] set];
        CGContextMoveToPoint(context, center.x, center.y);
        NSPoint baseLineLocation = NSMakePoint(center.x, (center.y + kDCImageRotateTool_BaseLineLength > bounds.size.height ? bounds.size.height : center.y + kDCImageRotateTool_BaseLineLength));
        CGContextAddLineToPoint(context, baseLineLocation.x, baseLineLocation.y);
        CGContextStrokePath(context);
        // HandleLine
        [[NSColor aquaColor] set];
        CGContextMoveToPoint(context, center.x, center.y);
        
        CGFloat radian = DEGREES_TO_RADIANS(self.rotation);
        NSPoint handleLineLocation = NSMakePoint(0.0f, 0.0f);
        
        handleLineLocation.x = center.x - sinf(radian) * kDCImageRotateTool_HandleLineLength;
        if (handleLineLocation.x < 0.0f) {
            handleLineLocation.x = 0.0f;
        }
        if (handleLineLocation.x > bounds.size.width) {
            handleLineLocation.x = bounds.size.width;
        }
        
        handleLineLocation.y = center.y + cosf(radian) * kDCImageRotateTool_HandleLineLength;
        if (handleLineLocation.y < 0.0f) {
            handleLineLocation.y = 0.0f;
        }
        if (handleLineLocation.y > bounds.size.height) {
            handleLineLocation.y = bounds.size.height;
        }

        CGContextAddLineToPoint(context, handleLineLocation.x, handleLineLocation.y);
        CGContextStrokePath(context);
        // Arc
        [[NSColor mochaColor] set];
        if (self.rotation < 360.0f) {
            CGContextAddArc(context, center.x, center.y, kDCImageRotateTool_ArcLength, 0.0f + M_PI_2, radian + M_PI_2, 0);
            CGContextStrokePath(context);
        }
        
        // Handle
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
        
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageEditTool:valueChanged:)]) {
            [self.actionDelegate imageEditTool:self valueChanged:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:_rotation], kImageEditPragma_Rotation, nil]];
        }
    } while (NO);
}

#pragma mark - NSResponder
- (void)mouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
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
    do {
        if (!theEvent) {
            break;
        }
    } while (NO);
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
