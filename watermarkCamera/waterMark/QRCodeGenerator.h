//
//  QRCodeGenerator.h
//  VKStaffAssistant
//
//  Created by wolfire on 11/2/15.
//  Copyright © 2015 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeGenerator : NSObject

+ (UIImage *)generateQRCodeImageWithString:(NSString *)codeString imageSize:(CGFloat)size;

@end
