//
//  DCImageEditViewController.h
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DCImageEditTool.h"
#import "DCImageEditView.h"
#import "Tourbillon/NSViewController+ViewLogic.h"

typedef NS_ENUM(NSUInteger, DCEditImageActionType) {
    DCEditImageActionType_Fitin,
    DCEditImageActionType_Freestyle,
};

@class DCEditableImage;
@class DCImageEditViewController;

@protocol DCImageEditVCSavingDelegate <NSObject>

- (BOOL)imageEditViewController:(DCImageEditViewController *)imageEditVC canSaveImage:(DCEditableImage *)editableImage toURL:(NSURL *)saveURL withUTI:(NSString *)uti;

@end

@interface DCImageEditViewController : NSViewController <DCImageEditToolActionDelegate, DCImageEditViewDrawDelegate> {
}

@property (weak) IBOutlet NSTextField *imageEditToolDescriptionTextField;
@property (weak) IBOutlet NSTextField *zoomDescriptionTextField;
@property (weak) IBOutlet NSTextField *rotationDescriptionTextField;
@property (weak) IBOutlet NSTextField *cropDescriptionTextField;
@property (weak) IBOutlet NSTextField *imageURLTextField;
@property (weak) IBOutlet NSTextField *imageEditedSizeTextField;

@property (weak, nonatomic) id<DCImageEditVCSavingDelegate> savingDelegate;
@property (strong, nonatomic, readonly) NSString *activeEditToolGUID;
@property (strong, nonatomic, readonly) NSMutableDictionary *editToolDict;
@property (assign, nonatomic, readonly) DCEditImageActionType actionType;
@property (strong, nonatomic, readonly) DCEditableImage *currentImg;
@property (assign, nonatomic) BOOL allowDragImage;
@property (assign, nonatomic) BOOL allowZoomImage;

- (void)resetCurrentImage:(DCEditableImage *)editableImage;

- (void)resetScaleType:(DCEditImageActionType)actionType;

- (BOOL)addEditTool:(DCImageEditTool *)imageEditTool;
- (BOOL)activeEditToolByClass:(Class)imageEditToolClass;
- (DCImageEditTool *)activeEditTool;

- (void)refresh;
- (void)showHideInfo:(BOOL)show;

- (void)addImageEditViewToView:(NSView *)view;

- (NSSize)fitinSize;
- (void)fitin;
- (void)actual;

- (BOOL)saveImageAs:(NSURL *)destURL;

- (void)stepZoomIn;
- (void)stepZoomOut;

@end
