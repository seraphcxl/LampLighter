//
//  DCImageEditView.m
//  LampLighter
//
//  Created by Derek Chen on 6/25/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditView.h"

@interface DCImageEditView () {
}

@end

@implementation DCImageEditView

@synthesize drawDelegate = _drawDelegate;

#pragma mark - Lifecycle
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setWantsLayer:YES];
        CGColorRef color = CGColorCreateGenericRGB(0.5, 1, 1, 1);
        [self.layer setBackgroundColor:color];
        CGColorRelease(color);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        [self setWantsLayer:YES];
        CGColorRef color = CGColorCreateGenericRGB(0.5, 1, 1, 1);
        [self.layer setBackgroundColor:color];
        CGColorRelease(color);
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    if (self.drawDelegate && [self.drawDelegate respondsToSelector:@selector(imageEditView:drawWithContext:inRect:)]) {
        [self.drawDelegate imageEditView:self drawWithContext:ctx inRect:NSRectToCGRect(self.bounds)];
    }
}

@end
