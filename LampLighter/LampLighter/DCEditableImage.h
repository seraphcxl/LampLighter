//
//  DCEditableImage.h
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCEditableImage : NSObject {
}

@property (strong, nonatomic, readonly) NSURL *url;
@property (strong, nonatomic, readonly) NSString *uti;

@property (assign, nonatomic, readonly) CGFloat rotation;

@property (assign, nonatomic, readonly) CGFloat scaleX;
@property (assign, nonatomic, readonly) CGFloat scaleY;

@property (assign, nonatomic, readonly) CGFloat translateX;
@property (assign, nonatomic, readonly) CGFloat translateY;

@property (assign, nonatomic, readonly) CGSize originImageSize;
@property (assign, nonatomic, readonly) CGSize editedImageSize;

- (instancetype)initWithURL:(NSURL *)sourceUrl;

- (void)setRotation:(CGFloat)rotation;
- (void)setScaleX:(CGFloat)scaleX Y:(CGFloat)scaleY;
- (void)setTranslateX:(CGFloat)translateX Y:(CGFloat)translateY;

- (BOOL)saveAs:(NSURL *)destURL type:(NSString *)type;

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

@end
