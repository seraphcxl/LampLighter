//
//  DCPhotoEditView.m
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCPhotoEditView.h"

@interface DCPhotoEditView () {
}

@end

@implementation DCPhotoEditView

@synthesize drawDelegate = _drawDelegate;
#pragma mark - Lifecycle
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    if (self.drawDelegate && [self.drawDelegate respondsToSelector:@selector(photoEditView:drawWithContext:inRect:)]) {
        [self.drawDelegate photoEditView:self drawWithContext:ctx inRect:NSRectToCGRect(self.bounds)];
    }
}

@end
