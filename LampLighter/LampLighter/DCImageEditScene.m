//
//  DCImageEditScene.m
//  LampLighter
//
//  Created by Derek Chen on 7/8/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditScene.h"
#import "DCEditableImage.h"
#import "DCImageRotateTool.h"
#import "DCImageCropTool.h"

@interface DCImageEditScene () {
}

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) DCEditableImage *editableImage;
@property (strong, nonatomic) DCImageEditTool *imageEditTool;

@end

@implementation DCImageEditScene

@synthesize uuid = _uuid;
@synthesize editableImage = _editableImage;
@synthesize imageEditTool = _imageEditTool;

+ (NSString *)getCacheDir {
    NSString *result = nil;
    do {
        NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        DCAssert(pathAry.count > 0);
        result = [NSString stringWithFormat:@"%@/%@", [pathAry objectAtIndex:0], [[NSBundle mainBundle] bundleIdentifier]];
    } while (NO);
    return result;
}

#pragma mark - Lifecycle
- (id)init {
    self = [super init];
    if (self) {
        self.uuid = [DCCommonUtility createUniqueStrByUUID];
        self.editableImage = nil;
        self.imageEditTool = nil;
    }
    return self;
}

- (void)dealloc {
    do {
        NSString *cacheDir = [DCImageEditScene getCacheDir];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if ([fileMgr fileExistsAtPath:cacheDir isDirectory:&isDir] && isDir) {
            NSURL *cacheURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", cacheDir, self.uuid]];
            NSError *err = nil;
            if (![fileMgr removeItemAtURL:cacheURL error:&err] || err) {
                NSLog(@"%@", [err localizedDescription]);
            }
        }
        self.imageEditTool = nil;
        self.editableImage = nil;
        self.uuid = nil;
    } while (NO);
}

#pragma mark - Public
- (instancetype)initWithType:(DCImageEditToolType)type andImageURL:(NSURL *)imageURL {
    do {
        DCAssert(imageURL != nil);
        self.editableImage = [[DCEditableImage alloc] initWithURL:imageURL];
        DCAssert(self.editableImage != nil);
        switch (type) {
            case DCImageEditToolType_Rotate:
            {
                self.imageEditTool = [[DCImageRotateTool alloc] initWithEditableImage:self.editableImage];
            }
                break;
            case DCImageEditToolType_Crop:
            {
                self.imageEditTool = [[DCImageCropTool alloc] initWithEditableImage:self.editableImage];
            }
                break;
            default:
                break;
        }
        DCAssert(self.imageEditTool != nil);
    } while (NO);
    return self;
}

- (NSURL *)cache {
    NSURL *result = nil;
    do {
        if (!self.editableImage || !self.imageEditTool) {
            break;
        }
        
        NSString *cacheDir = [DCImageEditScene getCacheDir];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if (![fileMgr fileExistsAtPath:cacheDir isDirectory:&isDir] || !isDir) {
            [fileMgr createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
            DCAssert([fileMgr fileExistsAtPath:cacheDir isDirectory:&isDir] && isDir);
        }
        
        NSURL *cacheURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", cacheDir, self.uuid]];
        
        BOOL saveSucc = NO;
        switch (self.imageEditTool.type) {
            case DCImageEditToolType_Rotate:
            {
                if ([self.editableImage saveAs:cacheURL type:nil]) {
                    saveSucc = YES;
                }
            }
                break;
            case DCImageEditToolType_Crop:
            {
                DCImageCropTool *cropTool = (DCImageCropTool *)self.imageEditTool;
                NSRect cropRect = NSMakeRect((cropTool.cropRect.origin.x - self.editableImage.visiableRect.origin.x) / self.editableImage.scaleX, (cropTool.cropRect.origin.y - self.editableImage.visiableRect.origin.y) / self.editableImage.scaleX, cropTool.cropRect.size.width / self.editableImage.scaleX, cropTool.cropRect.size.height / self.editableImage.scaleX);
                if ([self.editableImage saveCrop:cropRect as:cacheURL type:nil]) {
                    saveSucc = YES;
                }
            }
                break;
            default:
                break;
        }
        if (saveSucc) {
            result = cacheURL;
        }
    } while (NO);
    return result;
}

@end
