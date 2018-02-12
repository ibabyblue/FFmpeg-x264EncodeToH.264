//
//  ViewController.m
//  FFmpeg+x264EncodeToH.264
//
//  Created by ibabyblue on 2018/2/11.
//  Copyright © 2018年 ibabyblue. All rights reserved.
//

#import "ViewController.h"
#import "BBVideoCapture.h"

@interface ViewController ()
@property (nonatomic, strong) BBVideoCapture *capture;
@end

@implementation ViewController

- (BBVideoCapture *)capture{
    if (_capture == nil) {
        _capture = [[BBVideoCapture alloc] init];
    }
    return _capture;
}

- (IBAction)start:(id)sender {
    [self.capture startCapture:self.view];
}
- (IBAction)stop:(id)sender {
    [self.capture stopCapture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
