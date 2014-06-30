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

@class DCEditableImage;

typedef NS_ENUM(NSUInteger, DCEditImageScaleType) {
    DCEditImageScaleType_Fitin,
    DCEditImageScaleType_Actual,
    DCEditImageScaleType_Zoom,
};

@interface DCImageEditViewController : NSViewController <DCImageEditToolActionDelegate, DCImageEditViewDrawDelegate> {
}

@property (strong, nonatomic, readonly) NSString *activeEditToolGUID;
@property (strong, nonatomic, readonly) NSMutableDictionary *editToolDict;
@property (assign, nonatomic, readonly) DCEditImageScaleType scaleType;
@property (strong, nonatomic, readonly) DCEditableImage *currentImg;

- (void)resetCurrentImage:(DCEditableImage *)editableImage;

- (void)resetScaleType:(DCEditImageScaleType)scaleType;

- (BOOL)addEditTool:(DCImageEditTool *)imageEditTool;
- (BOOL)activeEditToolByClassName:(NSString *)imageEditToolClassName;

@end