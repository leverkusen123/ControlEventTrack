//
//  UIViewController+DJIEventTracking.m
//  Pilot-iOS
//
//  Created by spy on 2018/8/31.
//  Copyright © 2018年 DJI. All rights reserved.
//

#import "UIViewController+DJIEventTracking.h"

#import <objc/runtime.h>

static char EventTrackingAppearTimestamp;
static char EventTrackingDisappearTimestamp;
static char EventTrackingInitTimestamp;
static char EventTrackingDestroyTimestamp;
@implementation UIViewController (DJIEventTracking)


#pragma mark -- 时间戳属性
- (void)setDji_vcAppearTimestamp:(NSTimeInterval)dji_vcAppearTimestamp {
    objc_setAssociatedObject(self, &EventTrackingAppearTimestamp, @(dji_vcAppearTimestamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSTimeInterval)dji_vcAppearTimestamp {
    NSNumber *num = objc_getAssociatedObject(self, &EventTrackingAppearTimestamp);
    return [num doubleValue];
}

- (void)setDji_vcDisappearTimestamp:(NSTimeInterval)dji_vcDisappearTimestamp {
    objc_setAssociatedObject(self, &EventTrackingDisappearTimestamp, @(dji_vcDisappearTimestamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)dji_vcDisappearTimestamp {
    NSNumber *num = objc_getAssociatedObject(self, &EventTrackingDisappearTimestamp);
    return [num doubleValue];
}

- (void)setDji_vcInitTimestamp:(NSTimeInterval)dji_vcInitTimestamp {
    objc_setAssociatedObject(self, &EventTrackingInitTimestamp, @(dji_vcInitTimestamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)dji_vcInitTimestamp {
    NSNumber *num = objc_getAssociatedObject(self, &EventTrackingInitTimestamp);
    return [num doubleValue];
}

- (void)setDji_vcDestroyTimestamp:(NSTimeInterval)dji_vcDestroyTimestamp {
    objc_setAssociatedObject(self, &EventTrackingDestroyTimestamp, @(dji_vcDestroyTimestamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)dji_vcDestroyTimestamp {
    NSNumber *num = objc_getAssociatedObject(self, &EventTrackingDestroyTimestamp);
    return [num doubleValue];
}

@end
