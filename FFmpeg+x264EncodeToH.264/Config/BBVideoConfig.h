//
//  BBVideoConfig.h
//  x264EncodeToH.264
//
//  Created by ibabyblue on 2018/2/9.
//  Copyright © 2018年 ibabyblue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBVideoConfig : NSObject
/**
 *  视频尺寸,默认640*480
 */
@property (nonatomic,assign) CGSize videoSize;

/**
 *  码率,默认视频宽*视频高*3
 */
@property (nonatomic,assign) int bitrate;

/**
 *  fps,默认24
 */
@property (nonatomic,assign) int fps;

/**
 *  关键帧间隔,一般为fps的倍数,默认fps*2
 */
@property (nonatomic,assign) int keyframeInterval;

+ (instancetype)defaultConfig;
@end
