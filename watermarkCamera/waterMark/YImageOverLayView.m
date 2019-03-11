//
//  YImageOverLayView.m
//  watermarkCamera
//
//  Created by ouyang151 on 2018/10/22.
//  Copyright © 2018年 ouyang151. All rights reserved.
//

#import "YImageOverLayView.h"
#import "UIView+Category.h"

#define RGB(r,g,b,a) [UIColor \
colorWithRed:r/255.0 \
green:g/255.0 \
blue:b/255.0 alpha:a]

@implementation YImageOverLayView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self config];
    }
    
    return self;
}

- (void)config{
    
    self.backgroundColor = [UIColor blackColor];
    
    [self buttomBar];
    [self cancelButton];
    [self photoAlbumButton];
    [self takePictureButton];
    [self topbar];
    [self cameraSwitchButton];
    [self flashButton];
    [self flashAutoButton];
    [self flashOpeanButton];
    [self flashCloseButton];
    [self reSetTopbar];
}

- (void)layoutSubviews{
    
    _flashButton.frame = CGRectMake(10, 11, 40, 40);
    _flashButton.centerY = _topbar.height / 2.0;
    
    _flashAutoButton.size = CGSizeMake(60, _topbar.height);
    _flashAutoButton.left = _flashButton.right + 20;
    _flashAutoButton.centerY = _topbar.height / 2.0;
    
    _flashOpeanButton.size = CGSizeMake(60, _topbar.height);
    _flashOpeanButton.centerY = _topbar.height / 2.0;
    _flashOpeanButton.left = _flashAutoButton.right + 20;
    
    _flashCloseButton.size = CGSizeMake(60, _topbar.height);
    _flashCloseButton.centerY = _topbar.height / 2.0;
    _flashCloseButton.left = _flashOpeanButton.right + 20;
    
    _cameraSwitchButton.frame =  CGRectMake(self.width - 40, 7, 30, 25);
    _cameraSwitchButton.centerY = _topbar.height / 2.0;

    
    
    
    _imageLibraryView.frame = CGRectMake(10, 0, 55, 55);
    _imageLibraryView.centerY = _buttomBar.height / 2.0;
    
    _takePictureButton.centerX = _buttomBar.width / 2.0;
    _takePictureButton.centerY = _buttomBar.height / 2.0;
    _takePictureButton.width = 75;
    _takePictureButton.height = 75;
    _cancelButton.frame = CGRectMake(45, 0, 45, 45);
    _cancelButton.centerY = _buttomBar.height / 2.0 + 6;
    
    _photoAlbumButton.left = self.width  - 90;
    _photoAlbumButton.centerY = _buttomBar.height / 2.0;
    _photoAlbumButton.width = 45;
    _photoAlbumButton.height = 45;
    
    _buttomBar.backgroundColor = [UIColor whiteColor];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    [_takePictureButton setBackgroundImage:[UIImage imageNamed:@"camera_Photo"] forState:UIControlStateNormal];
    [_photoAlbumButton setBackgroundImage:[UIImage imageNamed:@"photo_album"] forState:UIControlStateNormal];
    
}


- (void)reSetTopbar{
    self.isHiddenFlashButtons = YES;
    _flashOpeanButton.hidden = YES;
    _flashCloseButton.hidden = YES;
    _flashAutoButton.hidden  = YES;
    _cameraSwitchButton.hidden = NO;
}

- (void)setFlashModel:(AVCaptureFlashMode)mode{
    if(mode == AVCaptureFlashModeOff){
        [self.flashCloseButton setTitleColor:RGB(252, 149, 73, 1.0) forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"camera_light_c"] forState:UIControlStateNormal];
    }else if (mode == AVCaptureFlashModeOn){
        [self.flashOpeanButton setTitleColor:RGB(252, 149, 73, 1.0) forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"camera_light_n"] forState:UIControlStateNormal];
    }else if (mode == AVCaptureFlashModeAuto){
        [self.flashAutoButton setTitleColor:RGB(252, 149, 73, 1.0) forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"camera_light_o"] forState:UIControlStateNormal];
    }
}

- (void)chosedFlashButton:(UIButton *)btn{
    [btn setTitleColor:RGB(252, 149, 73, 1.0) forState:UIControlStateNormal];
    if([btn.titleLabel.text isEqualToString:@"自动"]){
        [self.flashCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.flashOpeanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"camera_light_o"] forState:UIControlStateNormal];
    }
    else if ([btn.titleLabel.text isEqualToString:@"打开"])
    {
        [self.flashAutoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.flashCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"camera_light_n"] forState:UIControlStateNormal];
    }
    else if ([btn.titleLabel.text isEqualToString:@"关闭"])
    {
        [self.flashAutoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.flashOpeanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"camera_light_c"] forState:UIControlStateNormal];
    }
}

#pragma mark Private Methods
- (void)hiddenSelfAndBars:(BOOL)hidden{
    self.hidden = hidden;
    self.topbar.hidden = hidden;
    self.buttomBar.hidden = hidden;
}

- (void)p_setFlashButtonsHidden{
    self.isHiddenFlashButtons = NO;
    _flashOpeanButton.hidden = NO;
    _flashAutoButton.hidden = NO;
    _flashCloseButton.hidden = NO;
}

#pragma Actions
- (void)flashButtonClick:(id )sender{
    if(self.isHiddenFlashButtons ){
        [self p_setFlashButtonsHidden];
        _cameraSwitchButton.hidden = YES;
    }else{
        [self reSetTopbar];
    }
}

#pragma mark - setters && getters
- (UIView *)buttomBar{
    if(_buttomBar == nil){
        _buttomBar = [[UIView alloc] init];
        [self addSubview:_buttomBar];
    }
    return _buttomBar;
}

- (UIButton *)cancelButton{
    if(_cancelButton == nil){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttomBar addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIButton *)takePictureButton{
    if(_takePictureButton == nil){
        _takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttomBar addSubview:_takePictureButton];
    }
    
    return _takePictureButton;
}

- (UIButton *)photoAlbumButton{
    if(_photoAlbumButton == nil){
        _photoAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [photoAlbumButton addTarget:self
//                             action:@selector(photoAlbumButtonClick:)
//                   forControlEvents:UIControlEventTouchUpInside];
        [_buttomBar addSubview:_photoAlbumButton];
    }
    
    return _photoAlbumButton;
}


- (UIImageView *)imageLibraryView{
    if(_imageLibraryView == nil){
        _imageLibraryView = [[UIImageView alloc] init];
        _imageLibraryView.userInteractionEnabled = YES;
        [_buttomBar addSubview:_imageLibraryView];
    }
    
    return _imageLibraryView;
}

- (UIView *)topbar{
    if(_topbar == nil){
        _topbar = [[UIView alloc] init];
        _topbar.backgroundColor = [UIColor clearColor];
        [self addSubview:_topbar];
    }
    
    return _topbar;
}

- (UIButton *)flashButton{
    if(_flashButton == nil){
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setImage:[UIImage imageNamed:@"camera_light_c"]
                      forState:UIControlStateNormal];
        [_flashButton addTarget:self action:@selector(flashButtonClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [_topbar addSubview:_flashButton];
    }
    
    return _flashButton;
}

- (UIButton *)flashAutoButton{
    if(_flashAutoButton == nil){
        _flashAutoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashAutoButton setTitle:@"自动" forState:UIControlStateNormal];
        [_flashAutoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topbar addSubview:_flashAutoButton];
    }
    
    return _flashAutoButton;
    
}

- (UIButton *)flashOpeanButton{
    if(_flashOpeanButton == nil){
        _flashOpeanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // @"打开"
        [_flashOpeanButton setTitle:@"打开" forState:UIControlStateNormal];
        [_flashAutoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topbar addSubview:_flashOpeanButton];
    }
    
    return _flashOpeanButton;
    
}

- (UIButton *)flashCloseButton{
    if(_flashCloseButton == nil){
        _flashCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // @"关闭"
        [_flashCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_flashAutoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_topbar addSubview:_flashCloseButton];
    }
    
    return _flashCloseButton;
    
}

- (UIButton *)cameraSwitchButton{
    if(_cameraSwitchButton == nil){
        _cameraSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraSwitchButton setImage:[UIImage imageNamed:@"camera_switch"] forState:UIControlStateNormal];
        [_topbar addSubview:_cameraSwitchButton];
    }
    
    return _cameraSwitchButton;
    
}

- (UIImageView *)focusView{
    if(_focusView == nil){
        _focusView = [[UIImageView alloc] init];
        _focusView.frame = CGRectMake(0, 0, 80, 80);
        _focusView.layer.borderColor = RGB(252, 208, 52, 1.0).CGColor;
        _focusView.layer.borderWidth = 2.0f;
        _focusView.hidden = YES;
        _focusView.alpha = 0.0;
        [self addSubview:_focusView];
    }
    
    return _focusView;
}

@end
