//
//  DCImageEditScene.h
//  LampLighter
//
//  Created by Derek Chen on 7/8/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCImageEditTool.h"

extern const CGFloat kImageEditor_ZoomRatio_Max;
extern const CGFloat kImageEditor_ZoomRatio_Min;

extern const CGFloat kImageEditor_ZoomStep;

extern NSString *kDCImageEditSceneCodingEditTool;

@class DCEditableImage;
@class DCImageEditScene;

@protocol DCImageEditSceneDelegate <NSObject>

- (void)imageEditScene:(DCImageEditScene *)scene cachedImageToURL:(NSURL *)url;
- (void)imageEditSceneZoomedImage:(DCImageEditScene *)scene;
- (void)imageEditSceneMovedImage:(DCImageEditScene *)scene;
- (void)imageEditScene:(DCImageEditScene *)scene editImageWithValue:(NSDictionary *)infoDict;
- (void)imageEditSceneResetEditimage:(DCImageEditScene *)scene;

@end

@interface DCImageEditScene : NSObject <DCImageEditToolActionDelegate> {
}

@property (weak, nonatomic) id<DCImageEditSceneDelegate> delegate;
@property (copy, nonatomic, readonly) NSString *uuid;
@property (copy, nonatomic, readonly) NSURL *imageURL;
@property (strong, nonatomic, readonly) DCEditableImage *editableImage;
@property (strong, nonatomic, readonly) DCImageEditTool *imageEditTool;

+ (NSString *)getCacheDir;
+ (NSURL *)cacheImage:(NSURL *)sourceURL withUUID:(NSString *)uuid;

- (instancetype)initWithUUID:(NSString *)uuid imageURL:(NSURL *)imageURL;
- (BOOL)resetEditToolByType:(DCImageEditToolType)type;
- (BOOL)needCache;
- (NSURL *)cacheWithNewUUID:(NSString *)newUUID;

- (NSSize)calcFitinSizeInView:(NSView *)view;
- (CGFloat)calcFitinRatioSizeInView:(NSView *)view;
- (CGFloat)imageScale;
- (void)zoom:(CGFloat)ratio;

- (void)moveWithX:(CGFloat)x andY:(CGFloat)y;

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

- (void)imageEditorViewDidResized:(NSNotification *)notification;

@end