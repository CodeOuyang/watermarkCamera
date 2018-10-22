//
//  waterMarkViewController.m
//  watermarkCamera
//
//  Created by ouyang151 on 2018/10/22.
//  Copyright © 2018年 ouyang151. All rights reserved.
//

#import "waterMarkViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YImageOverLayView.h"
#import "YPreImageView.h"
#import "UIView+Category.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface waterMarkViewController ()

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic, strong) AVCaptureSession* session;

@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) AVCaptureDevice             *device;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@property(nonatomic,assign) CGFloat beginGestureScale;

@property(nonatomic,assign) CGFloat effectiveScale;

@property(nonatomic,assign) BOOL isUsingFrontFacingCamera;
@property (nonatomic, strong) YImageOverLayView *preview;
@property (nonatomic, strong) YPreImageView *preImageView;

@end

@implementation waterMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configueUI];
}

- (void)configueUI
{
    [self initAVCaptureSession];
    
//    [self configGesture];
//
//    [self configActions];
    
    
    
    _isUsingFrontFacingCamera = NO;
    
    self.effectiveScale = self.beginGestureScale = 1.0f;
}

- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    NSError *error;
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    //    AVLayerVideoGravityResizeAspect
    
    self.preview = [[YImageOverLayView alloc] init];
    self.preview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.preview.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.preview];
    
        self.previewLayer.frame = CGRectMake(0, 0,ScreenWidth, ScreenHeight-120);
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        self.preview.topbar.frame = CGRectMake(0, 0, self.view.width, 64 * ScreenWidth/320.0);
        self.preview.buttomBar.frame = CGRectMake(0, self.view.height - 120, self.view.width, 120);
    
    //添加顶部以及底部的自定义工具条
    [self.view addSubview:self.preview.topbar];
    [self.view addSubview:self.preview.buttomBar];
    [self.preview layoutSubviews];
    
 
    // 设置拍照后预览图层
    self.preImageView = [[YPreImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.preImageView.hidden = YES;
    [self.view addSubview:self.preImageView];
    
}

@end
