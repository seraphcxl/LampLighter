//
//  DCAppDelegate.h
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DCImageEditViewController.h"

@class DCImageCropTool;
@class DCImageRotateTool;

@interface DCAppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSComboBoxDelegate, DCImageEditVCSavingDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *mainView;
@property (weak) IBOutlet NSView *imageEditView;

@property (weak) IBOutlet NSButton *rotateBtn;
@property (weak) IBOutlet NSTextField *degreeTextField;
@property (weak) IBOutlet NSSlider *rotateSlider;

@property (weak) IBOutlet NSButton *cropBtn;
@property (weak) IBOutlet NSComboBox *cropComboBox;
@property (weak) IBOutlet NSButton *fitinBtn;
@property (weak) IBOutlet NSButton *actualBtn;

@property (weak) IBOutlet NSButton *openBtn;
@property (weak) IBOutlet NSButton *saveBtn;
@property (weak) IBOutlet NSButton *resetBtn;
@property (weak) IBOutlet NSButton *fitinLockBtn;
@property (weak) IBOutlet NSButton *stepZoomOutBtn;
@property (weak) IBOutlet NSButton *stepZoomInBtn;
@property (weak) IBOutlet NSButton *applyCropBtn;
@property (weak) IBOutlet NSButton *cancelCropBtn;
@property (weak) IBOutlet NSButton *undoBtn;
@property (weak) IBOutlet NSButton *redoBtn;

@property (strong, nonatomic) NSMutableArray *openImageIOSupportedTypes;

- (IBAction)openImage:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)resetCurrentImage:(id)sender;

- (IBAction)showHideRotateTool:(id)sender;
- (IBAction)showHideCropTool:(id)sender;
- (IBAction)setRotateSliderValue:(id)sender;
- (IBAction)actionFitin:(id)sender;
- (IBAction)actionActual:(id)sender;
- (IBAction)actionLockFitin:(id)sender;
- (IBAction)actionStepZoomOut:(id)sender;
- (IBAction)actionStepZoomIn:(id)sender;
- (IBAction)actionForApply:(id)sender;
- (IBAction)actionForCancel:(id)sender;
- (IBAction)actionForUndo:(id)sender;
- (IBAction)actionForRedo:(id)sender;

@end
