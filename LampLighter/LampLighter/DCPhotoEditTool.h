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
- (void)photoEditToolReset:(DCPhotoEditTool *)tool;

@end

@interface DCPhotoEditTool : NSResponder {
}

@property (assign, nonatomic) id<DCPhotoEditToolActionDelegate> actionDelegate;
@property (strong, nonatomic, readonly) DCEditableImage *currentImg;

- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage;

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

@end
