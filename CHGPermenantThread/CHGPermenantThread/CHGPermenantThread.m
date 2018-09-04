//
//  CHGPermenantThread.m
//  CHGPermenantThread
//
//  Created by chenhongen on 2018/8/30.
//  Copyright © 2018年 陈弘根. All rights reserved.
//

#import "CHGPermenantThread.h"


#define mode 0 //oc版本
//#define mode 1 //c版本

/** CHGThread **/
@interface CHGThread : NSThread
@end
@implementation CHGThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

/** CHGPermenantThread **/
@interface CHGPermenantThread()
@property (strong, nonatomic) CHGThread *innerThread;
@property (assign, nonatomic, getter=isStopped) BOOL stopped;
@end

@implementation CHGPermenantThread

#pragma mark - public methods
- (instancetype)init
{
    if (self = [super init]) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        
#if mode == 0
        
        self.innerThread = [[CHGThread alloc] initWithBlock:^{
            // 往RunLoop里面添加Source\Timer\Observer；否则loop无法成功启动
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            // 只要没有主动或被动退出loop 那么就继续让loop跑起来
            while (weakSelf && !weakSelf.isStopped) {
                // 这个方法在没有任务时就睡眠  任务完成了就会退出loop
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
        
#elif mode == 1
        self.innerThread = [[CHGThread alloc] initWithBlock:^{
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            // 销毁source
            CFRelease(source);
            
            // 启动
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
            //            while (weakSelf && !weakSelf.isStopped) {
            //                // 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前loop
            //                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
            //            }
            
        }];
#endif
        
        // 默认自动开启线程
        [self.innerThread start];
    }
    return self;
}

- (void)run
{
    if (!self.innerThread) return;

    [self.innerThread start];
}

- (void)executeTask:(CHGPermenantThreadTask)task
{
    if (!self.innerThread || !task) return;
    // 在子线程调用__executeTask: 执行任务
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop
{
    if (!self.innerThread) return;
    // 在子线程调用__stop（waitUntilDone设置为YES，代表子线程的代码执行完毕后，这个方法才会往下走）
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}

#pragma mark - private methods
- (void)__stop
{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());// 停止RunLoop
    self.innerThread = nil;// 清空线程
}

- (void)__executeTask:(CHGPermenantThreadTask)task
{
    task();
}

@end
