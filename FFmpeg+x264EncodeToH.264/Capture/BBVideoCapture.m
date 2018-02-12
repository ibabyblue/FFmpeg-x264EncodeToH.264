//
//  BBH264Encoder.h
//  x264EncodeToH.264
//
//  Created by ibabyblue on 2018/1/25.
//  Copyright © 2018年 ibabyblue. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BBVideoCapture.h"
#import "BBH264SoftEncoder.h"
#import "BBVideoConfig.h"

@interface BBVideoCapture () <AVCaptureVideoDataOutputSampleBufferDelegate>

/** 编码对象 */
@property (nonatomic, strong) BBH264SoftEncoder         *encoder;

/** 编码配置项 */
@property (nonatomic, strong) BBVideoConfig             *config;

/** 捕捉画面执行的线程队列 */
@property (nonatomic, strong) dispatch_queue_t          captureQueue;

/** 捕捉会话*/
@property (nonatomic, weak) AVCaptureSession            *captureSession;

/** 预览图层 */
@property (nonatomic, weak) AVCaptureVideoPreviewLayer  *previewLayer;

/**编码队列*/
@property (nonatomic, strong) dispatch_queue_t          encodeQueue;

@end

@implementation BBVideoCapture

#pragma mark - 开始编码/结束编码
- (void)startCapture:(UIView *)preview
{
    self.encodeQueue = dispatch_queue_create(DISPATCH_QUEUE_SERIAL, NULL);
    
    //0.初始化编码对象
    self.encoder = [[BBH264SoftEncoder alloc] init];
    
    //1.设置h264文件保存路径
    [self h264FilePath];
    
    //2.初始化配置项
    self.config = [BBVideoConfig defaultConfig];
    
    //3.设置x264参数
    self.config.bitrate = 1500000;
    [self.encoder setupEncodeWithConfig:self.config];

    //4.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    //4.1这里设置需要和配置项内的屏幕尺寸相符合,例如config内的video尺寸为1080*1920，这里设置AVCaptureSessionPreset1920x1080
    session.sessionPreset = AVCaptureSessionPreset640x480;
    self.captureSession = session;
    
    //5.设置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //5.1自动变焦
    if([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
        if([device lockForConfiguration:nil]){
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
    }
    NSError *error = nil;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    //6.添加输出设备
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    self.captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [output setSampleBufferDelegate:self queue:self.captureQueue];
    //6.1kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange 表示原始数据的格式为YUV420
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey, nil];
    output.videoSettings = settings;
    output.alwaysDiscardsLateVideoFrames = YES;
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    //7.设置录制视频的方向
    AVCaptureConnection *connection = [output connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    //8.添加预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewLayer.frame = preview.bounds;
    [preview.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
    
    //9.开始捕捉
    [self.captureSession startRunning];
}

- (void)stopCapture {
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
    
    dispatch_sync(self.encodeQueue, ^{
        [self.encoder freeX264Resource];
    });
}

#pragma mark - 获取视频数据代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    dispatch_sync(self.encodeQueue, ^{
        [_encoder encoderToH264:sampleBuffer];
    });
    
}

#pragma mark - 获取沙盒文件
- (void)h264FilePath{
    // 1.获取沙盒路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sample.h264"];
    //2.设置编码文件保存路径
    [self.encoder setFilePath:filePath];
}

@end
