//
//  DCPhotoEditView.h
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DCPhotoEditView;

@protocol DCPhotoEditViewDrawDelegate <NSObject>

- (void)photoEditView:(DCPhotoEditView *)view drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

@end

@interface DCPhotoEditView : NSView {
}

@property (assign, nonatomic) id<DCPhotoEditViewDrawDelegate> drawDelegate;

@end
