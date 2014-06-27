//
//  DCAppDelegate.h
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DCAppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *mainView;
@property (weak) IBOutlet NSView *imageEditView;

@property (weak) IBOutlet NSButton *rotateBtn;
@property (weak) IBOutlet NSTextField *degreeTextField;
@property (weak) IBOutlet NSSlider *rotateSlider;

@property (weak) IBOutlet NSButton *cropBtn;
@property (weak) IBOutlet NSComboBox *cropComboBox;

@property (weak) IBOutlet NSButton *openBtn;
@property (weak) IBOutlet NSButton *saveBtn;
@property (weak) IBOutlet NSButton *resetBtn;

- (IBAction)openImage:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)resetCurrentImage:(id)sender;

- (IBAction)showHideRotateTool:(id)sender;
- (IBAction)showHideCropTool:(id)sender;

@end
