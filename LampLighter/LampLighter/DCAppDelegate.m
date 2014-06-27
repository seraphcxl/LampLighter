//
//  DCAppDelegate.m
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCAppDelegate.h"
#import "DCImageEditViewController.h"

#import "DCImageCropTool.h"

@interface DCAppDelegate () {
}

@property (strong, nonatomic) DCImageEditViewController *imageEditVC;

- (void)textFeildDidEndEditing:(NSNotification *)notification;

@end

@implementation DCAppDelegate

@synthesize imageEditVC = _imageEditVC;

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    do {
        self.imageEditVC = [[DCImageEditViewController alloc] initWithNibName:@"DCImageEditViewController" bundle:nil];
    } while (NO);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    do {
        // Insert code here to initialize your application
        [self.mainView setWantsLayer:YES];
        CGColorRef color = CGColorCreateGenericRGB(0.5, 0.5, 1, 1);
        [self.mainView.layer setBackgroundColor:color];
        CGColorRelease(color);
        
        self.imageEditVC.view.frame = self.imageEditView.bounds;
        [self.imageEditView addSubview:self.imageEditVC.view];
        
        for (NSInteger i = 0; i < DCImageCropType_Count; ++i) {
            [self.cropComboBox addItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:i]];
        }
        
        [self.cropComboBox selectItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:DCImageCropType_Custom]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFeildDidEndEditing:) name: NSControlTextDidEndEditingNotification object:nil];
        
    } while (NO);

}

- (void)applicationWillTerminate:(NSNotification *)notification {
    do {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } while (NO);
}

- (IBAction)openImage:(id)sender {
    do {
        if (!sender) {
            break;
        }
    } while (NO);
}

- (IBAction)saveImage:(id)sender {
    do {
        if (!sender) {
            break;
        }
    } while (NO);
}

- (IBAction)resetCurrentImage:(id)sender {
    do {
        if (!sender) {
            break;
        }
    } while (NO);
}

- (IBAction)showHideRotateTool:(id)sender {
    do {
        if (!sender) {
            break;
        }
    } while (NO);
}

- (IBAction)showHideCropTool:(id)sender {
    do {
        if (!sender) {
            break;
        }
    } while (NO);
}

- (void)textFeildDidEndEditing:(NSNotification *)notification {
    do {
        if (!notification) {
            break;
        }
    } while (NO);
}

@end
