//
//  YWaterView.h
//  watermarkCamera
//
//  Created by ouyang151 on 2019/3/11.
//  Copyright © 2019年 ouyang151. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWaterView : UIView

@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UILabel      *timeLabel;
@property (nonatomic, strong) UIImageView  *addressIcon;
@property (nonatomic, strong) UILabel      *addressLabel;
@property (nonatomic, strong) UIImageView  *topImageView;
@property (nonatomic, strong) UIImageView  *erCodeImageView;
@property (nonatomic, strong) UILabel      *whileView;
@property (nonatomic, assign) BOOL isSuccess;

- (void)createErcodeImageview;
@end

NS_ASSUME_NONNULL_END
