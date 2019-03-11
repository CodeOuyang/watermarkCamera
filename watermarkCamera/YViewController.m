//
//  YViewController.m
//  watermarkCamera
//
//  Created by ouyang151 on 2019/3/11.
//  Copyright © 2019年 ouyang151. All rights reserved.
//

#import "YViewController.h"
#import "YWaterMarkViewController.h"

@interface YViewController ()<YWaterMarkViewControllerDelegate>

@end

@implementation YViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)camera:(id)sender {
    
    // 调取水印相机
    if (![self cameraAuthorized]) {
        return;
    }
    YWaterMarkViewController *picker = [[YWaterMarkViewController alloc] init];
    picker.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (BOOL)cameraAuthorized
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted ||
            authStatus == AVAuthorizationStatusDenied) {
            // 访问受限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"访问受限"
                                                            message:@"请前往“设置”中允许“助英台”访问您的相机"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"设置", nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (void)imagePickerControllerUseImage:(YWaterMarkViewController *)picker image:(UIImage *)image
{
    NSLog(@"上传图片");
}


@end
