//
//  DCImageCropTool+Responder.h
//  LampLighter
//
//  Created by Derek Chen on 7/4/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "DCImageCropTool.h"

@interface DCImageCropTool (Responder)

- (NSPoint)fitinMouseHitLocationPointBy:(DCImageCropMouseHitLocation)mouseHitLoc andHitPoint:(NSPoint)hitPoint;

@end
