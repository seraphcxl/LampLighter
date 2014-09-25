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

typedef BOOL (^DCEditableImageSaveActionBlock)(DCEditableImage *editableImage, NSURL *destURL, NSString *type);

@interface DCImageEditViewController () {
}

@property (strong, nonatomic) DCImageEditScene *currentScene;
@property (strong, nonatomic) DCStack *undoAry;
@property (strong, nonatomic) DCStack *redoAry;
@property (assign, nonatomic) BOOL canDragImage;

//- (BOOL)saveEditableImageAs:(NSURL *)destURL type:(NSString *)type andActionBlock:(DCEditableImageSaveActionBlock)actionBlock;

- (void)getImageInfo;
- (void)imageEditorViewDidResized:(NSNotification *)notification;
- (void)stepZoom:(BOOL)isZoomIn;
- (void)_refresh;
- (void)_center;
- (void)_fitin;
- (void)_actual;

@end

@implementation DCImageEditViewController

@synthesize currentScene = _currentScene;
@synthesize undoAry = _undoAry;
@synthesize redoAry = _redoAry;
@synthesize canDragImage = _canDragImage;
@synthesize allowDragImage = _allowDragImage;
@synthesize allowZoomImage = _allowZoomImage;

+ (void)clearCacheDir {
    do {
        NSString *cacheDir = [DCImageEditScene getCacheDir];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if ([fileMgr fileExistsAtPath:cacheDir isDirectory:&isDir] && isDir) {
            NSError *err = nil;
            if (![fileMgr removeItemAtPath:cacheDir error:&err] || err) {
                NSLog(@"%@", [err localizedDescription]);
            }
        }
    } while (NO);
}

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.currentScene = nil;
        self.undoAry = [[DCStack alloc] init];
        self.redoAry = [[DCStack alloc] init];
        self.canDragImage = NO;
        self.allowDragImage = NO;
        self.allowZoomImage = NO;
    }
    return self;
}

- (void)dealloc {
    do {
//        [self saveImageAs:nil];
        self.savingDelegate = nil;
        [self.redoAry resetStack];
        self.redoAry = nil;
        [self.undoAry resetStack];
        self.undoAry = nil;
        self.currentScene = nil;
    } while (NO);
}

- (void)loadView {
    do {
        [super loadView];
        
        if ([self.view isKindOfClass:[DCImageEditView class]]) {
            DCImageEditView *imageEditView = (DCImageEditView *)self.view;
            imageEditView.drawDelegate = self;
        }
        [self showHideInfo:NO];
    } while (NO);
}

- (void)viewCtrlWillAppear {
    do {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageEditorViewDidResized:) name:NSViewFrameDidChangeNotification object:nil];
    } while (NO);
}

- (void)viewCtrlWillDisappear {
    do {
        self.savingDelegate = nil;
        self.currentScene.delegate = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } while (NO);
}

#pragma mark - Public
- (void)reloadCurrentImage:(NSURL *)imageURL {
    do {
        if (!imageURL || ![self.view isKindOfClass:[DCImageEditView class]]) {
            break;
        }
        
        if (self.currentScene) {
//            [self saveImageAs:nil];
            [self.undoAry resetStack];
            [self.redoAry resetStack];
            self.currentScene = nil;
        }
        
        [DCImageEditViewController clearCacheDir];
        
        NSString *uuid = [NSObject createUniqueStrByUUID];
        self.currentScene = [[DCImageEditScene alloc] initWithUUID:uuid imageURL:imageURL];
        self.currentScene.delegate = self;
        
        NSString *urlStr = [imageURL absoluteString];
        if (urlStr) {
            [self.imageURLTextField setStringValue:urlStr];
        }
        
        self.allowDragImage = YES;
        self.allowZoomImage = YES;
    } while (NO);
    [self refresh];
}

- (void)refresh {
    do {
        if (!self.allowZoomImage) {
            [self _fitin];
        }
        if (!self.allowDragImage) {
            [self _center];
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

- (void)center {
    do {
        if (!self.allowDragImage) {
            break;
        }
        [self _center];
    } while (NO);
}

- (void)fitin {
    do {
        if (!self.allowZoomImage) {
            break;
        }
        [self _fitin];
    } while (NO);
}

- (void)actual {
    do {
        if (!self.allowZoomImage) {
            break;
        }
        [self _actual];
    } while (NO);
}

- (BOOL)saveImageAs:(NSURL *)destURL {
    BOOL result = NO;
    do {
        if (!destURL) {
            break;
        }
        
        BOOL allowSaving = YES;
        if (self.savingDelegate && [self.savingDelegate respondsToSelector:@selector(allowImageEditViewController:saveImage:toURL:withUTI:)]) {
            allowSaving = [self.savingDelegate allowImageEditViewController:self saveImage:self.currentScene.editableImage toURL:destURL withUTI:self.currentScene.editableImage.uti];
        }
        
        if (allowSaving) {
            if (self.savingDelegate && [self.savingDelegate respondsToSelector:@selector(imageEditViewController:willSaveImage:toURL:withUTI:)]) {
                [self.savingDelegate imageEditViewController:self willSaveImage:self.currentScene.editableImage toURL:destURL withUTI:self.currentScene.editableImage .uti];
            }
            
            if (![self.currentScene saveImageAs:destURL]) {
                break;
            }
        }
        
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)resetCurrentScene {
    BOOL result = NO;
    do {
        if (!self.currentScene) {
            break;
        }
        result = [self.currentScene reset];
        
        self.allowDragImage = YES;
        self.allowZoomImage = YES;
    } while (NO);
    return result;
}

- (BOOL)applyEditionForCurrentScene {
    BOOL result = NO;
    do {
        if (!self.currentScene) {
            break;
        }
        if (![self.currentScene needCache]) {
            break;
        }
        [self.undoAry pushObject:self.currentScene.uuid];
        
        NSString *uuid = [NSObject createUniqueStrByUUID];
        NSURL *newFileURL = [self.currentScene cacheWithNewUUID:uuid];
        self.currentScene = [[DCImageEditScene alloc] initWithUUID:uuid imageURL:newFileURL];
        self.currentScene.delegate = self;
        self.allowDragImage = YES;
        self.allowZoomImage = YES;
        
        NSString *urlStr = [newFileURL absoluteString];
        if (urlStr) {
            [self.imageURLTextField setStringValue:urlStr];
        }
        result = YES;
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

- (void)undo {
    do {
        if (self.undoAry.count == 0) {
            break;
        }
        if ([self.currentScene needCache]) {
//            [self.currentScene cacheWithNewUUID:[NSObject createUniqueStrByUUID]];
            [self.redoAry pushObject:self.currentScene.uuid];
        }
        NSString *uuid = (NSString *)[self.undoAry popObject];
        NSString *path = [[DCImageEditScene getCacheDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.%@", uuid, uuid, [[self.currentScene.imageURL relativePath] pathExtension]]];
        self.currentScene.delegate = nil;
        self.currentScene = [[DCImageEditScene alloc] initWithUUID:uuid imageURL:[NSURL fileURLWithPath:path]];
        self.currentScene.delegate = self;
    } while (NO);
    [self refresh];
}

- (void)redo {
    do {
        if (self.redoAry.count == 0) {
            break;
        }
        if ([self.currentScene needCache]) {
//            [self.currentScene cacheWithNewUUID:[NSObject createUniqueStrByUUID]];
            [self.undoAry pushObject:self.currentScene.uuid];
        }
        NSString *uuid = (NSString *)[self.redoAry popObject];
        NSString *path = [[DCImageEditScene getCacheDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.%@", uuid, uuid, [[self.currentScene.imageURL relativePath] pathExtension]]];
        self.currentScene.delegate = nil;
        self.currentScene = [[DCImageEditScene alloc] initWithUUID:uuid imageURL:[NSURL fileURLWithPath:path]];
        self.currentScene.delegate = self;
    } while (NO);
    [self refresh];
}

#pragma mark - Private
//- (BOOL)saveEditableImageWithAlarm:(BOOL)showDlg as:(NSURL *)destURL type:(NSString *)type andActionBlock:(DCEditableImageSaveActionBlock)actionBlock {
//    BOOL result = NO;
//    do {
//        if (!block) {
//            break;
//        }
//        BOOL isEdited = NO;
//        NSArray *editToolAry = [self.editToolDict threadSafe_allValues];
//        for (DCImageEditTool *tool in editToolAry) {
//            if ([tool isEdited]) {
//                isEdited = YES;
//                break;
//            }
//        }
//        if (isEdited) {
//            BOOL needDeleteCurrentImage = NO;
//            if (!destURL) {
//                destURL = [self.currentImg url];
//                needDeleteCurrentImage = YES;
//            }
//            if (!type) {
//                type = [self.currentImg uti];
//            }
//            
//            BOOL needSave = YES;
//            if (showDlg) {
//                // need ask for save edited image.
//                if (self.savingDelegate && [self.savingDelegate respondsToSelector:@selector(imageEditViewController:canSaveImage:toURL:withUTI:)]) {
//                    needSave = [self.savingDelegate imageEditViewController:self canSaveImage:self.currentImg toURL:destURL withUTI:type];
//                } else {
//                    needSave = NO;
//                }
//            }
//            if (needSave) {
//                if (needDeleteCurrentImage) {
//                    NSError *err = nil;
//                    if (![[NSFileManager defaultManager] removeItemAtURL:[self.currentImg url] error:&err] || err) {
//                        NSLog(@"%@", [err description]);
//                        break;
//                    }
//                }
//                // do save
//                result = block(self.currentImg, destURL, type);
////                [self.currentImg saveAs:destURL type:type];
//            } else {
//                result = YES;
//            }
//        }
//        
//    } while (NO);
//    return result;
//}

- (void)getImageInfo {
    do {
        if (!self.currentScene) {
            break;
        }
        
        DCImageEditTool *tool = self.currentScene.imageEditTool;
        NSString *imageEditToolDescription = @"";
        if (tool) {
            imageEditToolDescription = [tool imageEditToolDescription];
        }
        [self.imageEditToolDescriptionTextField setStringValue:imageEditToolDescription];
        
        [self.zoomDescriptionTextField setStringValue:[NSString stringWithFormat:@"%d%%", DCRoundingFloatToInt(self.currentScene.editableImage.scaleX * 100)]];
        
        [self.rotationDescriptionTextField setStringValue:[NSString stringWithFormat:@"%f", self.currentScene.editableImage.rotation]];
        
        [self.imageEditedSizeTextField setStringValue:[NSString stringWithFormat:@"%d x %d", DCRoundingFloatToInt(self.currentScene.editableImage.editedImageSize.width), DCRoundingFloatToInt(self.currentScene.editableImage.editedImageSize.height)]];

        if ([tool isKindOfClass:[DCImageCropTool class]]) {
            DCImageCropTool *cropTool = (DCImageCropTool *)tool;
            [self.cropDescriptionTextField setStringValue:[NSString stringWithFormat:@"%d x %d", DCRoundingFloatToInt(cropTool.cropRect.size.width / self.currentScene.editableImage.scaleX), DCRoundingFloatToInt(cropTool.cropRect.size.height / self.currentScene.editableImage.scaleX)]];
        }
    } while (NO);
}

- (void)imageEditorViewDidResized:(NSNotification *)notification {
    do {
        if (!notification || notification.object != self.view) {
            break;
        }
        
        [self.currentScene imageEditorViewDidResized:notification];
        
        [self refresh];
    } while (NO);
}

- (void)stepZoom:(BOOL)isZoomIn {
    do {
        if (!self.allowZoomImage) {
            break;
        }
        CGFloat ratio = [self.currentScene imageScale];
        if (isZoomIn) {
            if (ratio < 1.0f) {
                ratio -= kImageEditor_ZoomStep;
            } else {
                ratio -= kImageEditor_ZoomStep * 2;
            }
        } else {
            if (ratio < 1.0f) {
                ratio += kImageEditor_ZoomStep;
            } else {
                ratio += kImageEditor_ZoomStep * 2;
            }
        }
        if (ratio < kImageEditor_ZoomRatio_Min) {
            ratio = kImageEditor_ZoomRatio_Min;
        }
        if (ratio > kImageEditor_ZoomRatio_Max) {
            ratio = kImageEditor_ZoomRatio_Max;
        }
        [self.currentScene zoom:ratio];
    } while (NO);
}

- (void)_refresh {
    do {
        [self getImageInfo];
        [self.view setNeedsDisplay:YES];
    } while (NO);
}

- (void)_center {
    do {
        if (!self.currentScene) {
            break;
        }
        [self.currentScene moveWithX:0.0f andY:0.0f];
    } while (NO);
}

- (void)_fitin {
    do {
        if (!self.currentScene) {
            break;
        }
        [self.currentScene zoom:[self.currentScene calcFitinRatioSizeInView:self.view]];
    } while (NO);
}

- (void)_actual {
    do {
        if (!self.currentScene) {
            break;
        }
        [self.currentScene zoom:1.0f];
    } while (NO);
}

#pragma mark - DCImageEditViewDrawDelegate
- (void)imageEditView:(DCImageEditView *)view drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!view || !context) {
            break;
        }
        
        [self.currentScene drawWithContext:context inRect:bounds];
    } while (NO);
}

#pragma mark - NSResponder
- (void)mouseDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleMouseDown:theEvent];
        }
        
        if (!handled) {
            // Move
            BOOL canDragImage = NO;
            if (self.allowDragImage) {
                NSPoint loc = theEvent.locationInWindow;
                if (NSPointInRect(loc, self.currentScene.editableImage.visiableRect)) {
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
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleRightMouseDown:theEvent];
        }
    } while (NO);
}

- (void)mouseUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleMouseUp:theEvent];
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
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleRightMouseUp:theEvent];
        }
    } while (NO);
}

- (void)mouseMoved:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleMouseMoved:theEvent];
        }
    } while (NO);
}

- (void)mouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleMouseDragged:theEvent];
        }
        
        if (!handled) {
            // Move
            if (self.canDragImage) {
                CGFloat translateX = self.currentScene.editableImage.translateX + theEvent.deltaX;
                CGFloat translateY = self.currentScene.editableImage.translateY - theEvent.deltaY;
                [self.currentScene moveWithX:translateX andY:translateY];
                [self _refresh];
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
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleScrollWheel:theEvent];
        }
        
        if (!handled && self.allowZoomImage) {
            // Zoom
            //            CGFloat ratio = self.currentImg.scaleX;
            //            if (theEvent.deltaY < 0.0f) {
            //                ratio += 0.01f;
            //            } else if (theEvent.deltaY > 0.0f) {
            //                ratio -= 0.01f;
            //            }
            CGFloat ratio = self.currentScene.imageScale - theEvent.deltaY * kImageEditor_ZoomStep;
            if (ratio < kImageEditor_ZoomRatio_Min) {
                ratio = kImageEditor_ZoomRatio_Min;
            }
            if (ratio > kImageEditor_ZoomRatio_Max) {
                ratio = kImageEditor_ZoomRatio_Max;
            }
            [self.currentScene zoom:ratio];
            [self _refresh];
        }
    } while (NO);
}

- (void)rightMouseDragged:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleRightMouseDragged:theEvent];
        }
    } while (NO);
}

- (void)mouseEntered:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleMouseEntered:theEvent];
        }
    } while (NO);
}

- (void)mouseExited:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleMouseExited:theEvent];
        }
    } while (NO);
}

- (void)keyDown:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleKeyDown:theEvent];
        }
    } while (NO);
}

- (void)keyUp:(NSEvent *)theEvent {
    do {
        if (!theEvent) {
            break;
        }
        
        BOOL handled = NO;
        DCImageEditTool *editTool = self.currentScene.imageEditTool;
        if (editTool) {
            handled = [editTool handleKeyUp:theEvent];
        }
    } while (NO);
}

#pragma mark DCImageEditSceneDelegate
- (void)imageEditScene:(DCImageEditScene *)scene cachedImageToURL:(NSURL *)url {
    do {
        ;
    } while (NO);
}

- (void)imageEditSceneZoomedImage:(DCImageEditScene *)scene {
    do {
//        [self.currentScene.imageEditTool handleZoomImage];
    } while (NO);
}

- (void)imageEditSceneMovedImage:(DCImageEditScene *)scene {
    do {
        ;
    } while (NO);
}

- (void)imageEditScene:(DCImageEditScene *)scene editImageWithValue:(NSDictionary *)infoDict {
    do {
        ;
    } while (NO);
    [self refresh];
}

- (void)imageEditSceneResetEditimage:(DCImageEditScene *)scene {
    do {
        ;
    } while (NO);
    [self refresh];
}

@end
