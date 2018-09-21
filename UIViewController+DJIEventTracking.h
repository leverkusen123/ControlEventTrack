//
//  UIViewController+DJIEventTracking.h
//  Pilot-iOS
//
//  Created by spy on 2018/8/31.
//  Copyright © 2018年 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJIEventTrackingData.h"


@interface UIViewController (DJIEventTracking)


@property (nonatomic, assign)   NSTimeInterval     dji_vcAppearTimestamp;
@property (nonatomic, assign)   NSTimeInterval     dji_vcDisappearTimestamp;
@property (nonatomic, assign)   NSTimeInterval     dji_vcInitTimestamp;
@property (nonatomic, assign)   NSTimeInterval     dji_vcDestroyTimestamp;
@end
