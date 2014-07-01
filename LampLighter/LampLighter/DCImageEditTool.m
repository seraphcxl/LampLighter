//
//  DCImageEditTool.m
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditTool.h"

@interface DCImageEditTool () {
}

@property (strong, nonatomic) DCEditableImage *currentImg;

@end

@implementation DCImageEditTool

@synthesize actionDelegate = _actionDelegate;
@synthesize currentImg = _currentImg;
@synthesize visiable = _visiable;
@synthesize edited = _edited;

+ (NSString *)getImageEditToolGUID:(Class)imageEditToolClass {
    NSString *result = nil;
    do {
        if (!imageEditToolClass) {
            break;
        }
        result = [imageEditToolClass description];
    } while (NO);
    return result;
}

#pragma mark - Lifecycle
- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage {
    self = [self init];
    if (self) {
        if (editableImage) {
            self.currentImg = editableImage;
        }
    }
    return self;
}

#pragma mark - Public
- (void)resetEditableImage:(DCEditableImage *)editableImage {
    do {
        if (editableImage) {
            self.currentImg = editableImage;
            [self reset];
        }
    } while (NO);
}

- (NSString *)imageEditToolDescription {
    return [self className];
}

- (void)reset {
    do {
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageEditToolReseted:)]) {
            [self.actionDelegate imageEditToolReseted:self];
        }
    } while (NO);
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        ;
    } while (NO);
}

@end
