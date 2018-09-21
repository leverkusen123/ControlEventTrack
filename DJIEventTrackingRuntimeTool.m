//
//  DJIEventTrackingRuntimeTool.m
//  Pilot-iOS
//
//  Created by spy on 2018/8/31.
//  Copyright © 2018年 DJI. All rights reserved.
//

#import "DJIEventTrackingRuntimeTool.h"

#import "UIViewController+DJIEventTracking.h"
#import "DJIEventTrackingModule.h"

#import <objc/runtime.h>
#import <objc/message.h>

static BOOL  impChanged = NO;


@implementation UIViewController (EventTrackingHook)

- (void)eventTracking_viewDidLoad {
    self.dji_vcInitTimestamp = [[NSDate date] timeIntervalSince1970];
    
    [self eventTracking_viewDidLoad];
}
- (void)eventTracking_dealloc {
    self.dji_vcDestroyTimestamp = [[NSDate date] timeIntervalSince1970];
    [DJIEventTrackingModule captureEventOfObject:self];
    
    [self eventTracking_dealloc];
}


- (void)eventTracking_viewWillAppear:(BOOL)animated {
    self.dji_vcAppearTimestamp = [[NSDate date] timeIntervalSince1970];
    [self eventTracking_viewWillAppear:animated];
    
}
- (void)eventTracking_viewWillDisappear:(BOOL)animated {
    [self eventTracking_viewWillDisappear:animated];
    self.dji_vcDisappearTimestamp = [[NSDate date] timeIntervalSince1970];
    [DJIEventTrackingModule captureEventOfObject:self];
}

@end


@implementation UIControl (EventTrackingHook)

- (void)eventTracking_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self eventTracking_sendAction:action to:target forEvent:event];
    
    [DJIEventTrackingModule captureEventOfObject:self];
}
@end

@implementation UITapGestureRecognizer (EventTrackingHook)

- (instancetype)eventTracking_initWithTarget:(id)target action:(SEL)action {
    typeof(self) instance = [self eventTracking_initWithTarget:target action:action];
    if (!target && !action) {
        return instance;
    }
    
    //为target新增一个方法来替换这个action，用以截获 tap事件并转发
    Class class = [target class];
    
    SEL originalSEL = action;
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"eventTracking_%@", NSStringFromSelector(action)]);
    BOOL isAddMethod = class_addMethod(class, swizzledSEL, (IMP)replace_gestureAction, "v@:@");
    if (isAddMethod) {
        Method originalMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

    return instance;
}
void replace_gestureAction(id self, SEL _cmd, id sender) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"eventTracking_%@", NSStringFromSelector(_cmd)]);
    ((void( *)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);
    //
    [DJIEventTrackingModule captureEventOfObject:sender];
}

@end

@implementation UITableView (EventTrackingHook)

- (void)eventTracking_setDelegate:(id<UIScrollViewDelegate>)delegate {
    [self eventTracking_setDelegate:delegate];
    
    //替换 TableView和 CollectionView 的delegate 的 didSelect事件
    if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        if (class_addMethod([delegate class], NSSelectorFromString(@"eventTracking_tableView:didSelectRowAtIndexPath:"), (IMP)replace_tableViewDidSelectRowAtIndexPath, "v@:@@")) {
            Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"eventTracking_tableView:didSelectRowAtIndexPath:"));
            Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:));
            
            method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
        }
    }
}

void replace_tableViewDidSelectRowAtIndexPath(id self, SEL _cmd, UITableView* tableView, NSIndexPath * indexPath) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"eventTracking_%@", NSStringFromSelector(_cmd)]);
    ((void( *)(id, SEL, id, id))objc_msgSend)(self, swizzledSEL, tableView, indexPath);
    //
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [DJIEventTrackingModule captureEventOfObject:cell];
}
@end

@implementation UICollectionView (EventTrackingHook)
- (void)eventTracking_setDelegate:(id<UIScrollViewDelegate>)delegate {
    [self eventTracking_setDelegate:delegate];
    
    //替换 TableView和 CollectionView 的delegate 的 didSelect事件
    if ([delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        if (class_addMethod([delegate class], NSSelectorFromString(@"eventTracking_collectionView:didSelectItemAtIndexPath:"), (IMP)replace_colletionViewdidSelectItemAtIndexPath, "v@:@@")) {
            Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"eventTracking_collectionView:didSelectItemAtIndexPath:"));
            Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(collectionView:didSelectItemAtIndexPath:));
            
            method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
        }
    }
}


void replace_colletionViewdidSelectItemAtIndexPath(id self, SEL _cmd, UICollectionView* collectionView, NSIndexPath * indexPath) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"eventTracking_%@", NSStringFromSelector(_cmd)]);
    ((void( *)(id, SEL, id, id))objc_msgSend)(self, swizzledSEL, collectionView, indexPath);
    //
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [DJIEventTrackingModule captureEventOfObject:cell];
}

@end

@implementation DJIEventTrackingRuntimeTool

+ (IMP)exchangeMethodImp:(NSString*)selName forClass:(Class)cls {
    Method originalMethod = class_getInstanceMethod(cls, NSSelectorFromString(selName));
    Method newMethod = class_getInstanceMethod(cls, NSSelectorFromString([@"eventTracking_" stringByAppendingString:selName]));
    if (originalMethod) {
        IMP retIMP = method_getImplementation(originalMethod);
        method_exchangeImplementations(originalMethod, newMethod);
        return retIMP;
    }
    return NULL;
}

+ (void)startHooking {
    if (!impChanged) {
        [self exchangeAllIMP];
        
        impChanged = YES;
    }
}

+ (void)removeHook {
    if (impChanged) {
        [self exchangeAllIMP];
        
        impChanged = NO;
    }
}

+ (void)exchangeAllIMP {
    [self exchangeMethodImp:@"viewDidLoad" forClass:[UIViewController class]];
    [self exchangeMethodImp:@"dealloc" forClass:[UIViewController class]];
    [self exchangeMethodImp:@"viewWillAppear:" forClass:[UIViewController class]];
    [self exchangeMethodImp:@"viewWillDisappear:" forClass:[UIViewController class]];
    
    [self exchangeMethodImp:@"sendAction:to:forEvent:" forClass:[UIControl class]];
    
    
    [self exchangeMethodImp:@"initWithTarget:action:" forClass:[UITapGestureRecognizer class]];
    
    
    [self exchangeMethodImp:@"setDelegate:" forClass:[UITableView class]];
    [self exchangeMethodImp:@"setDelegate:" forClass:[UICollectionView class]];
    
}

@end
