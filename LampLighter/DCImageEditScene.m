//
//  DCImageEditScene.m
//  LampLighter
//
//  Created by Derek Chen on 7/8/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditScene.h"
#import "DCEditableImage.h"
#import "DCImageEditView.h"
#import "DCImageRotateTool.h"
#import "DCImageCropTool.h"

const CGFloat kImageEditor_ZoomRatio_Max = 3.0f;
const CGFloat kImageEditor_ZoomRatio_Min = 0.05f;

const CGFloat kImageEditor_ZoomStep = 0.05f;

NSString *kDCImageEditSceneCodingEditImagePreviewInfo = @"DCImageEditSceneCodingEditImagePreviewInfo";
NSString *kDCImageEditSceneCodingEditTool = @"DCImageEditSceneCodingEditTool";

@interface DCImageEditScene () {
}

@property (copy, nonatomic) NSString *uuid;
@property (copy, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) DCEditableImage *editableImage;
@property (strong, nonatomic) DCImageEditTool *imageEditTool;
@property (strong, nonatomic) DCJSONUserDefault *userDef;

@end

@implementation DCImageEditScene

@synthesize delegate = _delegate;
@synthesize uuid = _uuid;
@synthesize imageURL = _imageURL;
@synthesize editableImage = _editableImage;
@synthesize imageEditTool = _imageEditTool;
@synthesize userDef = _userDef;

+ (NSString *)getCacheDir {
    NSString *result = nil;
    do {
        NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        DCAssert(pathAry.count > 0);
        NSString *cacheDir = [NSString stringWithFormat:@"%@/%@", [pathAry objectAtIndex:0], [[NSBundle mainBundle] bundleIdentifier]];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if (![fileMgr fileExistsAtPath:cacheDir isDirectory:&isDir] || !isDir) {
            [fileMgr createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
            DCAssert([fileMgr fileExistsAtPath:cacheDir isDirectory:&isDir] && isDir);
        }
        result = cacheDir;
    } while (NO);
    return result;
}

+ (NSURL *)cacheImage:(NSURL *)sourceURL withUUID:(NSString *)uuid {
    NSURL *result = nil;
    do {
        if (!sourceURL || !uuid) {
            break;
        }
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if (![fileMgr fileExistsAtPath:[sourceURL relativePath]]) {
            break;
        }
        NSString *dir = [[DCImageEditScene getCacheDir] stringByAppendingPathComponent:uuid];
        BOOL isDirectory = NO;
        if (![fileMgr fileExistsAtPath:dir isDirectory:&isDirectory] || !isDirectory) {
            [fileMgr createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:NULL error:NULL];
        }
        NSString *path = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", uuid, [[sourceURL relativePath] pathExtension]]];
        result = [NSURL fileURLWithPath:path];
        isDirectory = NO;
        if (![fileMgr fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory) {
            NSError *err = nil;
            if (![fileMgr copyItemAtURL:sourceURL toURL:result error:&err] || err) {
                result = nil;
                NSLog(@"%@", [err localizedDescription]);
                break;
            }
        }
    } while (NO);
    return result;
}

+ (void)clearExistedFile:(NSString *)path {
    do {
        if (!path) {
            break;
        }
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSError *err = nil;
        BOOL isDirectory = NO;
        if ([fileMgr fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
            if (![fileMgr removeItemAtPath:path error:&err] || err) {
                NSLog(@"%@", [err localizedDescription]);
                break;
            }
        }
    } while (NO);
}

- (BOOL)active {
    BOOL result = NO;
    do {
        if (![self loadWithUUID:self.uuid imageURL:self.imageURL]) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)inactive {
    BOOL result = NO;
    do {
        self.delegate = nil;
        self.editableImage = nil;
        self.imageEditTool = nil;
        
        result = YES;
    } while (NO);
    return result;
}

#pragma mark - Lifecycle
- (id)init {
    self = [super init];
    if (self) {
        self.imageURL = nil;
        self.editableImage = nil;
        self.imageEditTool = nil;
        self.delegate = nil;
    }
    return self;
}

- (void)dealloc {
    do {
        self.delegate = nil;
        self.imageEditTool = nil;
        self.editableImage = nil;
        self.imageURL = nil;
        self.uuid = nil;
    } while (NO);
}

#pragma mark - Public
- (BOOL)loadWithUUID:(NSString *)uuid imageURL:(NSURL *)imageURL {
    BOOL result = NO;
    do {
        DCAssert(uuid != nil && imageURL != nil);
        self.uuid = uuid;
        self.imageURL = [[DCImageEditScene cacheImage:imageURL withUUID:self.uuid] copy];
        self.editableImage = [[DCEditableImage alloc] initWithURL:self.imageURL];
        DCAssert(self.editableImage != nil);
        self.editableImage.delegate = self;
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *cacheDir = [[DCImageEditScene getCacheDir] stringByAppendingPathComponent:self.uuid];
        BOOL isDirectory = NO;
        if (![fileMgr fileExistsAtPath:cacheDir isDirectory:&isDirectory] || !isDirectory) {
            [fileMgr createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:NULL error:NULL];
        }
        
        NSString *path = [cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.uuid]];
        
        self.userDef = [[DCJSONUserDefault alloc] init];
        [self.userDef initWithContents:path shouldEncrypt:YES];
        
        NSDictionary *imagePreviewInfo = [self.userDef objectForKey:kDCImageEditSceneCodingEditImagePreviewInfo];
        if (imagePreviewInfo) {
            [self.editableImage loadFromPreviewInfo:imagePreviewInfo];
        }
        
        NSDictionary *editToolInfo = [self.userDef objectForKey:kDCImageEditSceneCodingEditTool];
        if (editToolInfo) {
            DCImageEditToolType type = (DCImageEditToolType)[[editToolInfo objectForKey:kDCImageEditToolCodingType] integerValue];
            switch (type) {
                case DCImageEditToolType_Rotate:
                {
                    self.imageEditTool = [[DCImageRotateTool alloc] init];
                }
                    break;
                case DCImageEditToolType_Crop:
                {
                    self.imageEditTool = [[DCImageCropTool alloc] init];
                }
                    break;
                default:
                    break;
            }
            if (self.imageEditTool) {
                [self.imageEditTool loadFormDict:editToolInfo];
                self.imageEditTool.actionDelegate = self;
                [self.imageEditTool resetEditableImage:self.editableImage];
            }
        }
        
//        isDirectory = NO;
//        if ([fileMgr fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
//            NSData *data = [NSData dataWithContentsOfFile:path];
//            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//            self.imageEditTool = [unarchiver decodeObjectForKey:kDCImageEditSceneCodingEditTool];
//            self.imageEditTool.actionDelegate = self;
//            [self.imageEditTool resetEditableImage:self.editableImage];            
//        }
        
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)reset {
    BOOL result = NO;
    do {
//        DCImageEditToolType type = self.imageEditTool.type;
//        switch (type) {
//            case DCImageEditToolType_Rotate:
//            {
//                self.imageEditTool = [[DCImageRotateTool alloc] initWithEditableImage:self.editableImage];
//                result = YES;
//            }
//                break;
//            case DCImageEditToolType_Crop:
//            {
//                DCImageCropType cropType = [(DCImageCropTool *)self.imageEditTool cropType];
//                DCImageCropTool *cropTool = [[DCImageCropTool alloc] initWithEditableImage:self.editableImage];
//                [cropTool resetCropType:cropType];
//                self.imageEditTool = cropTool;
//                result = YES;
//            }
//                break;
//            default:
//                break;
//        }
//        if (self.imageEditTool) {
//            self.imageEditTool.actionDelegate = self;
//        }
        
        self.imageEditTool.actionDelegate = nil;
        self.imageEditTool = nil;
        
        [self.editableImage reset];
        
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)resetEditToolByType:(DCImageEditToolType)type {
    BOOL result = NO;
    do {
        switch (type) {
            case DCImageEditToolType_Rotate:
            {
                self.imageEditTool = [[DCImageRotateTool alloc] initWithEditableImage:self.editableImage];
                result = YES;
            }
                break;
            case DCImageEditToolType_Crop:
            {
                DCImageCropType cropType = [(DCImageCropTool *)self.imageEditTool cropType];
                DCImageCropTool *cropTool = [[DCImageCropTool alloc] initWithEditableImage:self.editableImage];
                [cropTool resetCropType:cropType];
                self.imageEditTool = cropTool;
                result = YES;
            }
                break;
            default:
            {
                self.imageEditTool = nil;
            }
                break;
        }
        if (self.imageEditTool) {
            self.imageEditTool.actionDelegate = self;
        }
        
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)needCache {
    BOOL result = NO;
    do {
        if (self.imageEditTool) {
            result = [self.imageEditTool isEdited];
        }
    } while (NO);
    return result;
}

- (BOOL)saveImageAs:(NSURL *)destURL {
    BOOL result = NO;
    do {
        if (!destURL) {
            break;
        }
        
        BOOL isCopy = NO;
        if (self.imageEditTool) {
            switch (self.imageEditTool.type) {
                case DCImageEditToolType_Rotate:
                {
                    if ([self.editableImage saveAs:destURL type:nil]) {
                        result = YES;
                    }
                }
                    break;
                case DCImageEditToolType_Crop:
                {
                    DCImageCropTool *cropTool = (DCImageCropTool *)self.imageEditTool;
                    NSRect cropRect = NSMakeRect((cropTool.cropRect.origin.x - self.editableImage.visiableRect.origin.x) / self.editableImage.scaleX, (cropTool.cropRect.origin.y - self.editableImage.visiableRect.origin.y) / self.editableImage.scaleX, cropTool.cropRect.size.width / self.editableImage.scaleX, cropTool.cropRect.size.height / self.editableImage.scaleX);
                    if ([self.editableImage saveCrop:cropRect as:destURL type:nil]) {
                        result = YES;
                    }
                }
                    break;
                case DCImageEditToolType_None:
                default:
                {
                    isCopy = YES;
                }
                    break;
            }
        } else {
            isCopy = YES;
        }
        
        if (isCopy) {
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSError *err = nil;
            if (![fileMgr copyItemAtURL:self.imageURL toURL:destURL error:&err] || err) {
                NSLog(@"%@", [err localizedDescription]);
                break;
            }
            result = YES;
        }
    } while (NO);
    return result;
}

- (NSURL *)cacheWithNewUUID:(NSString *)newUUID {
    NSURL *result = nil;
    do {
        if (!newUUID || !self.editableImage || !self.imageEditTool) {
            break;
        }
        
        if (![self cacheEditInfo]) {
            break;
        }
        
        result = [self cacheEditImage:newUUID];
    } while (NO);
    return result;
}

- (BOOL)cacheEditInfo {
    BOOL result = NO;
    do {
        if (!self.imageEditTool) {
            break;
        }
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // save edit tool
        NSString *cacheDir = [[DCImageEditScene getCacheDir] stringByAppendingPathComponent:self.uuid];
        BOOL isDirectory = NO;
        if (![fileMgr fileExistsAtPath:cacheDir isDirectory:&isDirectory] || !isDirectory) {
            [fileMgr createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:NULL error:NULL];
        }
        
        NSString *path = [cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.uuid]];
        
        [DCImageEditScene clearExistedFile:path];
        
        NSDictionary *imagePreviewInfo = [self.editableImage getPreviewInfo];
        if (!imagePreviewInfo) {
            break;
        }
        
        NSDictionary *editToolInfo = [self.imageEditTool getInfo];
        if (!editToolInfo) {
            break;
        }
        
        [self.userDef setObject:imagePreviewInfo forKey:kDCImageEditSceneCodingEditImagePreviewInfo];
        [self.userDef setObject:editToolInfo forKey:kDCImageEditSceneCodingEditTool];
        
        [self.userDef synchronize];
//        NSMutableData *data = [NSMutableData data];
//        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//        [archiver encodeObject:self.imageEditTool forKey:kDCImageEditSceneCodingEditTool];
//        [archiver finishEncoding];
        
        
        
//        [data writeToFile:path atomically:YES];
        
        result = YES;
    } while (NO);
    return result;
}

- (NSURL *)cacheEditImage:(NSString *)newUUID {
    NSURL *result = nil;
    do {
        if (!newUUID || !self.editableImage) {
            break;
        }
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // save image
        NSString *cacheDir = [[DCImageEditScene getCacheDir] stringByAppendingPathComponent:newUUID];
        BOOL isDirectory = NO;
        if (![fileMgr fileExistsAtPath:cacheDir isDirectory:&isDirectory] || !isDirectory) {
            [fileMgr createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:NULL error:NULL];
        }
        
        NSString *path = [cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", newUUID, [[self.imageURL absoluteString] pathExtension]]];
        
        [DCImageEditScene clearExistedFile:path];
        
        NSURL *cacheURL = [NSURL fileURLWithPath:path];
        
        BOOL saveSucc = [self saveImageAs:cacheURL];
        if (saveSucc) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditScene:cachedImageToURL:)]) {
                [self.delegate imageEditScene:self cachedImageToURL:cacheURL];
            }
            result = cacheURL;
        }
    } while (NO);
    return result;
}

- (NSSize)calcFitinSizeInView:(NSView *)view {
    NSSize result = NSMakeSize(0.0f, 0.0f);
    do {
        if (!self.editableImage || !view) {
            break;
        }
        result = [DCImageUtility fitSize:self.editableImage.editedImageSize inSize:view.bounds.size];
    } while (NO);
    return result;
}

- (CGFloat)calcFitinRatioSizeInView:(NSView *)view {
    CGFloat result = 1.0f;
    do {
        if (!view) {
            break;
        }
        NSSize fitinSize = [self calcFitinSizeInView:view];
        result = fitinSize.width / self.editableImage.editedImageSize.width;
    } while (NO);
    return result;
}

- (CGFloat)imageScale {
    CGFloat result = 1.0f;
    do {
        if (!self.editableImage) {
            break;
        }
        result = self.editableImage.scaleX;
    } while (NO);
    return result;
}

- (void)zoom:(CGFloat)ratio {
    do {
        if (!self.editableImage) {
            break;
        }
        if (ratio < kImageEditor_ZoomRatio_Min) {
            ratio = kImageEditor_ZoomRatio_Min;
        }
        if (ratio > kImageEditor_ZoomRatio_Max) {
            ratio = kImageEditor_ZoomRatio_Max;
        }
        [self.editableImage setPreserveAspectRatioScale:ratio];
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditSceneZoomedImage:)]) {
            [self.delegate imageEditSceneZoomedImage:self];
        }
    } while (NO);
}

- (void)moveWithX:(CGFloat)x andY:(CGFloat)y {
    do {
        if (!self.editableImage) {
            break;
        }
        [self.editableImage setTranslateX:x Y:y];
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditSceneMovedImage:)]) {
            [self.delegate imageEditSceneMovedImage:self];
        }
    } while (NO);
}

- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)bounds {
    do {
        if (!context) {
            break;
        }
        
        if (self.editableImage) {
            [self.editableImage drawWithContext:context inRect:bounds];
        }
        
        if (self.imageEditTool) {
            [self.imageEditTool drawWithContext:context inRect:bounds];
        }
    } while (NO);
}

- (void)imageEditorViewDidResized:(NSNotification *)notification {
    do {
        if (!notification) {
            break;
        }
        
        [self.imageEditTool imageEditorViewDidResized:notification];
    } while (NO);
}

#pragma mark - DCImageEditToolActionDelegate
- (void)imageEditTool:(DCImageEditTool *)tool valueChanged:(NSDictionary *)infoDict {
    do {
        if (!tool || !infoDict) {
            break;
        }

        NSNumber *rotateNum = [infoDict objectForKey:kImageEditPragma_Rotation];
        if (rotateNum) {
            [self.editableImage setRotation:[rotateNum floatValue]];
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditScene:editImageWithValue:)]) {
            [self.delegate imageEditScene:self editImageWithValue:infoDict];
        }
    } while (NO);
}

- (void)imageEditToolReseted:(DCImageEditTool *)tool {
    do {
        if (!tool) {
            break;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditSceneResetEditimage:)]) {
            [self.delegate imageEditSceneResetEditimage:self];
        }
    } while (NO);
}

#pragma mark - DCEditableImageDelegate
- (void)imageVisiableRectChanged:(DCEditableImage *)image {
    do {
        if (!image || !self.imageEditTool) {
            break;
        }
        [self.imageEditTool handleImageVisiableRectChanged];
    } while (NO);
}
@end
