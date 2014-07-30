//
//  DCImageRotateTool.h
//  LampLighter
//
//  Created by Derek Chen on 6/26/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageEditTool.h"

extern NSString *kImageEditPragma_Rotation;

extern NSString *kDCImageRotateToolRotation;

@interface DCImageRotateTool : DCImageEditTool

@property (assign, nonatomic) CGFloat rotation;

@end
