//
//  BBH264SoftEncoder.h
//  FFmpeg+x264EncodeToH.264
//
//  Created by ibabyblue on 2018/2/11.
//  Copyright © 2018年 ibabyblue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
@class BBVideoConfig;
@interface BBH264SoftEncoder : NSObject
/*
 * 设置编码后文件的保存路径
 */
- (void)setFilePath:(NSString *)path;

/*
 * 初始化编码配置
 */
- (void)setupEncodeWithConfig:(BBVideoConfig *)config;

/*
 * 将CMSampleBufferRef格式的数据编码成h264并写入文件
 */
- (void)encoderToH264:(CMSampleBufferRef)sampleBuffer;

/*
 * 释放资源
 */
- (void)freeX264Resource;
@end
