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

#pragma mark - Lifecycle
- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage {
    self = [super init];
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
