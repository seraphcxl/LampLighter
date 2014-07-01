//
//  DCImageEditViewController.m
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditViewController.h"
#import "DCEditableImage.h"
#import "DCImageRotateTool.h"
#import "DCImageCropTool.h"

#import "Tourbillon/NSMutableDictionary+GCDThreadSafe.h"

@interface DCImageEditViewController () {
}

@property (strong, nonatomic) NSString *activeEditToolGUID;
@property (strong, nonatomic) NSMutableDictionary *editToolDict;
@property (assign, nonatomic) DCEditImageScaleType scaleType;
@property (strong, nonatomic) DCEditableImage *currentImg;

- (void)saveEditableImage:(BOOL)showDlg;
- (void)cleanEidtTools;

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
        self.editToolDict = [[NSMutableDictionary dictionary] threadSafe_init];
        self.currentImg = nil;
    }
    return self;
}

- (void)dealloc {
    do {
        [self saveEditableImage:NO];
        
        [self cleanEidtTools];
        self.editToolDict = nil;
        self.currentImg = nil;
    } while (NO);
}

- (void)loadView {
    do {
        [super loadView];
        
        if ([self.view class] == [DCImageEditView class]) {
            DCImageEditView *imageEditView = (DCImageEditView *)self.view;
            imageEditView.drawDelegate = self;
        }
        
        [self.imageEditToolDescriptionTextField setHidden:YES];
        [self.zoomDescriptionTextField setHidden:YES];
        [self.rotationDescriptionTextField setHidden:YES];
        [self.cropDescriptionTextField setHidden:YES];
        [self.imageURLTextField setHidden:YES];
    } while (NO);
}

#pragma mark - Public
- (void)resetCurrentImage:(DCEditableImage *)editableImage {
    do {
        if (!editableImage) {
            break;
        }
        
        [self saveEditableImage:NO];
        
        [self cleanEidtTools];
        
        self.currentImg = editableImage;
        
        NSString *urlStr = [[self.currentImg url] absoluteString];
        if (urlStr) {
            [self.imageURLTextField setStringValue:urlStr];
        }
    } while (NO);
    [self refresh];
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
    [self refresh];
}

- (BOOL)addEditTool:(DCImageEditTool *)imageEditTool {
    BOOL result = NO;
    do {
        if (!imageEditTool) {
            break;
        }
        
        NSString *guid = [DCImageEditTool getImageEditToolGUID:[imageEditTool class]];
        if ([self.editToolDict threadSafe_objectForKey:guid]) {
            NSAssert(0, @"Image edit tool already in VC.");
        } else {
            imageEditTool.visiable = NO;
            [self.editToolDict threadSafe_setObject:imageEditTool forKey:guid];
            imageEditTool.actionDelegate = self;
        }
        
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)activeEditToolByClass:(Class)imageEditToolClass {
    BOOL result = NO;
    do {
        if (imageEditToolClass) {
            NSString *guid = [DCImageEditTool getImageEditToolGUID:[imageEditToolClass class]];
            
            if ([guid isEqualToString:self.activeEditToolGUID]) {
                break;
            } else {
                DCImageEditTool *tool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
                if (tool) {
                    tool.visiable = NO;
                }
                
                tool = [self.editToolDict threadSafe_objectForKey:guid];
                if (tool) {
                    tool.visiable = YES;
                    [self.imageEditToolDescriptionTextField setStringValue:[tool imageEditToolDescription]];
                }
                self.activeEditToolGUID = guid;
            }
        } else {
            DCImageEditTool *tool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (tool) {
                tool.visiable = NO;
            }
            self.activeEditToolGUID = nil;
            [self.imageEditToolDescriptionTextField setStringValue:@""];
        }
        result = YES;
    } while (NO);
    [self refresh];
    return result;
}

- (DCImageEditTool *)activeEditTool {
    DCImageEditTool *result = nil;
    do {
        if (!self.activeEditToolGUID) {
            break;
        }
        result = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
    } while (NO);
    return result;
}

- (void)refresh {
    do {
        [self.view setNeedsDisplay:YES];
    } while (NO);
}

- (void)showHideInfo:(BOOL)show {
    do {
        [self.imageEditToolDescriptionTextField setHidden:!show];
        [self.zoomDescriptionTextField setHidden:!show];
        [self.rotationDescriptionTextField setHidden:!show];
        [self.cropDescriptionTextField setHidden:!show];
        [self.imageURLTextField setHidden:!show];
    } while (NO);
}

- (void)addImageEditViewToView:(NSView *)view {
    do {
        if (!view) {
            break;
        }
        [self.view removeFromSuperview];
        
        self.view.frame = view.bounds;
        
        [view addSubview:self.view];
        
        self.view.nextResponder = self;
        self.nextResponder = view;
        
    } while (NO);
}

#pragma mark - Private
- (void)saveEditableImage:(BOOL)showDlg {
    do {
        BOOL isEdited = NO;
        NSArray *editToolAry = [self.editToolDict threadSafe_allValues];
        for (DCImageEditTool *tool in editToolAry) {
            if ([tool isEdited]) {
                isEdited = YES;
                break;
            }
        }
        if (isEdited) {
            BOOL needSave = YES;
            if (showDlg) {
                // need ask for save edited image.
            }
            if (needSave) {
                // do save
            }
        }
    } while (NO);
}

- (void)cleanEidtTools {
    do {
        self.activeEditToolGUID = nil;
        
        NSArray *editToolAry = [self.editToolDict threadSafe_allValues];
        for (DCImageEditTool *tool in editToolAry) {
            tool.actionDelegate = nil;
        }
        
        [self.editToolDict threadSafe_removeAllObjects];
    } while (NO);
}

#pragma mark - DCImageEditToolActionDelegate
- (void)imageEditTool:(DCImageEditTool *)tool valueChanged:(NSDictionary *)infoDict {
    do {
        if (!tool || !infoDict) {
            break;
        }
        
        NSNumber *rotateNum = [infoDict objectForKey:kImageEditPragma_Rotation];
        if (rotateNum) {
            [self.rotationDescriptionTextField setStringValue:[NSString stringWithFormat:@"%@", rotateNum]];
            [self.currentImg setRotation:[rotateNum floatValue]];
        }
        
        [self refresh];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
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
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                [editTool keyUp:theEvent];
            }
        }
    } while (NO);
}

@end
