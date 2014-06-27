//
//  DCPhotoEditTool.h
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCPhotoEditTool;
@class DCEditableImage;

@protocol DCPhotoEditToolActionDelegate <NSObject>

- (void)photoEditTool:(DCPhotoEditTool *)tool valueChanged:(NSDictionary *)infoDict;
- (void)photoEditToolReseted:(DCPhotoEditTool *)tool;

@end

@interface DCPhotoEditTool : NSResponder {
}

@property (assign, nonatomic) id<DCPhotoEditToolActionDelegate> actionDelegate;
@property (strong, nonatomic, readonly) DCEditableImage *currentImg;
@property (assign, atomic) BOOL visiable;
@property (assign, nonatomic, readonly, getter = isEdited) BOOL edited;

- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage;

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

@end
