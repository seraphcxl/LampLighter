//
//  DCImageEditTool.h
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCImageEditTool;
@class DCEditableImage;

@protocol DCImageEditToolActionDelegate <NSObject>

- (void)imageEditTool:(DCImageEditTool *)tool valueChanged:(NSDictionary *)infoDict;
- (void)imageEditToolReseted:(DCImageEditTool *)tool;

@end

@interface DCImageEditTool : NSResponder {
}

@property (assign, nonatomic) id<DCImageEditToolActionDelegate> actionDelegate;
@property (strong, nonatomic, readonly) DCEditableImage *currentImg;
@property (assign, atomic) BOOL visiable;
@property (assign, nonatomic, readonly, getter = isEdited) BOOL edited;

- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage;
- (void)resetEditableImage:(DCEditableImage *)editableImage;

- (void)reset;

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

@end
