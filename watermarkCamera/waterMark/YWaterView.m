//
//  YWaterView.m
//  watermarkCamera
//
//  Created by ouyang151 on 2019/3/11.
//  Copyright © 2019年 ouyang151. All rights reserved.
//

#import "YWaterView.h"
#import <Masonry/Masonry.h>
#import "QRCodeGenerator.h"
#import "AES128Util.h"

#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface YWaterView ()

@end

@implementation YWaterView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self createView];
    }
    return self;
}

- (void)getKey
{

}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.numberOfLines = 2;
    }
    return _addressLabel;
}
- (UIImageView *)addressIcon
{
    if (!_addressIcon) {
        _addressIcon = [[UIImageView alloc] init];
        _addressIcon.image = [UIImage imageNamed:@"camera_locate"];
    }
    return _addressIcon;
}
- (UIImageView *)topImageView
{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"topicWater"];
    }
    
    return _topImageView;
}

- (UIImageView *)erCodeImageView
{
    if (!_erCodeImageView) {
        _erCodeImageView = [[UIImageView alloc] init];
    }
    return _erCodeImageView;
}
- (UILabel *)whileView
{
    if (!_whileView) {
        _whileView = [[UILabel alloc] init];
    }
    return _whileView;
}

- (void)createView
{
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [self imageWithColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self addSubview:self.addressIcon];
    [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(13);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addressIcon.mas_right).offset(5);
        make.top.mas_equalTo(self.addressIcon.mas_top).offset(-2);
        make.right.mas_equalTo(-130);
    }];
    
    [self addSubview:self.timeLabel];
    self.timeLabel.text = @"2012.10.28";
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.addressIcon.mas_top).offset(-5);
    }];
    
    [self addSubview:self.nameLabel];
    
    self.nameLabel.text = @"数信";
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(-5);
    }];
    
    
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.whileView];
    self.whileView.backgroundColor = [UIColor whiteColor];
    [self.whileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.width.height.mas_equalTo(90);
    }];
    
    [self addSubview:self.erCodeImageView];
    [self.erCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whileView.mas_centerX);
        make.centerY.mas_equalTo(self.whileView.mas_centerY);
    }];
    self.addressIcon.image = [UIImage imageNamed:@"camera_unlocate"];
    self.addressLabel.text = @"定位获取失败";
    
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

- (UIImage *)imageWithColor{
    
    CGRect rect =CGRectMake(0.0f,0.0f,ScreenWidth,120);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//生成加密二维码
- (void)createErcodeImageview{
    
    
    NSString *str = @"123";
    NSString *encryptJsonStr =  [AES128Util AES128Encrypt:str key:@"key"];
    NSDictionary *describeDict = @{
                                   @"text":encryptJsonStr,
                                   @"version":@"0.1.0"
                                   };
    NSString *describeStr = [self convertToJsonData:describeDict];
    self.erCodeImageView.image = [QRCodeGenerator generateQRCodeImageWithString:describeStr imageSize:85];
    
}

// 字典转json字符串方法
-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

@end
