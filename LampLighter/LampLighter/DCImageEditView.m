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

- (void)fillBackgroundColor;

@end

@implementation DCImageEditView

@synthesize drawDelegate = _drawDelegate;

#pragma mark - Lifecycle
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self fillBackgroundColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        [self fillBackgroundColor];
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

- (void)fillBackgroundColor {
    CGColorRef color = NULL;
    do {
        color = CGColorCreateGenericRGB(0.75, 0.75, 0.75, 1);
        [self setWantsLayer:YES];
        [self.layer setBackgroundColor:color];
    } while (NO);
    if (color) {
        CGColorRelease(color);
        color = NULL;
    }
}

@end
