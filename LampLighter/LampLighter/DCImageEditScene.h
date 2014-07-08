//
//  DCImageEditScene.h
//  LampLighter
//
//  Created by Derek Chen on 7/8/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCImageEditTool.h"

@class DCEditableImage;

@interface DCImageEditScene : NSObject {
}

@property (strong, nonatomic, readonly) NSString *uuid;
@property (strong, nonatomic, readonly) DCEditableImage *editableImage;
@property (strong, nonatomic, readonly) DCImageEditTool *imageEditTool;

+ (NSString *)getCacheDir;

- (instancetype)initWithType:(DCImageEditToolType)type andImageURL:(NSURL *)imageURL;
- (NSURL *)cache;

@end
