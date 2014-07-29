//
//  DCEditableImage.m
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCEditableImage.h"
#import "DCImageRotateTool.h"

@interface DCEditableImage () {
    CGImageRef _image;
    CFDictionaryRef _properties;
}

@property (copy, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString *uti;

@property (assign, nonatomic) CGFloat rotation;

@property (assign, nonatomic) CGFloat scaleX;
@property (assign, nonatomic) CGFloat scaleY;

@property (assign, nonatomic) CGFloat translateX;
@property (assign, nonatomic) CGFloat translateY;

@property (assign, nonatomic) CGSize originImageSize;
@property (assign, nonatomic) CGSize editedImageSize;

@property (assign, nonatomic) CGRect visiableRect;

- (NSInteger)getImageOrientation;
- (void)fixupImageOrientation;

- (void)calcEditedImageSize;
- (void)calcVisiableRectInRect:(CGRect)bounds;
- (void)drawWithContext:(CGContextRef)context forSave:(BOOL)isForSave inRect:(CGRect)bounds allowTranslate:(BOOL)allowTranslate allowScale:(BOOL)allowScale allowCalcVisiableRect:(BOOL)allowCalcVisiableRect;
- (void)drawRawDataWithContext:(CGContextRef)context forSave:(BOOL)isForSave inRect:(CGRect)bounds;
- (void)applyTransformationWithContext:(CGContextRef)context inRect:(CGRect)bounds allowTranslate:(BOOL)allowTranslate allowScale:(BOOL)allowScale allowCalcVisiableRect:(BOOL)allowCalcVisiableRect;
- (void)rotateWithContext:(CGContextRef)context inRect:(CGRect)bounds;
- (void)scaleWithContext:(CGContextRef)context inRect:(CGRect)bounds;
- (void)translateWithContext:(CGContextRef)context;

@end

@implementation DCEditableImage

@synthesize url = _url;
@synthesize uti = _uti;
@synthesize rotation = _rotation;
@synthesize scaleX = _scaleX;
@synthesize scaleY = _scaleY;
@synthesize translateX = _translateX;
@synthesize translateY = _translateY;
@synthesize originImageSize = _originImageSize;
@synthesize editedImageSize = _editedImageSize;
@synthesize visiableRect = _visiableRect;

#pragma mark - Lifecycle
- (instancetype)initWithURL:(NSURL *)sourceUrl {
    DCFunctionPerformanceTimingBegin
    BOOL readSourceDone = NO;
    CGImageSourceRef imageSrc = NULL;
    NSInteger width = 0;
    NSInteger height = 0;
    do {
        if (!sourceUrl) {
            break;
        }
        imageSrc = CGImageSourceCreateWithURL((__bridge CFURLRef)(sourceUrl), NULL);
		CGImageRef image = CGImageSourceCreateImageAtIndex(imageSrc, 0, NULL);
		if (!image) {
			break;
		}
        _image = image;
        _properties = CGImageSourceCopyPropertiesAtIndex(imageSrc, 0, NULL);
        
        CFNumberRef pixelWidth = CFDictionaryGetValue(_properties, kCGImagePropertyPixelWidth);
        if (pixelWidth) {
            if (!CFNumberGetValue(pixelWidth, kCFNumberIntType, &width)) {
                break;
            }
        }
        
        CFNumberRef pixelHeight = CFDictionaryGetValue(_properties, kCGImagePropertyPixelHeight);
        if (pixelHeight) {
            if (!CFNumberGetValue(pixelHeight, kCFNumberIntType, &height)) {
                break;
            }
        }
        
        readSourceDone = YES;
    } while (NO);
    if (imageSrc) {
        CFRelease(imageSrc);
        imageSrc = nil;
    }
    if (!readSourceDone) {
        if (_image) {
            CGImageRelease(_image);
            _image = NULL;
        }
        if (_properties) {
            CFRelease(_properties);
            _properties = NULL;
        }
        return nil;
    }
    self = [super init];
    if (self) {
        self.url = [sourceUrl copy];
        self.uti = [self.url getUTType];
        
        self.rotation = 0.0;
        self.scaleX = 1.0;
        self.scaleY = 1.0;
        self.translateX = 0.0;
        self.translateY = 0.0;
        
        self.originImageSize = NSMakeSize(width, height);
        self.editedImageSize = self.originImageSize;
        
        self.visiableRect = NSMakeRect(0.0f, 0.0f, width, height);
        
        [self fixupImageOrientation];
    }
    NSString *msg = [NSString stringWithFormat:@"%@ %@%@", [self className], NSStringFromSelector(_cmd), sourceUrl];
    DCFunctionPerformanceTimingEnd(msg)
    return self;
}

- (void)dealloc {
    do {
        if (_image) {
            CGImageRelease(_image);
            _image = NULL;
        }
        if (_properties) {
            CFRelease(_properties);
            _properties = NULL;
        }
        self.uti = nil;
        self.url = nil;
    } while (NO);
}

#pragma mark - Public
- (void)setRotation:(CGFloat)rotation {
    do {
        _rotation = rotation;
        
        [self calcEditedImageSize];
    } while (NO);
}

- (void)setScaleX:(CGFloat)scaleX Y:(CGFloat)scaleY {
    do {
        _scaleX = scaleX;
        _scaleY = scaleY;
    } while (NO);
}

- (void)setPreserveAspectRatioScale:(CGFloat)scale {
    do {
        _scaleX = _scaleY = scale;
    } while (NO);
}

- (void)setTranslateX:(CGFloat)translateX Y:(CGFloat)translateY {
    do {
        _translateX = translateX;
        _translateY = translateY;
    } while (NO);
}

- (BOOL)saveAs:(NSURL *)destURL type:(NSString *)type {
    BOOL result = NO;
    do {
        result = [self saveCrop:NSMakeRect(0.0f, 0.0f, self.editedImageSize.width, self.editedImageSize.height) as:destURL type:type];
    } while (NO);
    return result;
}

- (BOOL)saveCrop:(NSRect)cropRect as:(NSURL *)destURL type:(NSString *)type {
    DCFunctionPerformanceTimingBegin
    BOOL result = NO;
    CGImageDestinationRef imageDest = NULL;
    CGContextRef bitmapContext = NULL;
    CGImageRef imageIOImage = NULL;
    CGColorSpaceRef rgbColorSpaceRef = NULL;
    do {
        if (DCFloatingNumberEqualToZero(cropRect.size.width) || DCFloatingNumberEqualToZero(cropRect.size.height) || !destURL || !type || !_image || !_properties) {
            break;
        }
        imageDest = CGImageDestinationCreateWithURL((__bridge CFURLRef)(destURL), (__bridge CFStringRef)(type), 1, NULL);
        if (!imageDest) {
            break;
        }
        
        int orginX = DCRoundingFloatToInt(cropRect.origin.x);
        int orginY = DCRoundingFloatToInt(cropRect.origin.y);
        int width = DCRoundingFloatToInt(cropRect.size.width);
        int height = DCRoundingFloatToInt(cropRect.size.height);
        
        bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, CGImageGetColorSpace(_image), kCGImageAlphaPremultipliedFirst);
        if (!bitmapContext) {
            rgbColorSpaceRef = CGColorSpaceCreateDeviceRGB();
            bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, rgbColorSpaceRef, kCGImageAlphaPremultipliedFirst);
            if (!bitmapContext) {
                break;
            }
        }
        
        [self drawWithContext:bitmapContext forSave:YES inRect:CGRectMake(orginX, orginY, width, height) allowTranslate:NO allowScale:NO allowCalcVisiableRect:NO];
        
        imageIOImage = CGBitmapContextCreateImage(bitmapContext);
        if (!imageIOImage) {
            break;
        }
        
        if ([self getImageOrientation] != 1) {
            CFMutableDictionaryRef prop = CFDictionaryCreateMutableCopy(NULL, 0, _properties);
            int orientation = 1;
            CFNumberRef cfOrientation = CFNumberCreate(NULL, kCFNumberIntType, &orientation);
            CFDictionarySetValue(prop, kCGImagePropertyOrientation, cfOrientation);
            
            CGImageDestinationAddImage(imageDest, imageIOImage, prop);
            
            CFRelease(prop);
            CFRelease(cfOrientation);
        } else {
            CGImageDestinationAddImage(imageDest, imageIOImage, _properties);
        }
        result = CGImageDestinationFinalize(imageDest);
    } while (NO);
    if (rgbColorSpaceRef) {
        CGColorSpaceRelease(rgbColorSpaceRef);
        rgbColorSpaceRef = NULL;
    }
    if (imageIOImage) {
        CGImageRelease(imageIOImage);
        imageIOImage = NULL;
    }
    if (bitmapContext) {
        CGContextRelease(bitmapContext);
        bitmapContext = NULL;
    }
    if (imageDest) {
        CFRelease(imageDest);
        imageDest = NULL;
    }
    NSString *msg = [NSString stringWithFormat:@"%@ %@ %@ %@", [self className], NSStringFromSelector(_cmd), destURL, type];
    DCFunctionPerformanceTimingEnd(msg)
    return result;
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    CGColorRef visiableRectColor = NULL;
    do {
        if (!context || DCFloatingNumberEqualToZero(bounds.size.width) || DCFloatingNumberEqualToZero(bounds.size.height)) {
            break;
        }
        
        [self drawWithContext:context forSave:NO inRect:bounds allowTranslate:YES allowScale:YES allowCalcVisiableRect:YES];
        
        // visiableRect
        if ((int)(self.rotation) % 360 != 0) {
            visiableRectColor = CGColorCreateGenericRGB(DC_RGB256(0.0f), DC_RGB256(128.0f), DC_RGB256(255.0f), 1.0f);
            CGContextSetLineWidth(context, 1.0);
            CGContextSetStrokeColorWithColor(context, visiableRectColor);
            CGContextAddRect(context, self.visiableRect);
            CGContextStrokePath(context);
        }
    } while (NO);
    if (visiableRectColor) {
        CGColorRelease(visiableRectColor);
        visiableRectColor = NULL;
    }
}

#pragma mark - Private
- (NSInteger)getImageOrientation {
    NSInteger result = 1;
    do {
        if (!_properties) {
            break;
        }
        
        CFNumberRef orientation = CFDictionaryGetValue(_properties, kCGImagePropertyOrientation);
        if (orientation != NULL) {
            int orient = 1;
            if (CFNumberGetValue(orientation, kCFNumberIntType, &orient)) {
                result = orient;
            }
        }
    } while (NO);
    return result;
}

- (void)fixupImageOrientation {
    CGContextRef context = NULL;
    do {
        if (!_image) {
            break;
        }
        NSInteger orientation = [self getImageOrientation];
        if (orientation != 1) {
            size_t width = CGImageGetWidth(_image);
            size_t height = CGImageGetHeight(_image);
            if (orientation <= 4) {
                // Orientations 1-4 are rotated 0 or 180 degrees, so they retain the width/height of the image
                context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGImageGetColorSpace(_image), kCGImageAlphaPremultipliedFirst);
            } else {
                // Orientations 5-8 are rotated ±90 degrees, so they swap width & height.
                context = CGBitmapContextCreate(NULL, height, width, 8, 0, CGImageGetColorSpace(_image), kCGImageAlphaPremultipliedFirst);
            }
            
            switch(orientation)
            {
                case 2:
                {
                    // 2 = 0th row is at the top, and 0th column is on the right - Flip Horizontal
                    CGContextConcatCTM(context, CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, width, 0.0));
                }
                    break;
                    
                case 3:
                {
                    // 3 = 0th row is at the bottom, and 0th column is on the right - Rotate 180 degrees
                    CGContextConcatCTM(context, CGAffineTransformMake(-1.0, 0.0, 0.0, -1.0, width, height));
                }
                    break;
                    
                case 4:
                {
                    // 4 = 0th row is at the bottom, and 0th column is on the left - Flip Vertical
                    CGContextConcatCTM(context, CGAffineTransformMake(1.0, 0.0, 0, -1.0, 0.0, height));
                }
                    break;
                    
                case 5:
                {
                    // 5 = 0th row is on the left, and 0th column is the top - Rotate -90 degrees and Flip Vertical
                    CGContextConcatCTM(context, CGAffineTransformMake(0.0, -1.0, -1.0, 0.0, height, width));
                }
                    break;
                    
                case 6:
                {
                    // 6 = 0th row is on the right, and 0th column is the top - Rotate 90 degrees
                    CGContextConcatCTM(context, CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, 0.0, width));
                }
                    break;
                    
                case 7:
                {
                    // 7 = 0th row is on the right, and 0th column is the bottom - Rotate 90 degrees and Flip Vertical
                    CGContextConcatCTM(context, CGAffineTransformMake(0.0, 1.0, 1.0, 0.0, 0.0, 0.0));
                }
                    break;
                    
                case 8:
                {
                    // 8 = 0th row is on the left, and 0th column is the bottom - Rotate -90 degrees
                    CGContextConcatCTM(context, CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, height, 0.0));
                }
                    break;
            }
            // Finally draw the image and replace the one in the ImageInfo struct.
            CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), _image);
            CFRelease(_image);
            _image = CGBitmapContextCreateImage(context);
        }
    } while (NO);
    if (context) {
        CFRelease(context);
        context = NULL;
    }
}

- (void)calcEditedImageSize {
    do {
        CGFloat editWith = self.originImageSize.width;
        CGFloat editHeight = self.originImageSize.height;
        CGFloat rotation = self.rotation;
        while (rotation > 90.0f) {
            rotation -= 180.0f;
            if (rotation < 0.0f) {
                rotation = 0 - rotation;
            }
        }
        CGFloat radian = DCDegreesToRadians(rotation);
        CGFloat sinFloat = sinf(radian);
        CGFloat cosFloat = cosf(radian);
        self.editedImageSize = NSMakeSize((editWith * cosFloat + editHeight * sinFloat), (editWith * sinFloat + editHeight * cosFloat));
        
    } while (NO);
}

- (void)calcVisiableRectInRect:(CGRect)bounds {
    do {
        CGFloat visiableWith = self.editedImageSize.width * self.scaleX;
        CGFloat visiableHeight = self.editedImageSize.height * self.scaleY;
        
        NSPoint center = NSMakePoint(bounds.origin.x + bounds.size.width / 2.0f, bounds.origin.y + bounds.size.height / 2.0f);
        
        self.visiableRect = NSMakeRect(center.x - visiableWith / 2.0f + self.translateX, center.y - visiableHeight / 2.0f + self.translateY, visiableWith, visiableHeight);
    } while (NO);
}

- (void)drawWithContext:(CGContextRef)context forSave:(BOOL)isForSave inRect:(CGRect)bounds allowTranslate:(BOOL)allowTranslate allowScale:(BOOL)allowScale allowCalcVisiableRect:(BOOL)allowCalcVisiableRect {
    do {
        if (!context || DCFloatingNumberEqualToZero(bounds.size.width) || DCFloatingNumberEqualToZero(bounds.size.height)) {
            break;
        }
        
        CGContextSaveGState(context);
        
        [self applyTransformationWithContext:context inRect:bounds allowTranslate:allowTranslate allowScale:allowScale allowCalcVisiableRect:allowCalcVisiableRect];
        
        [self drawRawDataWithContext:context forSave:isForSave inRect:bounds];
        
        CGContextRestoreGState(context);
    } while (NO);
}

- (void)drawRawDataWithContext:(CGContextRef)context forSave:(BOOL)isForSave inRect:(CGRect)bounds {
    do {
        if (!_image || !context || DCFloatingNumberEqualToZero(bounds.size.width) || DCFloatingNumberEqualToZero(bounds.size.height)) {
            break;
        }
        
        CGRect imageRect;
        
        // Setup the image size so that the image fills it's natural boudaries in the base coordinate system.
        imageRect.size.width = CGImageGetWidth(_image);
        imageRect.size.height = CGImageGetHeight(_image);
        
        if (isForSave && DCFloatingNumberEqualToZero(self.rotation)) {
            imageRect.origin.x = -bounds.origin.x;
            imageRect.origin.y = -bounds.origin.y;
        } else {
            // Position the image such that it is centered in the parent view.
            // fix up for pixel boundaries
            imageRect.origin.x = (bounds.size.width - imageRect.size.width) / 2.0f;
            imageRect.origin.y = (bounds.size.height - imageRect.size.height) / 2.0f;
        }
        
        // And draw the image.
        CGContextDrawImage(context, imageRect, _image);
    } while (NO);
}

- (void)applyTransformationWithContext:(CGContextRef)context inRect:(CGRect)bounds allowTranslate:(BOOL)allowTranslate allowScale:(BOOL)allowScale allowCalcVisiableRect:(BOOL)allowCalcVisiableRect {
    do {
        if (!_image || !context || DCFloatingNumberEqualToZero(bounds.size.width) || DCFloatingNumberEqualToZero(bounds.size.height)) {
            break;
        }
        
        if (allowCalcVisiableRect) {
            [self calcVisiableRectInRect:bounds];
        }
        
        // Whenever you do multiple CTM changes, you have to be very careful with order.
        // Changing the order of your CTM changes changes the outcome of the drawing operation.
        // For example, if you scale a context by 2.0 along the x-axis, and then translate
        // the context by 10.0 along the x-axis, then you will see your drawing will be
        // in a different position than if you had done the operations in the opposite order.
        
        // Our intent with this operation is that we want to change the location from which we start drawing
        // (translation), then rotate our axies so that our image appears at an angle (rotation), and finally
        // scale our axies so that our image has a different size (scale).
        // Changing the order of operations will markedly change the results.
        if (allowTranslate) {
            [self translateWithContext:context];
        }
        
        [self rotateWithContext:context inRect:bounds];
        
        if (allowScale) {
            [self scaleWithContext:context inRect:bounds];
        }
    } while (NO);
}

- (void)rotateWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!_image || !context || DCFloatingNumberEqualToZero(bounds.size.width) || DCFloatingNumberEqualToZero(bounds.size.height)) {
            break;
        }
        
        // First we translate the context such that the 0,0 location is at the center of the bounds
        CGContextTranslateCTM(context, bounds.size.width / 2.0f, bounds.size.height / 2.0f);
        
        // Then we rotate the context, converting our angle from degrees to radians
        CGContextRotateCTM(context, self.rotation * M_PI / 180.0f);
        
        // Finally we have to restore the center position
        CGContextTranslateCTM(context, -bounds.size.width / 2.0f, -bounds.size.height / 2.0f);
    } while (NO);
}

- (void)scaleWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!_image || !context || DCFloatingNumberEqualToZero(bounds.size.width) || DCFloatingNumberEqualToZero(bounds.size.height)) {
            break;
        }
        
        // First we translate the context such that the 0,0 location is at the center of the bounds
        CGContextTranslateCTM(context, bounds.size.width / 2.0f, bounds.size.height / 2.0f);
        
        // Next we scale the context to the size that we want
        CGContextScaleCTM(context, self.scaleX, self.scaleY);
        
        // Finally we have to restore the center position
        CGContextTranslateCTM(context, -bounds.size.width / 2.0f, -bounds.size.height / 2.0f);
    } while (NO);
}

- (void)translateWithContext:(CGContextRef)context {
    do {
        if (!_image || !context) {
            break;
        }
        
        CGContextTranslateCTM(context, self.translateX, self.translateY);
    } while (NO);
}

@end
