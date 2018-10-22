//
//  YImageOverLayView.h
//  watermarkCamera
//
//  Created by ouyang151 on 2018/10/22.
//  Copyright © 2018年 ouyang151. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YImageOverLayView : UIView

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *takePictureButton;
@property (nonatomic, strong) UIImageView *imageLibraryView;
@property (nonatomic, strong) UIView   *buttomBar;

@property (nonatomic, strong) UIImageView   *focusView;

@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *flashAutoButton;
@property (nonatomic, strong) UIButton *flashOpeanButton;
@property (nonatomic, strong) UIButton *flashCloseButton;

@property (nonatomic, strong) UIButton *HDRButton;

@property (nonatomic, strong) UIButton *cameraSwitchButton;
@property (nonatomic, strong) UIView   *topbar;

@property (nonatomic, assign) BOOL      isHiddenFlashButtons;

@end
