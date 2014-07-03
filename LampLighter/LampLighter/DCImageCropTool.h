//
//  DCImageCropTool.h
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditTool.h"

typedef NS_ENUM(NSUInteger, DCImageCropType) {
    DCImageCropType_Custom,
    DCImageCropType_1x1,
    DCImageCropType_2x3,
    DCImageCropType_3x5,
    DCImageCropType_5x7,
    DCImageCropType_4x3_Portait,
    DCImageCropType_4x3_Landscape,
    DCImageCropType_16x9_Portait,
    DCImageCropType_16x9_Landscape,
    DCImageCropType_16x10_Portait,
    DCImageCropType_16x10_Landscape,
    DCImageCropType_A4,
    
    DCImageCropType_Count,
};

typedef NS_ENUM(NSUInteger, DCImageCropMouseHitLocation) {
    DCImageCropMouseHitLoc_Outside,
    DCImageCropMouseHitLoc_Inside,
    DCImageCropMouseHitLoc_TopLeft,
    DCImageCropMouseHitLoc_BottomLeft,
    DCImageCropMouseHitLoc_TopRight,
    DCImageCropMouseHitLoc_BottomRight,
    DCImageCropMouseHitLoc_TopCenter,
    DCImageCropMouseHitLoc_BottomCenter,
    DCImageCropMouseHitLoc_LeftCenter,
    DCImageCropMouseHitLoc_RightCenter,
    
    DCImageCropMouseHitLoc_Count,
};

extern NSString *kImageEditPragma_CropMouseHitLocationX;
extern NSString *kImageEditPragma_CropMouseHitLocationY;

extern CGSize DCImageCropRatioAry[];

@interface DCImageCropTool : DCImageEditTool

+ (NSString *)descriptionForImageCropType:(DCImageCropType)type;

@property (assign, nonatomic, readonly) DCImageCropType type;
@property (assign, atomic) NSUInteger anchorRadius;

- (void)resetCropRect;

@end
