//
//  HLTimer.h
//  内存管理_GCD定时器
//
//  Created by BaoHenglin on 2019/7/3.
//  Copyright © 2019 BaoHenglin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLTimer : NSObject
/**
 开启定时器
 @param task 待执行任务block
 @param start 多长时间之后开始执行
 @param interval 每隔多长时间执行一次
 @param repeats 是否重复
 @param async 是否在子线程中执行
 @return 定时器的唯一标识符
 */
+ (NSString *)executeTask:(void(^)(void))task
              start:(NSTimeInterval)start
           interval:(NSTimeInterval)interval
            repeats:(BOOL)repeats
              async:(BOOL)async;

/**
开启定时器
 @param target receiver
 @param selector @selector(SEL)
 @param start 多长时间之后开始执行
 @param interval 每隔多长时间执行一次
 @param repeats 是否重复
 @param async 是否在子线程中执行
 @return 定时器的唯一标识符
 */
+ (NSString *)executeTask:(id)target
                 selector:(SEL)selector
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async;
+ (void)cancelTimerTaskWithIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
