//
//  DCImageCropTool.m
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageCropTool.h"

CGSize DCImageCropRatioAry[] = {{0, 0}, {1, 1}, {2, 3}, {3, 5}, {5, 7}, {4, 3}, {3, 4}, {16, 9}, {9, 16}, {16, 10}, {10, 16}, {210, 297}};

@interface DCImageCropTool () {
}

@property (assign, nonatomic) DCImageCropType type;

@end

@implementation DCImageCropTool

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
