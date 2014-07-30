//
//  DCImageEditViewController.h
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "DCImageEditTool.h"
#import "DCImageEditView.h"
#import "DCImageEditScene.h"

@class DCEditableImage;
@class DCImageEditViewController;

@protocol DCImageEditVCSavingDelegate <NSObject>

- (void)imageEditViewController:(DCImageEditViewController *)imageEditVC willSaveImage:(DCEditableImage *)editableImage toURL:(NSURL *)saveURL withUTI:(NSString *)uti;

@end

@interface DCImageEditViewController : NSViewController <DCImageEditViewDrawDelegate> {
}

@property (weak) IBOutlet NSTextField *imageEditToolDescriptionTextField;
@property (weak) IBOutlet NSTextField *zoomDescriptionTextField;
@property (weak) IBOutlet NSTextField *rotationDescriptionTextField;
@property (weak) IBOutlet NSTextField *cropDescriptionTextField;
@property (weak) IBOutlet NSTextField *imageURLTextField;
@property (weak) IBOutlet NSTextField *imageEditedSizeTextField;

@property (weak, nonatomic) id<DCImageEditVCSavingDelegate> savingDelegate;
@property (strong, nonatomic, readonly) DCImageEditScene *currentScene;
@property (assign, nonatomic) BOOL allowDragImage;
@property (assign, nonatomic) BOOL allowZoomImage;
@property (assign, nonatomic) BOOL fitinLocked;

- (void)reloadCurrentImage:(NSURL *)imageURL;

- (BOOL)saveImageAs:(NSURL *)destURL;
- (BOOL)resetCurrentScene;

- (void)addImageEditViewToView:(NSView *)view;
- (void)refresh;

- (void)showHideInfo:(BOOL)show;

- (void)fitin;
- (void)actual;

- (void)stepZoomIn;
- (void)stepZoomOut;

- (void)undo;
- (void)redo;

@end
