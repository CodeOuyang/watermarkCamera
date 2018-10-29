//
//  YLocationManager.h
//  watermarkCamera
//
//  Created by ouyang151 on 2018/10/29.
//  Copyright © 2018年 ouyang151. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface YLocationManager : NSObject

@property (nonatomic, weak) id<CLLocationManagerDelegate> delegate;
@property (nonatomic, copy) void (^locationsHandleBlock)(NSString *locality);
@property (nonatomic, copy) void (^locationsHandleError)(void);

@end
