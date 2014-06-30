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

extern CGSize DCImageCropRatioAry[];

@interface DCImageCropTool : DCImageEditTool

+ (NSString *)descriptionForImageCropType:(DCImageCropType)type;

@end