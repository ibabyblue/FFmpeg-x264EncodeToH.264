//
//  BBVideoConfig.m
//  x264EncodeToH.264
//
//  Created by ibabyblue on 2018/2/9.
//  Copyright © 2018年 ibabyblue. All rights reserved.
//

#import "BBVideoConfig.h"

@implementation BBVideoConfig
+ (instancetype)defaultConfig{
    BBVideoConfig *config = [[BBVideoConfig alloc] init];
    config.videoSize = CGSizeMake(480, 640);
    config.fps = 24;
    config.bitrate = config.videoSize.width * config.videoSize.height * 3;
    config.keyframeInterval = config.fps * 2;
    return config;
}
@end

