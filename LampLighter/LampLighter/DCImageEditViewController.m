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

#import <QuartzCore/QuartzCore.h>

const CGFloat kImageEditor_ZoomRatio_Max = 5.0f;
const CGFloat kImageEditor_ZoomRatio_Min = 0.02f;

const CGFloat kImageEditor_ZoomStep = 0.25f;

@interface DCImageEditViewController () {
}

@property (strong, nonatomic) NSString *activeEditToolGUID;
@property (strong, nonatomic) NSMutableDictionary *editToolDict;
@property (assign, nonatomic) DCEditImageActionType actionType;
@property (strong, nonatomic) DCEditableImage *currentImg;
@property (assign, nonatomic) BOOL canDragImage;

- (BOOL)saveEditableImageWithAlarm:(BOOL)showDlg as:(NSURL *)destURL type:(NSString *)type;
- (void)cleanEditTools;
- (void)getImageInfo;
- (void)imageEditorViewDidResized:(NSNotification *)notification;
- (void)stepZoom:(BOOL)isZoomIn;
- (void)_refresh;

@end

@implementation DCImageEditViewController

@synthesize savingDelegate = _savingDelegate;
@synthesize activeEditToolGUID = _activeEditToolGUID;
@synthesize editToolDict = _editToolDict;
@synthesize actionType = _actionType;
@synthesize currentImg = _currentImg;
@synthesize canDragImage = _canDragImage;
@synthesize allowDragImage = _allowDragImage;
@synthesize allowZoomImage = _allowZoomImage;

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.actionType = DCEditImageActionType_Fitin;
        self.editToolDict = [[NSMutableDictionary dictionary] threadSafe_init];
        self.currentImg = nil;
        self.actionType = DCEditImageActionType_Freestyle;
        self.canDragImage = NO;
        self.allowDragImage = NO;
        self.allowZoomImage = NO;
    }
    return self;
}

- (void)dealloc {
    do {
        [self saveEditableImageWithAlarm:NO as:nil type:nil];
        self.savingDelegate = nil;
        [self cleanEditTools];
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
        [self.imageEditedSizeTextField setHidden:YES];
        [self.imageURLTextField setHidden:YES];
    } while (NO);
}

- (void)viewCtrlWillAppear {
    do {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageEditorViewDidResized:) name:NSViewFrameDidChangeNotification object:nil];
    } while (NO);
}

- (void)viewCtrlWillDisappear {
    do {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } while (NO);
}

#pragma mark - Public
- (void)resetCurrentImage:(DCEditableImage *)editableImage {
    do {
        if (!editableImage) {
            break;
        }
        
        [self saveEditableImageWithAlarm:YES as:nil type:nil];
        
        [self cleanEditTools];
        
        self.currentImg = editableImage;
        
        NSString *urlStr = [[self.currentImg url] absoluteString];
        if (urlStr) {
            [self.imageURLTextField setStringValue:urlStr];
        }
    } while (NO);
    [self refresh];
}

- (void)resetScaleType:(DCEditImageActionType)actionType {
    do {
        if (self.actionType == actionType) {
            break;
        }
        switch (actionType) {
            case DCEditImageActionType_Fitin:
            {
                [self fitin];
            }
                break;
            case DCEditImageActionType_Freestyle:
            {
//                [self actual];
            }
                break;
            default:
                break;
        }
        self.actionType = actionType;
    } while (NO);
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
            [imageEditTool deactive];
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
                    [tool deactive];
                }
                
                tool = [self.editToolDict threadSafe_objectForKey:guid];
                if (tool) {
                    [tool active];
                }
                self.activeEditToolGUID = guid;
            }
        } else {
            DCImageEditTool *tool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (tool) {
                [tool deactive];
            }
            self.activeEditToolGUID = nil;
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
        if (self.actionType == DCEditImageActionType_Fitin) {
            [self fitin];
        }
        [self _refresh];
    } while (NO);
}

- (void)showHideInfo:(BOOL)show {
    do {
        [self.imageEditToolDescriptionTextField setHidden:!show];
        [self.zoomDescriptionTextField setHidden:!show];
        [self.rotationDescriptionTextField setHidden:!show];
        [self.cropDescriptionTextField setHidden:!show];
        [self.imageEditedSizeTextField setHidden:!show];
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

- (NSSize)fitinSize {
    NSSize result = NSMakeSize(0.0f, 0.0f);
    do {
        if (!self.currentImg || !self.view) {
            break;
        }
        result = [DCImageUtility fitSize:self.currentImg.editedImageSize inSize:self.view.bounds.size];
    } while (NO);
    return result;
}

- (void)fitin {
    do {
        if (!self.currentImg || !self.view) {
            break;
        }
        NSSize fitinSize = [self fitinSize];
        CGFloat ratio = fitinSize.width / self.currentImg.editedImageSize.width;
        if (ratio < kImageEditor_ZoomRatio_Min) {
            ratio = kImageEditor_ZoomRatio_Min;
        }
        if (ratio > kImageEditor_ZoomRatio_Max) {
            ratio = kImageEditor_ZoomRatio_Max;
        }
        [self.currentImg setScaleX:ratio Y:ratio];
        [self.currentImg setTranslateX:0.0f Y:0.0f];
        [self _refresh];
    } while (NO);
}

- (void)actual {
    do {
        if (!self.currentImg) {
            break;
        }
        [self.currentImg setScaleX:1.0f Y:1.0f];
        [self.currentImg setTranslateX:0.0f Y:0.0f];
        [self _refresh];
    } while (NO);
}

- (BOOL)saveImageAs:(NSURL *)destURL {
    BOOL result = NO;
    do {
        if (!destURL) {
            break;
        }
        result = [self saveEditableImageWithAlarm:NO as:destURL type:nil];
    } while (NO);
    return result;
}

- (void)stepZoomIn {
    do {
        [self stepZoom:YES];
    } while (NO);
}

- (void)stepZoomOut {
    do {
        [self stepZoom:NO];
    } while (NO);
}

#pragma mark - Private
- (BOOL)saveEditableImageWithAlarm:(BOOL)showDlg as:(NSURL *)destURL type:(NSString *)type {
    BOOL result = NO;
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
            if (!destURL) {
                destURL = [self.currentImg url];
            }
            if (!type) {
                type = [self.currentImg uti];
            }
            
            BOOL needSave = YES;
            if (showDlg) {
                // need ask for save edited image.
                if (self.savingDelegate && [self.savingDelegate respondsToSelector:@selector(imageEditViewController:canSaveImage:toURL:withUTI:)]) {
                    needSave = [self.savingDelegate imageEditViewController:self canSaveImage:self.currentImg toURL:destURL withUTI:type];
                } else {
                    needSave = NO;
                }
            }
            if (needSave) {
                // do save
                [self.currentImg saveAs:destURL type:type];
            }
        }
        result = YES;
    } while (NO);
    return result;
}

- (void)cleanEditTools {
    do {
        self.activeEditToolGUID = nil;
        
        NSArray *editToolAry = [self.editToolDict threadSafe_allValues];
        for (DCImageEditTool *tool in editToolAry) {
            tool.actionDelegate = nil;
        }
        
        [self.editToolDict threadSafe_removeAllObjects];
    } while (NO);
}

- (void)getImageInfo {
    do {
        if (!self.currentImg) {
            break;
        }
        
        DCImageEditTool *tool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
        NSString *imageEditToolDescription = @"";
        if (tool) {
            imageEditToolDescription = [tool imageEditToolDescription];
        }
        [self.imageEditToolDescriptionTextField setStringValue:imageEditToolDescription];
        
        [self.zoomDescriptionTextField setStringValue:[NSString stringWithFormat:@"%d%%", (int)(self.currentImg.scaleX * 100 + 0.5)]];
        
        [self.rotationDescriptionTextField setStringValue:[NSString stringWithFormat:@"%f", self.currentImg.rotation]];
        
        [self.imageEditedSizeTextField setStringValue:[NSString stringWithFormat:@"%d x %d", (int)(self.currentImg.editedImageSize.width + 0.5), (int)(self.currentImg.editedImageSize.height + 0.5)]];

//        [self.cropDescriptionTextField setHidden:!show];
    } while (NO);
}

- (void)imageEditorViewDidResized:(NSNotification *)notification {
    do {
        if (!notification || notification.object != self.view) {
            break;
        }
        
        [[self activeEditTool] imageEditorViewDidResized:notification];
        
        [self refresh];
    } while (NO);
}

- (void)stepZoom:(BOOL)isZoomIn {
    do {
        if (self.actionType == DCEditImageActionType_Freestyle && self.allowZoomImage) {
            CGFloat ratio = self.currentImg.scaleX;
            if (isZoomIn) {
                ratio -= kImageEditor_ZoomStep;
            } else {
                ratio += kImageEditor_ZoomStep;
            }
            if (ratio < kImageEditor_ZoomRatio_Min) {
                ratio = kImageEditor_ZoomRatio_Min;
            }
            if (ratio > kImageEditor_ZoomRatio_Max) {
                ratio = kImageEditor_ZoomRatio_Max;
            }
            [self.currentImg setScaleX:ratio Y:ratio];
            [self _refresh];
        }
    } while (NO);
}

- (void)_refresh {
    do {
        [self getImageInfo];
        [self.view setNeedsDisplay:YES];
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
            if (editTool && editTool.actived) {
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
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleMouseDown:theEvent];
            }
        }
        
        if (!handled) {
            // Move
            BOOL canDragImage = NO;
            if (self.actionType == DCEditImageActionType_Freestyle && self.allowDragImage) {
                NSPoint loc = theEvent.locationInWindow;
                if (NSPointInRect(loc, self.currentImg.visiableRect)) {
                    canDragImage = YES;
                }
            }
            self.canDragImage = canDragImage;
        }
        
        
    } while (NO);
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleRightMouseDown:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleMouseUp:theEvent];
            }
        }
        
        // Move
        self.canDragImage = NO;
    } while (NO);
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleRightMouseUp:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseMoved:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleMouseMoved:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleMouseDragged:theEvent];
            }
        }
        
        if (!handled) {
            // Move
            if (self.actionType == DCEditImageActionType_Freestyle) {
                if (self.canDragImage) {
                    CGFloat translateX = self.currentImg.translateX + theEvent.deltaX;
                    CGFloat translateY = self.currentImg.translateY - theEvent.deltaY;
                    [self.currentImg setTranslateX:translateX Y:translateY];
                    [self _refresh];
                }
            }
        }
    } while (NO);
}

- (void)scrollWheel:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleScrollWheel:theEvent];
            }
        }
        
        if (!handled) {
            // Zoom
            if (self.actionType == DCEditImageActionType_Freestyle && self.allowZoomImage) {
                //            CGFloat ratio = self.currentImg.scaleX;
                //            if (theEvent.deltaY < 0.0f) {
                //                ratio += 0.01f;
                //            } else if (theEvent.deltaY > 0.0f) {
                //                ratio -= 0.01f;
                //            }
                CGFloat ratio = self.currentImg.scaleX - theEvent.deltaY * 0.02f;
                if (ratio < kImageEditor_ZoomRatio_Min) {
                    ratio = kImageEditor_ZoomRatio_Min;
                }
                if (ratio > kImageEditor_ZoomRatio_Max) {
                    ratio = kImageEditor_ZoomRatio_Max;
                }
                [self.currentImg setScaleX:ratio Y:ratio];
                [self _refresh];
            }
        }
    } while (NO);
}

- (void)rightMouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleRightMouseDragged:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseEntered:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleMouseEntered:theEvent];
            }
        }
    } while (NO);
}

- (void)mouseExited:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleMouseExited:theEvent];
            }
        }
    } while (NO);
}

- (void)keyDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleKeyDown:theEvent];
            }
        }
    } while (NO);
}

- (void)keyUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        if (self.activeEditToolGUID) {
            DCImageEditTool *editTool = [self.editToolDict threadSafe_objectForKey:self.activeEditToolGUID];
            if (editTool) {
                handled = [editTool handleKeyUp:theEvent];
            }
        }
    } while (NO);
}

@end
