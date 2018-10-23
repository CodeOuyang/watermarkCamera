//
//  YPreImageView.m
//  watermarkCamera
//
//  Created by ouyang151 on 2018/10/22.
//  Copyright © 2018年 ouyang151. All rights reserved.
//

#import "YPreImageView.h"
#import "UIView+Category.h"

@implementation YPreImageView
- (instancetype)init{
    if(self = [super init]){
        [self p_cofigSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self p_cofigSubViews];
    }
    
    return self;
}

- (void)p_cofigSubViews{
    [self reTakeButton];
    [self useImageButton];
    [self imageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 40, self.width, self.height - 120 - 40);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    CGFloat HMagin = (self.width - 90) / 3;
    self.reTakeButton.frame = CGRectMake(HMagin,self.height - 90,45,61);
    self.useImageButton.frame = CGRectMake(HMagin*2 + 45,self.height - 90,45,61);
    [_useImageButton setBackgroundImage:[UIImage imageNamed:@"camera_ensure"] forState:UIControlStateNormal];
    [_reTakeButton setBackgroundImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor whiteColor];
}

- (UIButton *)reTakeButton{
    if(_reTakeButton == nil){
        _reTakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_reTakeButton];
    }
    
    return _reTakeButton;
}

- (UIButton *)useImageButton{
    if(_useImageButton == nil){
        _useImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // @"使用照片"
        [self addSubview:_useImageButton];
        
    }
    
    return _useImageButton;
}

- (UIImageView *)imageView{
    if(_imageView == nil){
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}


@end
