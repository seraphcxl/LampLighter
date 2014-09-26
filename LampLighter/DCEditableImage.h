//
//  DCEditableImage.h
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kDCEditableImageScaleX;
extern NSString *kDCEditableImageScaleY;
extern NSString *kDCEditableImageTranslateX;
extern NSString *kDCEditableImageTranslateY;

@class DCEditableImage;

@protocol DCEditableImageDelegate <NSObject>

- (void)imageVisiableRectChanged:(DCEditableImage *)image;

@end

@interface DCEditableImage : NSObject {
}

@property (weak, nonatomic) id<DCEditableImageDelegate> delegate;

@property (copy, nonatomic, readonly) NSURL *url;
@property (copy, nonatomic, readonly) NSString *uti;

@property (assign, nonatomic, readonly) CGFloat rotation;

@property (assign, nonatomic, readonly) CGFloat scaleX;
@property (assign, nonatomic, readonly) CGFloat scaleY;

@property (assign, nonatomic, readonly) CGFloat translateX;
@property (assign, nonatomic, readonly) CGFloat translateY;

@property (assign, nonatomic, readonly) CGSize originImageSize;
@property (assign, nonatomic, readonly) CGSize editedImageSize;

@property (assign, nonatomic, readonly) CGRect visiableRect;

- (instancetype)initWithURL:(NSURL *)sourceUrl;

- (void)reset;

- (void)setRotation:(CGFloat)rotation;
- (void)setScaleX:(CGFloat)scaleX Y:(CGFloat)scaleY;
- (void)setPreserveAspectRatioScale:(CGFloat)scale;
- (void)setTranslateX:(CGFloat)translateX Y:(CGFloat)translateY;

- (BOOL)saveAs:(NSURL *)destURL type:(NSString *)type;
- (BOOL)saveCrop:(NSRect)cropRect as:(NSURL *)destURL type:(NSString *)type;

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

- (BOOL)loadFromPreviewInfo:(NSDictionary *)dict;
- (NSDictionary *)getPreviewInfo;

@end
