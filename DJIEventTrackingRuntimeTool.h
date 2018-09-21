//
//  DJIEventTrackingRuntimeTool.h
//  Pilot-iOS
//
//  Created by spy on 2018/8/31.
//  Copyright © 2018年 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DJIEventTrackingRuntimeTool : NSObject

/**
 开始 hook相关的方法。
 非线程安全方法，请保证在主线程调用
 */
+ (void)startHooking;


/**
 还原 hook方法的IMP
 非线程安全方法，请保证在主线程调用
 */
+ (void)removeHook;

@end
