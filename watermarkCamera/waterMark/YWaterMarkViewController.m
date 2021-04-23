//
//  YWaterMarkViewController.m
//  watermarkCamera
//
//  Created by ouyang151 on 2018/10/22.
//  Copyright © 2018年 ouyang151. All rights reserved.
//

#import "YWaterMarkViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YImageOverLayView.h"
#import "YPreImageView.h"
#import "UIView+Category.h"
#import "YWaterView.h"
#import "MADCGTransfromHelper.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define VKiPhoneX ([UIScreen mainScreen].bounds.size.height >= 812)

@interface YWaterMarkViewController ()<UIGestureRecognizerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, assign) CGFloat beginGestureScale;
@property (nonatomic, assign) CGFloat effectiveScale;
@property (nonatomic, assign) BOOL isUsingFrontFacingCamera;

@property (nonatomic, strong) YImageOverLayView *preview;
@property (nonatomic, strong) YPreImageView *preImageView;
@property (nonatomic, strong) YWaterView *waterView;
@property (nonatomic, strong) UIImage *markedImage;
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;


@end

@implementation YWaterMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configueUI];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)configueUI
{
    [self initAVCaptureSession];
    [self configGesture];
    [self configActions];
    
    _isUsingFrontFacingCamera = NO;
    self.effectiveScale = self.beginGestureScale = 1.0f;
}

- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    NSError *error;
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    
//    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
//    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
//    [self.stillImageOutput setOutputSettings:outputSettings];
    
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
       [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
//       [dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)}];
       [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
       [self.session addOutput:dataOutput];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
//    if ([self.session canAddOutput:self.stillImageOutput]) {
//        [self.session addOutput:self.stillImageOutput];
//    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    //    AVLayerVideoGravityResizeAspect
    
    self.preview = [[YImageOverLayView alloc] init];
    self.preview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.preview.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.preview];
    
    self.previewLayer.frame = CGRectMake(0, 0,ScreenWidth, ScreenHeight-120);
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.preview.buttomBar.frame = CGRectMake(0, self.view.height - 120, self.view.width, 120);
    //iPhoneX 适配
    if (VKiPhoneX) {
        self.preview.topbar.frame = CGRectMake(0, 30, self.view.width, 70);
    }else
    {
        self.preview.topbar.frame = CGRectMake(0, 0, self.view.width, 70);
    }
    //添加顶部以及底部的自定义工具条
    [self.view addSubview:self.preview.topbar];
    [self.view addSubview:self.preview.buttomBar];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 200)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor redColor];
    view.alpha = 0.5;
    [self.preview layoutSubviews];
    
    
    // 设置拍照后预览图层
    self.preImageView = [[YPreImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.preImageView.hidden = YES;
    [self.view addSubview:self.preImageView];
    
    YWaterView *waterView;
    if (VKiPhoneX) {
        waterView  = [[YWaterView alloc] initWithFrame:CGRectMake
                      (0, 64, ScreenWidth, ScreenHeight- 164)];
    }
    else {
        waterView = [[YWaterView alloc] initWithFrame:CGRectMake
                     (0, 0, ScreenWidth, ScreenHeight- 100)];
    }
    waterView.hidden = YES;
    _waterView = waterView;
    [self.view addSubview:waterView];
    
}

- (void)configGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self                                                                                action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.preview addGestureRecognizer:pinch];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(focusAction:)];
    [self.preview addGestureRecognizer:tap];
}

- (void)configActions{
    
    [self.preview.cameraSwitchButton addTarget:self action:@selector(switchCameraSegmentedControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashAutoButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashOpeanButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashCloseButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.takePictureButton addTarget:self action:@selector(takePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preview.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preImageView.reTakeButton addTarget:self action:@selector(retakeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preImageView.useImageButton addTarget:self action:@selector(useImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //    videoHDREnabled
}

#pragma mark Actions

- (void)focusAction:(UITapGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.preview];
    CGPoint pointInsect = CGPointMake(location.x / self.view.width, location.y / self.view.height);
    
    [self.preview.focusView setCenter:location];
    self.preview.focusView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.preview.focusView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.preview.focusView.alpha = 0.0;
        }completion:^(BOOL finished) {
            self.preview.focusView.hidden = YES;
        }];
    }];
    
    if ([self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([self.device lockForConfiguration:&error])
        {
            if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [self.device setFocusPointOfInterest:pointInsect];
            }
            
            if([self.device isExposurePointOfInterestSupported] && [self.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.device setExposurePointOfInterest:pointInsect];
                [self.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                
            }
            
            [self.device unlockForConfiguration];
        }
    }
    
}

//切换镜头
- (void)switchCameraSegmentedControlClick:(id)sender {
    
    AVCaptureDevicePosition desiredPosition;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (_isUsingFrontFacingCamera){
        
        if(device.isFlashAvailable) self.preview.flashButton.hidden = NO;
        desiredPosition = AVCaptureDevicePositionBack;
        
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
//        [self.preview reSetTopbar];
        self.preview.flashButton.hidden = YES;
        
    }
    
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    _isUsingFrontFacingCamera = !_isUsingFrontFacingCamera;
}

- (void)flashButtonClick:(UIButton *)sender {
    
    [self.preview chosedFlashButton:sender];

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        if([sender.titleLabel.text isEqualToString:@"打开"]){
            if([device isFlashModeSupported:AVCaptureFlashModeOn])
                [device setFlashMode:AVCaptureFlashModeOn];
        }else if ([sender.titleLabel.text isEqualToString:@"自动"]){
            if([device isFlashModeSupported:AVCaptureFlashModeAuto])
                [device setFlashMode:AVCaptureFlashModeAuto];
            
        }else if ([sender.titleLabel.text isEqualToString:@"关闭"]){
            if([device isFlashModeSupported:AVCaptureFlashModeOff])
                [device setFlashMode:AVCaptureFlashModeOff];
        }
    } else {
        
        NSLog(@"设备不支持闪光灯");
    }
    [device unlockForConfiguration];
}

- (void)takePhotoButtonClick:(id )sender
{
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (error) {
//            [SVProgressHUD showErrorTip:@"拍照失败,请重试!"];
            return;
        }
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.imageData = jpegData;
        
        UIImage *image = [UIImage imageWithData:jpegData];
        self.preImageView.imageView.image = image;
        [self.preview hiddenSelfAndBars:YES];
        self.preImageView.hidden = NO;
        self.waterView.hidden = NO;
        [self.waterView createErcodeImageview];
        return;
    }];

}

//上传水印图片
- (void)useImageButtonClick:(id )sender
{
    self.markedImage = [self productMarkedImage];
    _waterView.hidden = YES;
    if([self.delegate respondsToSelector:@selector(imagePickerControllerUseImage:image:)])
    {
        [self.delegate imagePickerControllerUseImage:self image:self.markedImage];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)cancelButtonClick:(id )sender{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
        [self.delegate imagePickerControllerDidCancel:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)retakeButtonClick:(id)sender{
    
    [self.preview hiddenSelfAndBars:NO];
    self.preImageView.hidden = YES;
    _waterView.hidden = YES;
    if([self.delegate respondsToSelector:@selector(imagePickerControllerRetakePhoto:)])
        [self.delegate imagePickerControllerRetakePhoto:self];
}



- (UIImage *)productMarkedImage
{
    
    UIImage *defaultImage = nil;
    
    CGSize newSize = CGSizeMake(_waterView.width, _waterView.height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    for (UIView *view in self.preImageView.subviews) {
        if([view isKindOfClass:[UIImageView class]]){
            UIImageView *iv = (UIImageView *)view;
            UIImage *ivImage = [iv imageByRenderingView];
            [ivImage drawInRect:CGRectMake(0,0,_waterView.width,_waterView.height)];
            
        }
        
    }
    for (UIView *view in _waterView.subviews) {
        if([view isKindOfClass:[UIImageView class]]){
            UIImageView *iv = (UIImageView *)view;
            UIImage *ivImage = [iv imageByRenderingView];
            [ivImage drawInRect:CGRectMake(iv.left,iv.top, iv.width, iv.height)];
            
        }
        else if ([view isKindOfClass:[UILabel class]]){
            UILabel *lb = (UILabel *)view;
            UIImage *lbImage = [lb imageByRenderingView];
            [lbImage drawInRect:CGRectMake(lb.left, lb.top, lb.width, lb.height)];
        }
        
    }
    
    CGContextRestoreGState(context);
    defaultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return defaultImage;
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.preview];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if (allTouchesAreOnThePreviewLayer) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    image = [self filteredImageUsingContrastFilterOnImage:image];
    
    NSArray <CIFeature *>*features = [[self highAccuracyRectangleDetector] featuresInImage:image];
    CIRectangleFeature *borderDetectLastRectangleFeature = [self biggestRectangleInRectangles:features];
       // 将图像空间的坐标系转换成uikit坐标系
        TransformCIFeatureRect featureRect = [self transfromRealRectWithImageRect:image.extent topLeft:borderDetectLastRectangleFeature.topLeft topRight:borderDetectLastRectangleFeature.topRight bottomLeft:borderDetectLastRectangleFeature.bottomLeft bottomRight:borderDetectLastRectangleFeature.bottomRight];
    NSLog(@"topLeft%@ topRight%@ bottomRight%@ bottomLeft%@",NSStringFromCGPoint(featureRect.topLeft),NSStringFromCGPoint(featureRect.topRight),NSStringFromCGPoint(featureRect.bottomRight),NSStringFromCGPoint(featureRect.bottomLeft));
}

- (CIImage *)filteredImageUsingContrastFilterOnImage:(CIImage *)image
{
    return [CIFilter filterWithName:@"CIColorControls" withInputParameters:@{@"inputContrast":@(1.1),kCIInputImageKey:image}].outputImage;
}

// 选取feagure rectangles中最大的矩形
- (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles
{
    if (![rectangles count]) return nil;
    
    float halfPerimiterValue = 0;
    
    CIRectangleFeature *biggestRectangle = [rectangles firstObject];
    
    for (CIRectangleFeature *rect in rectangles)
    {
        CGPoint p1 = rect.topLeft;
        CGPoint p2 = rect.topRight;
        CGFloat width = hypotf(p1.x - p2.x, p1.y - p2.y);
        
        CGPoint p3 = rect.topLeft;
        CGPoint p4 = rect.bottomLeft;
        CGFloat height = hypotf(p3.x - p4.x, p3.y - p4.y);
        
        CGFloat currentHalfPerimiterValue = height + width;
        
        if (halfPerimiterValue < currentHalfPerimiterValue)
        {
            halfPerimiterValue = currentHalfPerimiterValue;
            biggestRectangle = rect;
        }
    }
    
    return biggestRectangle;
}

// 高精度边缘识别器
- (CIDetector *)highAccuracyRectangleDetector
{

    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
                  });
    return detector;
}

/// 坐标系转换
- (TransformCIFeatureRect)transfromRealRectWithImageRect:(CGRect)imageRect topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight
{
    CGRect previewRect = self.view.frame;
    
    return [MADCGTransfromHelper transfromRealCIRectInPreviewRect:previewRect imageRect:imageRect topLeft:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight];
}

@end
