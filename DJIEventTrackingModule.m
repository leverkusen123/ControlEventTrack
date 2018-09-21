//
//  DJIEventTrackingModule.m
//  Pilot-iOS
//
//  Created by spy on 2018/8/31.
//  Copyright © 2018年 DJI. All rights reserved.
//

#import "DJIEventTrackingModule.h"

#import "DJIEventTrackingRuntimeTool.h"
#import "UIViewController+DJIEventTracking.h"


static void(^EventTrackCallback)(DJIEventTrackingData *data) = NULL;

@implementation DJIEventTrackingModule


+ (void)enableEventTracking:(BOOL)enable {
    if (enable) {
        [DJIEventTrackingRuntimeTool startHooking];
    }
    else {
        [DJIEventTrackingRuntimeTool removeHook];
    }
}


+ (void)setEventTrackCallback:(void(^)(DJIEventTrackingData* data))callback {
    EventTrackCallback = callback;
}


+ (void)captureEventOfObject:(NSObject*)object {
    //有 需要上报的数据对象
    DJIEventTrackingData *trackingData = [self findTrackingData:object];
    if (trackingData) {
        //UIViewController 需要获取 停留时间和 生命周期
        if ([object isKindOfClass:[UIViewController class]]) {
            trackingData.pageStayTime = ((UIViewController*)object).dji_vcDisappearTimestamp - ((UIViewController*)object).dji_vcAppearTimestamp;
            if (((UIViewController*)object).dji_vcDestroyTimestamp > 0) {
                trackingData.pageLifeTime = ((UIViewController*)object).dji_vcDestroyTimestamp - ((UIViewController*)object).dji_vcInitTimestamp;
            }
        }
        //将上报对象回调
        if (EventTrackCallback) {
            EventTrackCallback(trackingData);
        }
    }
}

#pragma mark -- Private API
+ (DJIEventTrackingData*)findTrackingData:(NSObject*)object {
    
    if ([object isKindOfClass:[UITapGestureRecognizer class]]) {
        //tap gesture, 既要检查 Gesture的，也要检查对应view的
        return object.dji_eventTrackingData?:((UITapGestureRecognizer*)object).view.dji_eventTrackingData;
    }
    
    return object.dji_eventTrackingData;
    
}

@end
