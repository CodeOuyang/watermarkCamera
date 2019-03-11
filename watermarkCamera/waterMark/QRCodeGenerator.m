//
//  QRCodeGenerator.m
//  VKStaffAssistant
//
//  Created by wolfire on 11/2/15.
//  Copyright © 2015. All rights reserved.
//

#import "QRCodeGenerator.h"

#define QRIMAGE_MARGN           3

@implementation QRCodeGenerator

+ (UIImage *)generateQRCodeImageWithString:(NSString *)codeString
                                 imageSize:(CGFloat)size {
    if (codeString == nil || codeString == 0) {
        return nil;
    }
    
    return [QRCodeGenerator createCIQRCode:codeString sideLength:size];
}

#pragma mark -

+ (UIImage *)createCIQRCode:(NSString *)strInfo sideLength:(CGFloat)sideLength
{
    if (strInfo.length < 1) {
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    UIImage *image = [QRCodeGenerator createNonInterpolatedUIImageFormCIImage:outputImage
                                                                     withSize:sideLength];
    
    return image;
}//

// 改变二维码大小
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil,
                                                   width,
                                                   height,
                                                   8,
                                                   0,
                                                   cs,
                                                   (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    // remove a potential leak analysis warning
    // modify by mark 17-09-14
    CGColorSpaceRelease(cs);
    UIImage *returnImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    
    return returnImage;
    // end modify
}

@end
