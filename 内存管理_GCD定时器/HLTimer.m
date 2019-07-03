//
//  HLTimer.m
//  内存管理_GCD定时器
//
//  Created by BaoHenglin on 2019/7/3.
//  Copyright © 2019 BaoHenglin. All rights reserved.
//

#import "HLTimer.h"

@implementation HLTimer
static NSMutableDictionary *timersDic;
dispatch_semaphore_t semaphore_;
//initialize方法一般只在第一次用到该类时调用一次，但是某些情况下可能会调用多次
+ (void)initialize
{
    //为了确保只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timersDic = [NSMutableDictionary dictionary];
        //有可能有多条线程同时对全局字典timersDic，进行操作，所以需要处理多线程读写安全问题。
        //用于实现线程同步
        semaphore_ = dispatch_semaphore_create(1);
    });
}
+ (NSString *)executeTask:(void(^)(void))task
              start:(NSTimeInterval)start
           interval:(NSTimeInterval)interval
            repeats:(BOOL)repeats
              async:(BOOL)async
{
    
    if (!task || start < 0 || (repeats && interval <= 0)) return nil;
    dispatch_queue_t queue = async ? dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL) : dispatch_get_main_queue();
    //创建GCD定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置时间
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    //生成定时器的唯一标识
    NSString *timerIdentifier = [NSString stringWithFormat:@"%zd",(unsigned long)timersDic.count];
    //将定时器存储到字典中
    timersDic[timerIdentifier] = timer;
    dispatch_semaphore_signal(semaphore_);
    
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            //不重复执行任务
            [self cancelTimerTaskWithIdentifier:timerIdentifier];
        }
    });
    //启动定时器
    dispatch_resume(timer);
    //返回定时器唯一标识
    return timerIdentifier;
}
+ (NSString *)executeTask:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async
{
    if (!target || !selector) return nil;
    return [self executeTask:^{
        if ([target respondsToSelector:selector]) {
//强制消除Xcode警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
            
        }
    } start:start interval:interval repeats:repeats async:async];
}
/**
 取消定时器

 @param identifier 定时器唯一标识符
 */
+ (void)cancelTimerTaskWithIdentifier:(NSString *)identifier
{
    if (identifier.length == 0) return;
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    //从字典中取出之前存储的定时器
    dispatch_source_t timer = timersDic[identifier];
    if (timer) {
        dispatch_source_cancel(timer);
        //从字典中移除定时器
        [timersDic removeObjectForKey:identifier];
    };
    dispatch_semaphore_signal(semaphore_);
}
@end
