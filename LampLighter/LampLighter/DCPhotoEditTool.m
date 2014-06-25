//
//  DCPhotoEditTool.m
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCPhotoEditTool.h"

@interface DCPhotoEditTool () {
}

@property (strong, nonatomic) DCEditableImage *currentImg;

@end

@implementation DCPhotoEditTool

@synthesize actionDelegate = _actionDelegate;
@synthesize currentImg = _currentImg;
@synthesize visiable = _visiable;
@synthesize edited = _edited;

#pragma mark - Lifecycle
- (instancetype)initWithEditableImage:(DCEditableImage *)editableImage {
    BOOL goodToGo = NO;
    do {
        if (!editableImage) {
            break;
        }
        goodToGo = YES;
    } while (NO);
    if (!goodToGo) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.currentImg = editableImage;
    }
    return self;
}

#pragma mark - Public
- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        ;
    } while (NO);
}

@end
