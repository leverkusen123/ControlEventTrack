//
//  DJIEventTrackingData.h
//  Pilot-iOS
//
//  Created by spy on 2018/8/31.
//  Copyright © 2018年 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJIEventTrackingData : NSObject

/**
 预留字段1， 一般用于标识 主业务模块
 */
@property (nonatomic, strong)   NSString    *businessId;
/**
 预留字段2， 一般用于标识 事件类型
 */
@property (nonatomic, strong)   NSString    *eventId;
/**
 预留字段3， 其他参数可以放里面
 */
@property (nonatomic, strong)   NSDictionary    *extraParam;


/**
 构造方法

 @param businessId businessId
 @return return value description
 */
+ (instancetype)trackingDataWithBusinessId:(NSString*)businessId;


+ (instancetype)trackingDataWithBusinessId:(NSString*)businessId
                                   eventId:(NSString*)eventId;


+ (instancetype)trackingDataWithBusinessId:(NSString*)businessId
                                   eventId:(NSString*)eventId
                                extraParam:(NSDictionary*)extraParam;

@end

@interface DJIEventTrackingData (UIViewController)

/**
 appear 到 disappear的时长
 */
@property (nonatomic, assign)   NSTimeInterval      pageStayTime;

/**
从创建到销毁的 时长
 */
@property (nonatomic, assign)   NSTimeInterval      pageLifeTime;


@end



/**
 扩展 NSObject的property
 */
@interface NSObject (DJIEventTracking)


@property (nonatomic, strong)  DJIEventTrackingData  *dji_eventTrackingData;
@end
