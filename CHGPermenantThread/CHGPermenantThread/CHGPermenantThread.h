//
//  CHGPermenantThread.h
//  CHGPermenantThread
//
//  Created by chenhongen on 2018/8/30.
//  Copyright © 2018年 陈弘根. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CHGPermenantThreadTask)(void);

@interface CHGPermenantThread : NSObject


/**
 开启线程，默认自动开启
 */
//- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(CHGPermenantThreadTask)task;

/**
 结束线程,默认CHGPermenantThread销毁时自动结束线程
 */
- (void)stop;

@end
