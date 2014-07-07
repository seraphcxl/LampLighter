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
- (void)openImageDidEnd:(NSOpenPanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)saveImageDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)saveCropImageDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)cleanEditTools;

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
    } while (NO);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    do {
        // Insert code here to initialize your application
        [self.mainView setWantsLayer:YES];
        CGColorRef color = CGColorCreateGenericRGB(0.34, 0.34, 0.34, 1);
        [self.mainView.layer setBackgroundColor:color];
        CGColorRelease(color);
        
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
        DCEditableImage *img = [[DCEditableImage alloc] initWithURL:self.imageURL];
        [self.imageEditVC resetCurrentImage:img];
        
        DCImageRotateTool *rotateTool = [[DCImageRotateTool alloc] initWithEditableImage:img];
        DCImageCropTool *cropTool = [[DCImageCropTool alloc] initWithEditableImage:img];
        
        [self.imageEditVC addEditTool:rotateTool];
        [self.imageEditVC addEditTool:cropTool];
        
        [self.imageEditVC fitin];
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
        
        [panel beginSheetForDirectory:nil file:nil types:self.openImageIOSupportedTypes modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(openImageDidEnd:returnCode:contextInfo:) contextInfo:nil];
//        [panel beginSheet:[self window] completionHandler:^(NSModalResponse returnCode) {
//            if (returnCode == NSOKButton) {
//                if ([[panel URLs] count] > 0) {
//                    ;
//                }
//            }
//        }];
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
        [panel setAllowedFileTypes:@[self.imageEditVC.currentImg.uti]];
        [panel setAllowsOtherFileTypes:NO];
        [panel setTreatsFilePackagesAsDirectories:YES];
        
        [panel beginSheetForDirectory:nil file:@"untitled image" modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(saveImageDidEnd:returnCode:contextInfo:) contextInfo:nil];
    } while (NO);
}

- (IBAction)resetCurrentImage:(id)sender {
    do {
        DCEditableImage *img = [[DCEditableImage alloc] initWithURL:self.imageURL];
        [self.imageEditVC resetCurrentImage:img];
        
        DCImageRotateTool *rotateTool = [[DCImageRotateTool alloc] initWithEditableImage:img];
        DCImageCropTool *cropTool = [[DCImageCropTool alloc] initWithEditableImage:img];
        
        [self.imageEditVC addEditTool:rotateTool];
        [self.imageEditVC addEditTool:cropTool];
        
        [self.imageEditVC fitin];
        
        [self cleanEditTools];
    } while (NO);
}

- (IBAction)showHideRotateTool:(id)sender {
    do {
        if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageRotateTool class]]]) {
            // hide
            [self.imageEditVC resetScaleType:DCEditImageActionType_Freestyle];
            [self.imageEditVC activeEditToolByClass:nil];
        } else {
            // show
            if (self.fitinLockBtn.state) {
                [self.imageEditVC resetScaleType:DCEditImageActionType_Fitin];
            } else {
                [self.imageEditVC resetScaleType:DCEditImageActionType_Freestyle];
            }
            [self.imageEditVC activeEditToolByClass:[DCImageRotateTool class]];
        }
    } while (NO);
}

- (IBAction)showHideCropTool:(id)sender {
    do {
        if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageCropTool class]]]) {
            // hide
            [self.fitinLockBtn setState:0];
            [self.imageEditVC resetScaleType:DCEditImageActionType_Freestyle];
            [self.imageEditVC activeEditToolByClass:nil];
        } else {
            // show
            [self.imageEditVC saveEditableImageWithAlarm:YES as:nil type:nil];
            [self resetCurrentImage:nil];
            [self.fitinLockBtn setState:1];
            [self.imageEditVC resetScaleType:DCEditImageActionType_Fitin];
            [self.imageEditVC activeEditToolByClass:[DCImageCropTool class]];
            DCImageEditTool *tool = [self.imageEditVC activeEditTool];
            if ([tool isKindOfClass:[DCImageCropTool class]]) {
                DCImageCropTool *cropTool = (DCImageCropTool *)tool;
                [cropTool resetCropType:(DCImageCropType)[self.cropComboBox indexOfSelectedItem]];
            }
        }
    } while (NO);
}

- (IBAction)setRotateSliderValue:(id)sender {
    do {
        if (!sender || sender != self.rotateSlider) {
            break;
        }
//        NSLog(@"%@ %@%f", [self className], NSStringFromSelector(_cmd), [self.rotateSlider floatValue]);
        if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageRotateTool class]]]) {
            DCImageRotateTool *rotateTool = (DCImageRotateTool *)[self.imageEditVC activeEditTool];
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
        [self.imageEditVC actual];
        [self.imageEditVC fitin];
    } while (NO);
}

- (IBAction)actionActual:(id)sender {
    do {
        if (!sender || sender != self.actualBtn) {
            break;
        }
        [self.imageEditVC actual];
    } while (NO);
}

- (IBAction)actionLockFitin:(id)sender {
    do {
        if (!sender || sender != self.fitinLockBtn) {
            break;
        }
        NSInteger state = self.fitinLockBtn.state;
        if (state) {
            [self.imageEditVC resetScaleType:DCEditImageActionType_Fitin];
        } else {
            if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageRotateTool class]]]) {
                [self.imageEditVC resetScaleType:DCEditImageActionType_Freestyle];
            } else if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageCropTool class]]]) {
                [self.imageEditVC resetScaleType:DCEditImageActionType_Fitin];
            } else {
                [self.imageEditVC resetScaleType:DCEditImageActionType_Freestyle];
            }
        }
        [self.imageEditVC refresh];
    } while (NO);
}

- (IBAction)actionStepZoomOut:(id)sender {
    do {
        if (!sender || sender != self.stepZoomOutBtn) {
            break;
        }
        [self.imageEditVC stepZoomOut];
    } while (NO);
}

- (IBAction)actionStepZoomIn:(id)sender {
    do {
        if (!sender || sender != self.stepZoomInBtn) {
            break;
        }
        [self.imageEditVC stepZoomIn];
    } while (NO);
}

- (IBAction)actionForApplyCrop:(id)sender {
    do {
        NSSavePanel * panel = [NSSavePanel savePanel];
        [panel setCanSelectHiddenExtension:YES];
        [panel setAllowedFileTypes:@[self.imageEditVC.currentImg.uti]];
        [panel setAllowsOtherFileTypes:NO];
        [panel setTreatsFilePackagesAsDirectories:YES];
        
        [panel beginSheetForDirectory:nil file:@"cropped image" modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(saveCropImageDidEnd:returnCode:contextInfo:) contextInfo:nil];
    } while (NO);
}

- (IBAction)actionForCancelCrop:(id)sender {
    do {
        DCEditableImage *img = [[DCEditableImage alloc] initWithURL:self.imageURL];
        [self.imageEditVC resetCurrentImage:img];
        
        DCImageRotateTool *rotateTool = [[DCImageRotateTool alloc] initWithEditableImage:img];
        DCImageCropTool *cropTool = [[DCImageCropTool alloc] initWithEditableImage:img];
        
        [self.imageEditVC addEditTool:rotateTool];
        [self.imageEditVC addEditTool:cropTool];
        
        [self.imageEditVC fitin];
        
        [self.rotateSlider setFloatValue:0.0f];
        [self.degreeTextField setStringValue:@"0"];
//        [self.cropComboBox selectItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:DCImageCropType_Custom]];
        [self.fitinLockBtn setState:0];
        
        [self showHideCropTool:nil];
    } while (NO);
}

#pragma mark - Private
- (void)textFeildDidEndEditing:(NSNotification *)notification {
    do {
        if (!notification) {
            break;
        }
        if (notification.object == self.degreeTextField) {
            if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageRotateTool class]]]) {
                CGFloat rotation = 360.0f - [self.degreeTextField floatValue];
                [self.rotateSlider setFloatValue:rotation];
                DCImageRotateTool *rotateTool = (DCImageRotateTool *)[self.imageEditVC activeEditTool];
                [rotateTool setRotation:rotation];
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

- (void)openImageDidEnd:(NSOpenPanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSOKButton) {
		if ([[panel URLs] count] > 0) {
            DCImageEditTool *tool = [self.imageEditVC activeEditTool];
            if ([tool isKindOfClass:[DCImageCropTool class]]) {
                [self.imageEditVC saveCropEditableImageWithAlarm:YES as:nil type:nil];
            } else {
                [self.imageEditVC saveEditableImageWithAlarm:YES as:nil type:nil];
            }
			self.imageURL = [[panel URLs] objectAtIndex:0];
            DCEditableImage *img = [[DCEditableImage alloc] initWithURL:self.imageURL];
            [self.imageEditVC resetCurrentImage:img];
            
            DCImageRotateTool *rotateTool = [[DCImageRotateTool alloc] initWithEditableImage:img];
            DCImageCropTool *cropTool = [[DCImageCropTool alloc] initWithEditableImage:img];
            
            [self.imageEditVC addEditTool:rotateTool];
            [self.imageEditVC addEditTool:cropTool];
            
            [self.imageEditVC fitin];
            
            [self cleanEditTools];
		}
	}
}

- (void)saveImageDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSOKButton) {
        [self.imageEditVC saveEditableImageWithAlarm:NO as:[panel URL] type:nil];
	}
}

- (void)saveCropImageDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSOKButton) {
        [self.imageEditVC saveCropEditableImageWithAlarm:NO as:[panel URL] type:nil];
	}
}

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
        
        if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageCropTool class]]]) {
            DCImageEditTool *tool = [self.imageEditVC activeEditTool];
            if ([tool isKindOfClass:[DCImageCropTool class]]) {
                DCImageCropTool *cropTool = (DCImageCropTool *)tool;
                [cropTool resetCropType:(DCImageCropType)[self.cropComboBox indexOfSelectedItem]];
                
                [self.imageEditVC refresh];
            }
        }
    } while (NO);
}

#pragma mark - DCImageEditVCSavingDelegate
- (BOOL)imageEditViewController:(DCImageEditViewController *)imageEditVC canSaveImage:(DCEditableImage *)editableImage toURL:(NSURL *)saveURL withUTI:(NSString *)uti {
    NSLog(@"%@ %@ %@%@", [self className], NSStringFromSelector(_cmd), saveURL, uti);
    return NO;
}

@end
