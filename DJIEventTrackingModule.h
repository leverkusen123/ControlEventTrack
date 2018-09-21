//
//  DJIEventTrackingModule.h
//  Pilot-iOS
//
//  Created by spy on 2018/8/31.
//  Copyright © 2018年 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DJIEventTrackingData.h"

@interface DJIEventTrackingModule : NSObject


/**
 启动 /关系 事件跟踪功能。

 @param enable BOOL
 */
+ (void)enableEventTracking:(BOOL)enable;


/**
 自定义 跟踪事件的回调处理方法。
 callback 会带着 DJIEventTrackingData 信息对象一起返回；外部可根据需要使用第三方平台来上报数据
 callback不会保证主线程回调

 @param callback callback
 */
+ (void)setEventTrackCallback:(void(^)(DJIEventTrackingData* data))callback;


/**
 触发了某个对象的 埋点事件

 @param object object
 */
+ (void)captureEventOfObject:(NSObject*)object;

@end
