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

@interface DCAppDelegate () {
}

@property (strong, nonatomic) DCImageEditViewController *imageEditVC;
@property (strong, nonatomic) NSURL *imageURL;

- (void)textFeildDidEndEditing:(NSNotification *)notification;
- (void)createOpenTypesArray;
- (NSArray *)extensionsForUTI:(CFStringRef)uti;
- (void)openImageDidEnd:(NSOpenPanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)saveImageDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)cleanEditTools;

@end

@implementation DCAppDelegate

@synthesize imageEditVC = _imageEditVC;
@synthesize openImageIOSupportedTypes = _openImageIOSupportedTypes;
@synthesize imageURL = _imageURL;

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
        
        [self.imageEditVC addImageEditViewToView:self.imageEditView];
        
        self.cropComboBox.delegate = self;
        
        for (NSInteger i = 0; i < DCImageCropType_Count; ++i) {
            [self.cropComboBox addItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:i]];
        }
        
        [self.cropComboBox selectItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:DCImageCropType_Custom]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFeildDidEndEditing:) name: NSControlTextDidEndEditingNotification object:nil];
        
        [self.imageEditVC showHideInfo:YES];
        
        // Load sample image
        self.imageURL = [[NSBundle mainBundle] URLForImageResource:@"PrettyGirl"];
        DCEditableImage *img = [[DCEditableImage alloc] initWithURL:self.imageURL];
        [self.imageEditVC resetCurrentImage:img];
        
        DCImageRotateTool *rotateTool = [[DCImageRotateTool alloc] initWithEditableImage:img];
        DCImageCropTool *cropTool = [[DCImageCropTool alloc] initWithEditableImage:img];
        
        [self.imageEditVC addEditTool:rotateTool];
        [self.imageEditVC addEditTool:cropTool];
        
        [self.imageEditVC fitin];
        
    } while (NO);

}

- (void)applicationWillTerminate:(NSNotification *)notification {
    do {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        self.cropComboBox.delegate = nil;
        
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
        if (!sender) {
            break;
        }
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
        if (!sender) {
            break;
        }
        
        if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageRotateTool class]]]) {
            // hide
            [self.imageEditVC activeEditToolByClass:nil];
            [self.imageEditVC resetScaleType:DCEditImageScaleType_Zoomable];
            [self.imageEditVC fitin];
        } else {
            // show
            [self.imageEditVC activeEditToolByClass:[DCImageRotateTool class]];
            
            if (self.fitinLockBtn.state) {
                [self.imageEditVC resetScaleType:DCEditImageScaleType_Fitin];
            } else {
                [self.imageEditVC resetScaleType:DCEditImageScaleType_Zoomable];
            }
            
            [self.imageEditVC fitin];
        }
    } while (NO);
}

- (IBAction)showHideCropTool:(id)sender {
    do {
        if (!sender) {
            break;
        }
        
        if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageCropTool class]]]) {
            // hide
            [self.imageEditVC activeEditToolByClass:nil];
            [self.imageEditVC resetScaleType:DCEditImageScaleType_Zoomable];
            [self.imageEditVC fitin];
        } else {
            // show
            [self.imageEditVC activeEditToolByClass:[DCImageCropTool class]];
            [self.imageEditVC resetScaleType:DCEditImageScaleType_Fitin];
        }
    } while (NO);
}

- (IBAction)setRotateSliderValue:(id)sender {
    do {
        if (!sender || sender != self.rotateSlider) {
            break;
        }
        NSLog(@"%@ %@%f", [self className], NSStringFromSelector(_cmd), [self.rotateSlider floatValue]);
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
        [self.imageEditVC refresh];
    } while (NO);
}

- (IBAction)actionActual:(id)sender {
    do {
        if (!sender || sender != self.actualBtn) {
            break;
        }
        [self.imageEditVC actual];
        [self.imageEditVC refresh];
    } while (NO);
}

- (IBAction)actionLockFitin:(id)sender {
    do {
        if (!sender || sender != self.fitinLockBtn) {
            break;
        }
        NSInteger state = self.fitinLockBtn.state;
        if (state) {
            [self.imageEditVC resetScaleType:DCEditImageScaleType_Fitin];
        } else {
            if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageRotateTool class]]]) {
                [self.imageEditVC resetScaleType:DCEditImageScaleType_Zoomable];
            } else if ([self.imageEditVC.activeEditToolGUID isEqualToString:[DCImageEditTool getImageEditToolGUID:[DCImageCropTool class]]]) {
                [self.imageEditVC resetScaleType:DCEditImageScaleType_Fitin];
            }
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
        [self.imageEditVC saveImageAs:[panel URL]];
	}
}

- (void)cleanEditTools {
    do {
        [self.rotateSlider setFloatValue:0.0f];
        [self.degreeTextField setStringValue:@"0"];
        [self.cropComboBox selectItemWithObjectValue:[DCImageCropTool descriptionForImageCropType:DCImageCropType_Custom]];
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
    } while (NO);
}

@end
