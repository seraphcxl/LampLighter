//
//  DCImageEditViewController.m
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditViewController.h"
#import "DCEditableImage.h"

@interface DCImageEditViewController () {
}

@property (strong, nonatomic) NSString *activeEditToolGUID;
@property (strong, nonatomic) NSMutableDictionary *editToolDict;
@property (assign, nonatomic) DCEditImageScaleType scaleType;
@property (strong, nonatomic) DCEditableImage *currentImg;

- (NSString *)getEditToolGUID:(DCImageEditTool *)imageEditTool;
- (void)saveEditableImage;

@end

@implementation DCImageEditViewController

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
        self.scaleType = DCEditImageScaleType_Fitin;
        self.editToolDict = [NSMutableDictionary dictionary];
        self.currentImg = nil;
    }
    return self;
}

- (void)dealloc {
    do {
        [self saveEditableImage];
        
        [self.editToolDict removeAllObjects];
        self.editToolDict = nil;
        self.currentImg = nil;
    } while (NO);
}

- (void)loadView {
    do {
        [super loadView];
    } while (NO);
}

#pragma mark - Public
- (void)resetCurrentImage:(DCEditableImage *)editableImage {
    do {
        if (!editableImage) {
            break;
        }
        
        [self saveEditableImage];
        
        self.currentImg = editableImage;
    } while (NO);
}

- (void)resetScaleType:(DCEditImageScaleType)scaleType {
    do {
        if (self.scaleType == scaleType) {
            break;
        }
        switch (scaleType) {
            case DCEditImageScaleType_Fitin:
            {
            }
                break;
            case DCEditImageScaleType_Actual:
            {
            }
                break;
            case DCEditImageScaleType_Zoom:
            {
            }
                break;
            default:
                break;
        }
        self.scaleType = scaleType;
    } while (NO);
}

- (BOOL)addEditTool:(DCImageEditTool *)imageEditTool {
    BOOL result = NO;
    do {
        if (!imageEditTool) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)activeEditTool:(DCImageEditTool *)imageEditTool {
    BOOL result = NO;
    do {
        if (!imageEditTool) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)activeEditToolByClassName:(NSString *)imageEditToolClassName {
    BOOL result = NO;
    do {
        if (!imageEditToolClassName) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

#pragma mark - Private
- (NSString *)getEditToolGUID:(DCImageEditTool *)imageEditTool {
    NSString *result = nil;
    do {
        if (!imageEditTool) {
            break;
        }
        result = [imageEditTool className];
    } while (NO);
    return result;
}

- (void)saveEditableImage {
    do {
        BOOL isEdited = NO;
        NSArray *editToolAry = [self.editToolDict allValues];
        for (DCImageEditTool *tool in editToolAry) {
            if ([tool isEdited]) {
                isEdited = YES;
                break;
            }
        }
        if (isEdited) {
            // need ask for save edited image.
        }
    } while (NO);
}

#pragma mark - DCImageEditToolActionDelegate
- (void)imageEditTool:(DCImageEditTool *)tool valueChanged:(NSDictionary *)infoDict {
    do {
        if (!tool || !infoDict) {
            break;
        }
    } while (NO);
}

- (void)imageEditToolReseted:(DCImageEditTool *)tool {
    do {
        if (!tool) {
            break;
        }
    } while (NO);
}

#pragma mark - DCImageEditViewDrawDelegate
- (void)imageEditView:(DCImageEditView *)view drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!view || !context) {
            break;
        }
        
        if (self.currentImg) {
            [self.currentImg drawWithContext:context inRect:bounds];
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool drawWithContext:context inRect:bounds];
            }
        }
    } while (NO);
}

#pragma mark - NSResponder
- (void)mouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool mouseDown:theEvent];
            }
        }
    } while (NO);
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool rightMouseDown:theEvent];
            }
        }
    } while (NO);
}

- (void)otherMouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool otherMouseDown:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool mouseUp:theEvent];
            }
        }
    } while (NO);
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool rightMouseUp:theEvent];
            }
        }
    } while (NO);
}

- (void)otherMouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool otherMouseUp:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseMoved:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool mouseMoved:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool mouseDragged:theEvent];
            }
        }
    } while (NO);
}

- (void)scrollWheel:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool scrollWheel:theEvent];
            }
        }
    } while (NO);
}

- (void)rightMouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool rightMouseDragged:theEvent];
            }
        }
    } while (NO);
}

- (void)otherMouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool otherMouseDragged:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseEntered:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool mouseEntered:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseExited:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool mouseExited:theEvent];
            }
        }
    } while (NO);
}

- (void)keyDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool keyDown:theEvent];
            }
        }
    } while (NO);
}

- (void)keyUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool keyUp:theEvent];
            }
        }
    } while (NO);
}

@end
