//
//  DCImageEditTool.h
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DCImageEditToolType) {
    DCImageEditToolType_None,
    DCImageEditToolType_Rotate,
    DCImageEditToolType_Crop,
    
    DCImageEditToolType_Count,
};

@class DCImageEditTool;
@class DCEditableImage;

@protocol DCImageEditToolActionDelegate <NSObject>

- (void)imageEditTool:(DCImageEditTool *)tool valueChanged:(NSDictionary *)infoDict;
- (void)imageEditToolReseted:(DCImageEditTool *)tool;

@end

@interface DCImageEditTool : NSObject <NSCoding> {
@protected
    CGFloat _anchorRadiusSqrt;
}

@property (assign, nonatomic) id<DCImageEditToolActionDelegate> actionDelegate;
@property (assign, nonatomic) DCImageEditToolType type;
@property (strong, nonatomic, readonly) DCEditableImage *currentImg;
@property (assign, nonatomic, readonly) BOOL actived;
@property (assign, nonatomic, getter = isEdited) BOOL edited;
@property (assign, nonatomic) CGFloat anchorRadius;

+ (NSString *)getImageEditToolGUID:(Class)imageEditToolClass;

- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage;
- (void)resetEditableImage:(DCEditableImage *)editableImage;

- (NSString *)imageEditToolDescription;

- (void)reset;

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

- (void)active;
- (void)deactive;

- (void)imageEditorViewDidResized:(NSNotification *)notification;

- (NSRect)createRectForAnchorByCenterPoint:(NSPoint)center;
- (BOOL)isMouseHitLocation:(NSPoint)loc inAnchor:(NSPoint)anchor;

- (BOOL)handleMouseDown:(NSEvent *)theEvent;
- (BOOL)handleRightMouseDown:(NSEvent *)theEvent;
- (BOOL)handleMouseUp:(NSEvent *)theEvent;
- (BOOL)handleRightMouseUp:(NSEvent *)theEvent;
- (BOOL)handleMouseMoved:(NSEvent *)theEvent;
- (BOOL)handleMouseDragged:(NSEvent *)theEvent;
- (BOOL)handleScrollWheel:(NSEvent *)theEvent;
- (BOOL)handleRightMouseDragged:(NSEvent *)theEvent;
- (BOOL)handleMouseEntered:(NSEvent *)theEvent;
- (BOOL)handleMouseExited:(NSEvent *)theEvent;
- (BOOL)handleKeyDown:(NSEvent *)theEvent;
- (BOOL)handleKeyUp:(NSEvent *)theEvent;

@end
