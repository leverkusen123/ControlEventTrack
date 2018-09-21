//
//  DJIEventTrackingData.m
//  Pilot-iOS
//
//  Created by spy on 2018/8/31.
//  Copyright © 2018年 DJI. All rights reserved.
//

#import "DJIEventTrackingData.h"

#import <objc/runtime.h>

@implementation DJIEventTrackingData


+ (instancetype)trackingDataWithBusinessId:(NSString*)businessId {
    DJIEventTrackingData *data = [DJIEventTrackingData new];
    data.businessId = businessId;
    return data;
}


+ (instancetype)trackingDataWithBusinessId:(NSString*)businessId
                                   eventId:(NSString*)eventId {
    DJIEventTrackingData *data = [DJIEventTrackingData new];
    data.businessId = businessId;
    data.eventId = eventId;
    return data;
}


+ (instancetype)trackingDataWithBusinessId:(NSString*)businessId
                                   eventId:(NSString*)eventId
                                extraParam:(NSDictionary*)extraParam {
    DJIEventTrackingData *data = [DJIEventTrackingData new];
    data.businessId = businessId;
    data.eventId = eventId;
    data.extraParam  = extraParam;
    return data;
}

@end


static char EventTrackingDataStayTime;
static char EventTrackingDataLifeTime;

@implementation DJIEventTrackingData (UIViewController)
- (NSTimeInterval)pageStayTime
{
    NSNumber *num = objc_getAssociatedObject(self, &EventTrackingDataStayTime);
    return [num doubleValue];
}

- (void)setPageStayTime:(NSTimeInterval)pageStayTime
{
    [self willChangeValueForKey:@"pageStayTime"];
    objc_setAssociatedObject(self, &EventTrackingDataStayTime, @(pageStayTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pageStayTime"];
}

- (NSTimeInterval)pageLifeTime
{
    NSNumber *num = objc_getAssociatedObject(self, &EventTrackingDataLifeTime);
    return [num doubleValue];
}

- (void)setPageLifeTime:(NSTimeInterval)pageLifeTime
{
    [self willChangeValueForKey:@"pageLifeTime"];
    objc_setAssociatedObject(self, &EventTrackingDataLifeTime, @(pageLifeTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pageLifeTime"];
}


@end


static char EventTrackingDataDescription;

@implementation NSObject (DJIEventTracking)
- (id)dji_eventTrackingData
{
    return objc_getAssociatedObject(self, &EventTrackingDataDescription);
}

- (void)setDji_eventTrackingData:(DJIEventTrackingData *)dji_eventTrackingData
{
    [self willChangeValueForKey:@"dji_eventTrackingData"];
    objc_setAssociatedObject(self, &EventTrackingDataDescription, dji_eventTrackingData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"dji_eventTrackingData"];
    //其他递归逻辑，主要针对 UIView类型，需要把 trackingData 传递给所有子view，以让它们的相关事件也能触发上传逻辑
    if ([self isKindOfClass:[UIView class]]) {
        for (UIView *subView in ((UIView*)self).subviews) {
            //递归操作不能覆盖原 trackingData
            if (!subView.dji_eventTrackingData) {
                subView.dji_eventTrackingData = dji_eventTrackingData;
            }
        }
    }
}


@end
