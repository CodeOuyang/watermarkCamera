//
//  YWaterMarkViewController.h
//  watermarkCamera
//
//  Created by ouyang151 on 2018/10/22.
//  Copyright © 2018年 ouyang151. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPreImageView.h"
#import "YImageOverLayView.h"

@class YWaterMarkViewController;
@protocol YWaterMarkViewControllerDelegate <NSObject>

@optional
- (void)imagePickerControllerDidCancel:(YWaterMarkViewController *)picker;
- (void)imagePickerControllerRetakePhoto:(YWaterMarkViewController *)picker;
- (void)imagePickerControllerUseImage:(YWaterMarkViewController *)picker image:(UIImage *)image;
- (void)imagePickerControllerUseAlbumImage:(YWaterMarkViewController *)picker image:(UIImage *)image;
@end

@interface YWaterMarkViewController : UIViewController

@property (nonatomic, strong)NSData *imageData;
@property (nonatomic , weak) id<YWaterMarkViewControllerDelegate>delegate;

@end
