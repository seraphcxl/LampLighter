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
#import "DCImageRotateTool.h"

#import "DCEditableImage.h"

const int64_t kDefaultTimeoutLengthInNanoSeconds = 20000000000; // 20 Seconds

@interface DCAppDelegate () {
}

@property (strong, nonatomic) DCImageEditViewController *imageEditVC;
@property (strong, nonatomic) NSURL *imageURL;

- (void)textFeildDidEndEditing:(NSNotification *)notification;
- (void)createOpenTypesArray;
- (NSArray *)extensionsForUTI:(CFStringRef)uti;
//- (void)openImageDidEnd:(NSOpenPanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
//- (void)saveImageDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)cleanEditTools;

- (void)setCropToolEnabled:(BOOL)flag;
- (void)setRotateToolEnabled:(BOOL)flag;
- (void)setApplyAndCancelEnabled:(BOOL)flag;
- (void)setSelectEditToolEnabled:(BOOL)flag;

- (void)resetCurrentImage;

@end

@implementation DCAppDelegate

@synthesize imageEditVC = _imageEditVC;
@synthesize openImageIOSupportedTypes = _openImageIOSupportedTypes;
@synthesize imageURL = _imageURL;

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    do {
        self.imageEditVC = [[DCImageEditViewController alloc] initWithNibName:@"DCImageEditViewController" bundle:nil];
        self.imageEditVC.allowDragImage = YES;
        self.imageEditVC.allowZoomImage = YES;
        self.imageEditVC.savingDelegate = self;
        
        [DCImageEditViewController clearCacheDir];
    } while (NO);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    do {
        // Insert code here to initialize your application
        [self.mainView setWantsLayer:YES];
        CGColorRef color = CGColorCreateGenericRGB(0.34, 0.34, 0.34, 1);
        [self.mainView.layer setBackgroundColor:color];
        CGColorRelease(color);
        color = nil;
        
        [self.imageEditVC viewCtrlWillAppear];
        
        [self.imageEditVC addImageEditViewToView:self.imageEditView];
        
        self.cropComboBox.delegate = self;
        
        for (NSInteger i = 0; i < DCImageCropType_Count; ++i) {
            [self.cropComboBox addItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:i]];
        }
        
        [self.cropComboBox selectItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:DCImageCropType_Custom]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFeildDidEndEditing:) name: NSControlTextDidEndEditingNotification object:nil];
        
        [self.imageEditVC showHideInfo:YES];
        
        // Load sample image
        self.imageURL = [[NSBundle mainBundle] URLForImageResource:@"Beauty"];
        [self.imageEditVC reloadCurrentImage:self.imageURL];
        [self.imageEditVC fitin];
        [self.imageEditVC center];
        [self setRotateToolEnabled:NO];
        [self setCropToolEnabled:NO];
        [self setApplyAndCancelEnabled:NO];
        [self setSelectEditToolEnabled:YES];
        
        [self.imageEditVC refresh];
    } while (NO);
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    do {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        self.cropComboBox.delegate = nil;
        
        [self.imageEditVC viewCtrlWillDisappear];
        [self.imageEditVC.view removeFromSuperview];
        self.imageEditVC = nil;
        
        self.imageURL = nil;
        
        // Clear cache dir
        [DCImageEditViewController clearCacheDir];
    } while (NO);
}

- (void)setCropToolEnabled:(BOOL)flag {
    do {
        [self.cropComboBox setEnabled:flag];
    } while (NO);
}

- (void)setRotateToolEnabled:(BOOL)flag {
    do {
        [self.degreeTextField setEnabled:flag];
        [self.rotateSlider setEnabled:flag];
    } while (NO);
}

- (void)setApplyAndCancelEnabled:(BOOL)flag {
    do {
        [self.applyCropBtn setEnabled:flag];
        [self.cancelCropBtn setEnabled:flag];
    } while (NO);
}

- (void)setSelectEditToolEnabled:(BOOL)flag {
    do {
        [self.rotateBtn setEnabled:flag];
        [self.cropBtn setEnabled:flag];
    } while (NO);
}

- (void)resetCurrentImage {
    do {
        if (!self.imageURL) {
            break;
        }
        [self.imageEditVC reloadCurrentImage:self.imageURL];
        [self.imageEditVC fitin];
        [self.imageEditVC center];
    } while (NO);
}

- (IBAction)openImage:(id)sender {
    do {
        if (!sender) {
            break;
        }
        
        NSOpenPanel* panel = [NSOpenPanel openPanel];
        [panel setAllowsMultipleSelection:NO];
        [panel setResolvesAliases:YES];
        [panel setTreatsFilePackagesAsDirectories:YES];
        [panel setMessage:@"Please choose an image file."];
        
        [self createOpenTypesArray];
        
        [panel setDirectoryURL:nil];
        [panel setAllowedFileTypes:self.openImageIOSupportedTypes];
        
//        [panel beginSheetForDirectory:nil file:nil types:self.openImageIOSupportedTypes modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(openImageDidEnd:returnCode:contextInfo:) contextInfo:nil];
        
        [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
            do {
                if (result == NSOKButton) {
                    if ([[panel URLs] count] > 0) {
                        // Save current image
                        
                        // Open new image
                        self.imageURL = [[panel URLs] objectAtIndex:0];
                        [self.imageEditVC reloadCurrentImage:self.imageURL];
                        [self.imageEditVC fitin];
                        [self.imageEditVC center];
                        [self setRotateToolEnabled:NO];
                        [self setCropToolEnabled:NO];
                        [self setApplyAndCancelEnabled:NO];
                        [self setSelectEditToolEnabled:YES];
                        
                        [self cleanEditTools];
                    }
                }
            } while (NO);
        }];
    } while (NO);
}

- (IBAction)saveImage:(id)sender {
    do {
        if (!sender) {
            break;
        }
        
        NSSavePanel * panel = [NSSavePanel savePanel];
        [panel setCanSelectHiddenExtension:YES];
//        [panel setRequiredFileType:@"png"];
        [panel setAllowedFileTypes:@[self.imageEditVC.currentScene.editableImage.uti]];
        [panel setAllowsOtherFileTypes:NO];
        [panel setTreatsFilePackagesAsDirectories:YES];
        [panel setNameFieldStringValue:@"untitled image"];
        
//        [panel beginSheetForDirectory:nil file:@"untitled image" modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(saveImageDidEnd:returnCode:contextInfo:) contextInfo:nil];
        
        [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
            do {
                if (result == NSOKButton) {
                    [self.imageEditVC saveImageAs:[panel URL]];
                }
            } while (NO);
        }];
    } while (NO);
}

- (IBAction)resetCurrentImage:(id)sender {
    do {
        [self resetCurrentImage];
        
        [self setRotateToolEnabled:NO];
        [self setCropToolEnabled:NO];
        [self setApplyAndCancelEnabled:NO];
        [self setSelectEditToolEnabled:YES];
        
        [self cleanEditTools];
    } while (NO);
}

- (IBAction)showHideRotateTool:(id)sender {
    do {
        if (!self.imageEditVC.currentScene.imageEditTool) {
            [self.imageEditVC.currentScene resetEditToolByType:DCImageEditToolType_Rotate];
            
            [self.cropBtn setEnabled:NO];
            [self setCropToolEnabled:NO];
            
            [self setRotateToolEnabled:YES];
            
            [self setApplyAndCancelEnabled:YES];
            
            [self.imageEditVC refresh];
        }
    } while (NO);
}

- (IBAction)showHideCropTool:(id)sender {
    do {
        if (!self.imageEditVC.currentScene.imageEditTool) {            
            [self.imageEditVC.currentScene resetEditToolByType:DCImageEditToolType_Crop];
            [(DCImageCropTool *)self.imageEditVC.currentScene.imageEditTool resetCropType:(DCImageCropType)[self.cropComboBox indexOfSelectedItem]];
            
            [self.rotateBtn setEnabled:NO];
            [self setRotateToolEnabled:YES];
            
            [self setCropToolEnabled:YES];
            
            [self setApplyAndCancelEnabled:YES];
            
//            [self.fitinLockBtn setState:1];
            [self.imageEditVC fitin];
            [self.imageEditVC center];
            [self.imageEditVC refresh];
            
            [self.imageEditVC setAllowDragImage:NO];
        }
    } while (NO);
}

- (IBAction)setRotateSliderValue:(id)sender {
    do {
        if (!sender || sender != self.rotateSlider) {
            break;
        }
        NSLog(@"%@ %@%f", [self className], NSStringFromSelector(_cmd), [self.rotateSlider floatValue]);
        if (self.imageEditVC.currentScene.imageEditTool.type == DCImageEditToolType_Rotate) {
            DCImageRotateTool *rotateTool = (DCImageRotateTool *)self.imageEditVC.currentScene.imageEditTool;
            [rotateTool setRotation:[self.rotateSlider floatValue]];
            
            [self.degreeTextField setStringValue:[NSString stringWithFormat:@"%f", rotateTool.rotation]];
        }
    } while (NO);
}

- (IBAction)actionFitin:(id)sender {
    do {
        if (!sender || sender != self.fitinBtn) {
            break;
        }
        [self.imageEditVC fitin];
    } while (NO);
    [self.imageEditVC refresh];
}

- (IBAction)actionActual:(id)sender {
    do {
        if (!sender || sender != self.actualBtn) {
            break;
        }
        [self.imageEditVC actual];
    } while (NO);
    [self.imageEditVC refresh];
}

- (IBAction)actionLockFitin:(id)sender {
    do {
        if (!sender || sender != self.fitinLockBtn) {
            break;
        }
        if (self.imageEditVC.currentScene.imageEditTool.type == DCImageEditToolType_Crop) {
            break;
        }
        NSInteger state = self.fitinLockBtn.state;
        self.imageEditVC.allowZoomImage = !state;
    } while (NO);
    [self.imageEditVC refresh];
}

- (IBAction)actionCenter:(id)sender {
    do {
        if (!sender || sender != self.centerBtn) {
            break;
        }
        [self.imageEditVC center];
    } while (NO);
    [self.imageEditVC refresh];
}

- (IBAction)actionStepZoomOut:(id)sender {
    do {
        if (!sender || sender != self.stepZoomOutBtn) {
            break;
        }
        [self.imageEditVC stepZoomOut];
    } while (NO);
    [self.imageEditVC refresh];
}

- (IBAction)actionStepZoomIn:(id)sender {
    do {
        if (!sender || sender != self.stepZoomInBtn) {
            break;
        }
        [self.imageEditVC stepZoomIn];
    } while (NO);
    [self.imageEditVC refresh];
}

- (IBAction)actionForApply:(id)sender {
    do {
//        NSSavePanel * panel = [NSSavePanel savePanel];
//        [panel setCanSelectHiddenExtension:YES];
//        [panel setAllowedFileTypes:@[self.imageEditVC.currentImg.uti]];
//        [panel setAllowsOtherFileTypes:NO];
//        [panel setTreatsFilePackagesAsDirectories:YES];
//        
//        [panel beginSheetForDirectory:nil file:@"cropped image" modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(saveCropImageDidEnd:returnCode:contextInfo:) contextInfo:nil];
        if (![self.imageEditVC applyEditionForCurrentScene]) {
            break;
        }
        [self.imageEditVC fitin];
        [self.imageEditVC center];
        [self.imageEditVC refresh];
        
        [self cleanEditTools];
        
        [self setRotateToolEnabled:NO];
        [self setCropToolEnabled:NO];
        [self setApplyAndCancelEnabled:NO];
        [self setSelectEditToolEnabled:YES];
    } while (NO);
}

- (IBAction)actionForCancel:(id)sender {
    do {
        [self.imageEditVC resetCurrentScene];
        [self.imageEditVC fitin];
        [self.imageEditVC center];
        [self.imageEditVC refresh];
        
        [self setRotateToolEnabled:NO];
        [self setCropToolEnabled:NO];
        [self setApplyAndCancelEnabled:NO];
        [self setSelectEditToolEnabled:YES];
        
        [self cleanEditTools];
    } while (NO);
}

- (IBAction)actionForUndo:(id)sender {
    do {
        [self.imageEditVC undo];
        
        [self.imageEditVC fitin];
        [self.imageEditVC center];
        
        switch (self.imageEditVC.currentScene.imageEditTool.type) {
            case DCImageEditToolType_Rotate:
            {
                [self.cropBtn setEnabled:NO];
                [self setRotateToolEnabled:YES];
                [self setApplyAndCancelEnabled:YES];
            }
                break;
            case DCImageEditToolType_Crop:
            {
                [self.rotateBtn setEnabled:NO];
                [self setCropToolEnabled:YES];
                [self setApplyAndCancelEnabled:YES];
//                [self.fitinLockBtn setState:1];
            }
                break;
            default:
                break;
        }
        
        [self.imageEditVC refresh];
    } while (NO);
}

- (IBAction)actionForRedo:(id)sender {
    do {
        [self.imageEditVC redo];
        
        [self.imageEditVC fitin];
        [self.imageEditVC center];
        
        switch (self.imageEditVC.currentScene.imageEditTool.type) {
            case DCImageEditToolType_Rotate:
            {
                [self.cropBtn setEnabled:NO];
                [self setRotateToolEnabled:YES];
                [self setApplyAndCancelEnabled:YES];
            }
                break;
            case DCImageEditToolType_Crop:
            {
                [self.rotateBtn setEnabled:NO];
                [self setCropToolEnabled:YES];
                [self setApplyAndCancelEnabled:YES];
//                [self.fitinLockBtn setState:1];
            }
                break;
            default:
                break;
        }
        
        [self.imageEditVC refresh];
    } while (NO);
}

#pragma mark - Private
- (void)textFeildDidEndEditing:(NSNotification *)notification {
    do {
        if (!notification) {
            break;
        }
        if (notification.object == self.degreeTextField) {
            if (self.imageEditVC.currentScene.imageEditTool.type == DCImageEditToolType_Rotate) {
                CGFloat rotation = 360.0f - [self.degreeTextField floatValue];
                
                DCImageRotateTool *rotateTool = (DCImageRotateTool *)self.imageEditVC.currentScene.imageEditTool;
                [rotateTool setRotation:rotation];
                
                [self.rotateSlider setFloatValue:rotation];
            }
        }
    } while (NO);
}

- (void)createOpenTypesArray {
    do {
        if (self.openImageIOSupportedTypes == NULL) {
            CFArrayRef imageIOUTIs = CGImageSourceCopyTypeIdentifiers();
            CFIndex i, count = CFArrayGetCount(imageIOUTIs);
            self.openImageIOSupportedTypes = [[NSMutableArray alloc] initWithCapacity:count];
            for (i = 0; i < count; ++i) {
                [self.openImageIOSupportedTypes addObjectsFromArray:[self extensionsForUTI:CFArrayGetValueAtIndex(imageIOUTIs, i)]];
            }
            CFRelease(imageIOUTIs);
        }
    } while (NO);
}

- (NSArray *)extensionsForUTI:(CFStringRef)uti {
	// If anything goes wrong, we'll return nil, otherwise this will be the array of extensions for this image type.
	NSArray * extensions = nil;
	// Only get extensions for UTIs that are images (i.e. conforms to public.image aka kUTTypeImage)
	// This excludes PDF support that ImageIO advertises, but won't actually use.
	if(UTTypeConformsTo(uti, kUTTypeImage))
	{
		// Copy the decleration for the UTI (if it exists)
		CFDictionaryRef decleration = UTTypeCopyDeclaration(uti);
		if(decleration != NULL)
		{
			// Grab the tags for this UTI, which includes extensions, OSTypes and MIME types.
			CFDictionaryRef tags = CFDictionaryGetValue(decleration, kUTTypeTagSpecificationKey);
			if(tags != NULL)
			{
				// We are interested specifically in the extensions that this UTI uses
				CFTypeRef filenameExtensions = CFDictionaryGetValue(tags, kUTTagClassFilenameExtension);
				if(filenameExtensions != NULL)
				{
					// It is valid for a UTI to export either an Array (of Strings) representing multiple tags,
					// or a String representing a single tag.
					CFTypeID type = CFGetTypeID(filenameExtensions);
					if(type == CFStringGetTypeID())
					{
						// If a string was exported, then wrap it up in an array.
						extensions = [NSArray arrayWithObject:(__bridge NSString*)filenameExtensions];
					}
					else if(type == CFArrayGetTypeID())
					{
						// If an array was exported, then just return that array.
						extensions = [(__bridge NSArray*)filenameExtensions copy];
					}
				}
			}
			CFRelease(decleration);
		}
	}
	return extensions;
}

//- (void)openImageDidEnd:(NSOpenPanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
//	if (returnCode == NSOKButton) {
//		if ([[panel URLs] count] > 0) {
//            // Save current image
//            
//            // Open new image
//			self.imageURL = [[panel URLs] objectAtIndex:0];
//            [self.imageEditVC reloadCurrentImage:self.imageURL];
//            [self.imageEditVC fitin];
//            
//            [self setRotateToolEnabled:NO];
//            [self setCropToolEnabled:NO];
//            [self setApplyAndCancelEnabled:NO];
//            [self setSelectEditToolEnabled:YES];
//            
//            [self cleanEditTools];
//		}
//	}
//}

//- (void)saveImageDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
//	if (returnCode == NSOKButton) {
//        [self.imageEditVC saveImageAs:[panel URL]];
//	}
//}

- (void)cleanEditTools {
    do {
        [self.rotateSlider setFloatValue:0.0f];
        [self.degreeTextField setStringValue:@"0"];
        [self.cropComboBox selectItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:DCImageCropType_Custom]];
        [self.fitinLockBtn setState:0];
    } while (NO);
}

#pragma mark - NSComboBoxDelegate
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    do {
        if (!notification) {
            break;
        }
        if (notification.object != self.cropComboBox) {
            break;
        }
        NSLog(@"%@ %@ %ld %@", [self className], NSStringFromSelector(_cmd), (long)[self.cropComboBox indexOfSelectedItem], [self.cropComboBox objectValueOfSelectedItem]);
        
        if (self.imageEditVC.currentScene.imageEditTool.type == DCImageEditToolType_Crop) {
            DCImageCropTool *cropTool = (DCImageCropTool *)self.imageEditVC.currentScene.imageEditTool;
            [cropTool resetCropType:(DCImageCropType)[self.cropComboBox indexOfSelectedItem]];
            
            [self.imageEditVC refresh];
        }
    } while (NO);
}

#pragma mark - DCImageEditVCSavingDelegate
- (BOOL)allowImageEditViewController:(DCImageEditViewController *)imageEditVC saveImage:(DCEditableImage *)editableImage toURL:(NSURL *)saveURL withUTI:(NSString *)uti {
    BOOL result = NO;
    do {
        result = YES;
    } while (NO);
    return result;
}

- (void)imageEditViewController:(DCImageEditViewController *)imageEditVC willSaveImage:(DCEditableImage *)editableImage toURL:(NSURL *)saveURL withUTI:(NSString *)uti {
    do {
        ;
    } while (NO);
}

@end
