//
//  DCPhotoEditViewController.m
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCPhotoEditViewController.h"
#import "DCEditableImage.h"

@interface DCPhotoEditViewController () {
}

@property (strong, nonatomic) NSString *activeEditToolGUID;
@property (strong, nonatomic) NSMutableDictionary *editToolDict;
@property (assign, nonatomic) DCEditImageScaleType scaleType;
@property (strong, nonatomic) DCEditableImage *currentImg;

- (NSString *)getEditToolGUID:(DCPhotoEditTool *)photoEditTool;

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
- (void)resetCurrentImage:(DCEditableImage *)editableImage {
    do {
        if (!editableImage) {
            break;
        }
        
        BOOL isEdited = NO;
        NSArray *editToolAry = [self.editToolDict allValues];
        for (DCPhotoEditTool *tool in editToolAry) {
            if ([tool isEdited]) {
                isEdited = YES;
                break;
            }
        }
        if (isEdited) {
            // need ask for save edited photo.
        }
        
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

- (BOOL)addEditTool:(DCPhotoEditTool *)photoEditTool {
    BOOL result = NO;
    do {
        if (!photoEditTool) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)activeEditTool:(DCPhotoEditTool *)photoEditTool {
    BOOL result = NO;
    do {
        if (!photoEditTool) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)activeEditToolByClassName:(NSString *)photoEditToolClassName {
    BOOL result = NO;
    do {
        if (!photoEditToolClassName) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

#pragma mark - Private
- (NSString *)getEditToolGUID:(DCPhotoEditTool *)photoEditTool {
    NSString *result = nil;
    do {
        if (!photoEditTool) {
            break;
        }
        result = [photoEditTool className];
    } while (NO);
    return result;
}

#pragma mark - DCPhotoEditToolActionDelegate
- (void)photoEditTool:(DCPhotoEditTool *)tool valueChanged:(NSDictionary *)infoDict {
    do {
        if (!tool || !infoDict) {
            break;
        }
    } while (NO);
}

- (void)photoEditToolReseted:(DCPhotoEditTool *)tool {
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
        
        if (self.currentImg) {
            [self.currentImg drawWithContext:context inRect:bounds];
        }
        
        if (self.activeEditToolGUID) {
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
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
            DCPhotoEditTool *editTool = [self.editToolDict objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool mouseExited:theEvent];
            }
        }
    } while (NO);
}

@end
