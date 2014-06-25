//
//  DCPhotoEditViewController.m
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCPhotoEditViewController.h"

@interface DCPhotoEditViewController () {
}

@property (strong, nonatomic) NSString *activeEditToolGUID;
@property (strong, nonatomic) NSMutableDictionary *editToolDict;
@property (assign, nonatomic) DCEditImageScaleType scaleType;
@property (strong, nonatomic) DCEditableImage *currentImg;

@end

@implementation DCPhotoEditViewController

@synthesize activeEditToolGUID = _activeEditToolGUID;
@synthesize editToolDict = _editToolDict;
@synthesize scaleType = _scaleType;
@synthesize currentImg = _currentImg;

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}
#pragma mark - Public
#pragma mark - Private
#pragma mark - DCPhotoEditToolActionDelegate
- (void)photoEditTool:(DCPhotoEditTool *)tool valueChanged:(NSDictionary *)infoDict {
    do {
        if (!tool || !infoDict) {
            break;
        }
    } while (NO);
}

- (void)photoEditToolReset:(DCPhotoEditTool *)tool {
    do {
        if (!tool) {
            break;
        }
    } while (NO);
}

#pragma mark - DCPhotoEditViewDrawDelegate
- (void)photoEditView:(DCPhotoEditView *)view drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!view || !context) {
            break;
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

@end
