//
//  ViewController.m
//  CHGPermenantThread
//
//  Created by chenhongen on 2018/8/30.
//  Copyright © 2018年 陈弘根. All rights reserved.
//

#import "ViewController.h"
#import "CHGPermenantThread.h"

@interface ViewController ()
@property (strong, nonatomic) CHGPermenantThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建一个保活线程，直到ViewController销毁，或者主动调用stop
    self.thread = [[CHGPermenantThread alloc] init];
    
}

// 点击空白区
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        // 你要在子线程里做的事情
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}

- (IBAction)stop:(UIButton *)sender {
    // 主动销毁该子线程
    [self.thread stop];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}


@end
