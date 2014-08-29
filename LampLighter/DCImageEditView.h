//
//  DCImageEditView.h
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DCImageEditView;

@protocol DCImageEditViewDrawDelegate <NSObject>

- (void)imageEditView:(DCImageEditView *)view drawWithContext:(CGContextRef)context inRect:(CGRect)bounds;

@end

@interface DCImageEditView : NSView {
}

@property (assign, nonatomic) id<DCImageEditViewDrawDelegate> drawDelegate;

@end
