//
//  ViewController.m
//  内存管理_GCD定时器
//
//  Created by BaoHenglin on 2019/7/3.
//  Copyright © 2019 BaoHenglin. All rights reserved.
//

#import "ViewController.h"
#import "HLTimer.h"
@interface ViewController ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) NSString *task;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"----begin");
//    self.task =  [HLTimer executeTask:^{
//        NSLog(@"GCD定时器-1111----%@",[NSThread currentThread]);
//    } start:2.0 interval:1.0 repeats:YES async:NO];
    
    self.task =  [HLTimer executeTask:self selector:@selector(doTask) start:2.0 interval:1.0 repeats:YES async:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [HLTimer cancelTimerTaskWithIdentifier:self.task];
}
- (void)doTask
{
    NSLog(@"doTask-----%@",[NSThread currentThread]);
}
@end
