//
//  BBH264Encoder.h
//  x264EncodeToH.264
//
//  Created by ibabyblue on 2018/1/25.
//  Copyright © 2018年 ibabyblue. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BBVideoCapture : NSObject

/**
 开始捕获视频

 @param preview 捕获视频显示的父控件
 */
- (void)startCapture:(UIView *)preview;

/**
 结束捕获视频
 */
- (void)stopCapture;

@end
