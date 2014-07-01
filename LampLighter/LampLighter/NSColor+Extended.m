//
//  NSColor+Extended.m
//  CocoaHelper
//
//  Created by Michael Reneer on 6/2/14.
//  Copyright (c) 2012 Michael Reneer. All rights reserved.
//

#import "NSColor+Extended.h"

@implementation NSColor (Extended)

#pragma mark - Creation Methods

+ (NSColor *)aluminumColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 153.0f / 255.0f;
        CGFloat green = 153.0f / 255.0f;
        CGFloat red = 153.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)aquaColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 128.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)asparagusColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 128.0f / 255.0f;
        CGFloat red = 128.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)bananaColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 102.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)blueberryColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)bubblegumColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 102.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)cantaloupeColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 102.0f / 255.0f;
        CGFloat green = 204.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)carnationColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 207.0f / 255.0f;
        CGFloat green = 111.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)cayenneColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 128.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)cloverColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 128.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)eggplantColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 128.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 64.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)fernColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 128.0f / 255.0f;
        CGFloat red = 64.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)floraColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 102.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 102.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)grapeColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 128.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)honeydewColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 102.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 204.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)iceColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 102.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)ironColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 76.0f / 255.0f;
        CGFloat green = 76.0f / 255.0f;
        CGFloat red = 76.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)lavenderColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 102.0f / 255.0f;
        CGFloat red = 204.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)leadColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 25.0f / 255.0f;
        CGFloat green = 25.0f / 255.0f;
        CGFloat red = 25.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)lemonColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)licoriceColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)limeColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 128.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)magnesiumColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 179.0f / 255.0f;
        CGFloat green = 179.0f / 255.0f;
        CGFloat red = 179.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)maraschinoColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)maroonColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 64.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 128.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)midnightColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 128.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)mochaColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 64.0f / 255.0f;
        CGFloat red = 128.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)mossColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 64.0f / 255.0f;
        CGFloat green = 128.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)murcuryColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 230.0f / 255.0f;
        CGFloat green = 230.0f / 255.0f;
        CGFloat red = 230.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)nickelColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 128.0f / 255.0f;
        CGFloat green = 128.0f / 255.0f;
        CGFloat red = 128.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)oceanColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 128.0f / 255.0f;
        CGFloat green = 64.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)orchidColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 102.0f / 255.0f;
        CGFloat red = 102.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)plumColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 128.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 128.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)salmonColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 102.0f / 255.0f;
        CGFloat green = 102.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)seaFoamColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 128.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)silverColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 204.0f / 255.0f;
        CGFloat green = 204.0f / 255.0f;
        CGFloat red = 204.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)skyColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 204.0f / 255.0f;
        CGFloat red = 102.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)snowColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)spindriftColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 204.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 102.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)springColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)steelColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 102.0f / 255.0f;
        CGFloat green = 102.0f / 255.0f;
        CGFloat red = 102.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)strawberryColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 105.0f / 255.0f;
        CGFloat green = 0.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)tangerineColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 0.0f / 255.0f;
        CGFloat green = 128.0f / 255.0f;
        CGFloat red = 255.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)tealColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 128.0f / 255.0f;
        CGFloat green = 128.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)tinColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 127.0f / 255.0f;
        CGFloat green = 127.0f / 255.0f;
        CGFloat red = 127.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)tungstenColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 51.0f / 255.0f;
        CGFloat green = 51.0f / 255.0f;
        CGFloat red = 51.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

+ (NSColor *)turquoiseColor {
    static NSColor *color = nil;
    
    dispatch_block_t block = ^(void) {
        CGFloat alpha = 1.0f;
        CGFloat blue = 255.0f / 255.0f;
        CGFloat green = 255.0f / 255.0f;
        CGFloat red = 0.0f / 255.0f;
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
    };
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, block);
    
    return color;
}

@end
