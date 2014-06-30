//
//  DCEditableImage.m
//  LampLighter
//
//  Created by Derek Chen on 6/23/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCEditableImage.h"

@interface DCEditableImage () {
    CGImageRef _image;
    CFDictionaryRef _properties;
}

@property (strong, nonatomic) NSURL *url;

@property (assign, nonatomic) CGFloat rotation;

@property (assign, nonatomic) CGFloat scaleX;
@property (assign, nonatomic) CGFloat scaleY;

@property (assign, nonatomic) CGFloat translateX;
@property (assign, nonatomic) CGFloat translateY;

@property (assign, nonatomic) CGSize originImageSize;
@property (assign, nonatomic) CGSize editedImageSize;

- (NSInteger)getImageOrientation;
- (void)fixupImageOrientation;

- (void)calcEditedImageSize;

- (void)drawRawDataWithContext:(CGContextRef)context inRect:(CGRect)bounds;
- (void)applyTransformationWithContext:(CGContextRef)context inRect:(CGRect)bounds;
- (void)rotateWithContext:(CGContextRef)context inRect:(CGRect)bounds;
- (void)scaleWithContext:(CGContextRef)context inRect:(CGRect)bounds;
- (void)translateWithContext:(CGContextRef)context;

@end

@implementation DCEditableImage

@synthesize url = _url;
@synthesize rotation = _rotation;
@synthesize scaleX = _scaleX;
@synthesize scaleY = _scaleY;
@synthesize translateX = _translateX;
@synthesize translateY = _translateY;
@synthesize originImageSize = _originImageSize;
@synthesize editedImageSize = _editedImageSize;

#pragma mark - Lifecycle
- (instancetype)initWithURL:(NSURL *)sourceUrl {
    BOOL readSourceDone = NO;
    CGImageSourceRef imageSrc = nil;
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
            _image = nil;
        }
        if (_properties) {
            CFRelease(_properties);
            _properties = nil;
        }
        return nil;
    }
    self = [super init];
    if (self) {
        self.url = [sourceUrl copy];
        
        self.rotation = 0.0;
        self.scaleX = 1.0;
        self.scaleY = 1.0;
        self.translateX = 0.0;
        self.translateY = 0.0;
        
        self.originImageSize = NSMakeSize(width, height);
        self.editedImageSize = self.originImageSize;
        
        [self fixupImageOrientation];
    }
    return self;
}

- (void)dealloc {
    do {
        if (_image) {
            CGImageRelease(_image);
            _image = nil;
        }
        if (_properties) {
            CFRelease(_properties);
            _properties = nil;
        }
    } while (NO);
}

#pragma mark - Public
- (void)setRotation:(CGFloat)rotation {
    do {
        _rotation = rotation;
    } while (NO);
}

- (void)setScaleX:(CGFloat)scaleX Y:(CGFloat)scaleY {
    do {
        _scaleX = scaleX;
        _scaleY = scaleY;
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
    CGImageDestinationRef imageDest = nil;
    CGContextRef bitmapContext = nil;
    CGImageRef imageIOImage = nil;
    do {
        if (!destURL || !type || !_image || !_properties) {
            break;
        }
        imageDest = CGImageDestinationCreateWithURL((__bridge CFURLRef)(destURL), (__bridge CFStringRef)(type), 1, NULL);
        if (!imageDest) {
            break;
        }
        bitmapContext = CGBitmapContextCreate(NULL, self.editedImageSize.width, self.editedImageSize.height, 8, 0, CGImageGetColorSpace(_image),kCGImageAlphaPremultipliedFirst);
        if (!bitmapContext) {
            break;
        }
        
        [self drawWithContext:bitmapContext inRect:CGRectMake(0.0, 0.0, self.editedImageSize.width, self.editedImageSize.height)];
        
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
    } while (NO);
    if (imageIOImage) {
        CGImageRelease(imageIOImage);
        imageIOImage = nil;
    }
    if (bitmapContext) {
        CGContextRelease(bitmapContext);
        bitmapContext = nil;
    }
    if (imageDest) {
        CFRelease(imageDest);
        imageDest = nil;
    }
    return result;
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!context || bounds.size.width == 0 || bounds.size.height == 0) {
            break;
        }
        CGContextSaveGState(context);
        [self applyTransformationWithContext:context inRect:bounds];
        [self drawRawDataWithContext:context inRect:bounds];
        CGContextRestoreGState(context);
    } while (NO);
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
    CGContextRef context = nil;
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
        context = nil;
    }
}

- (void)calcEditedImageSize {
    do {
        ;
    } while (NO);
}

- (void)drawRawDataWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!_image || !context || bounds.size.width == 0 || bounds.size.height == 0) {
            break;
        }
        
        CGRect imageRect;
        
        // Setup the image size so that the image fills it's natural boudaries in the base coordinate system.
        imageRect.size.width = CGImageGetWidth(_image);
        imageRect.size.height = CGImageGetHeight(_image);
        
        // Position the image such that it is centered in the parent view.
        // fix up for pixel boundaries
        imageRect.origin.x = (bounds.size.width - imageRect.size.width) / 2.0f;
        imageRect.origin.y = (bounds.size.height - imageRect.size.height) / 2.0f;
        
        // And draw the image.
        CGContextDrawImage(context, imageRect, _image);
    } while (NO);
}

- (void)applyTransformationWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!_image || !context || bounds.size.width == 0 || bounds.size.height == 0) {
            break;
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
        [self translateWithContext:context];
        [self rotateWithContext:context inRect:bounds];
        [self rotateWithContext:context inRect:bounds];
    } while (NO);
}

- (void)rotateWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!_image || !context || bounds.size.width == 0 || bounds.size.height == 0) {
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
        if (!_image || !context || bounds.size.width == 0 || bounds.size.height == 0) {
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
