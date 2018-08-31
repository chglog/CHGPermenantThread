# CHGPermenantThread
线程保活：快速创建子线程并提供执行任务的block，自动管理线程生命周期

# 提供三个接口
/**
 开启线程，默认自动开启
 */
- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(CHGPermenantThreadTask)task;

/**
 结束线程,默认CHGPermenantThread销毁时自动结束线程
 */
- (void)stop;


# 用法

    // 创建一个保活线程，直到ViewController销毁，或者主动调用stop
    self.thread = [[CHGPermenantThread alloc] init];

    [self.thread executeTask:^{
        // 你要在子线程里做的事情
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
    // 主动销毁该子线程
    [self.thread stop];


# OC版本核心实现代码 
 
        
        self.innerThread = [[CHGThread alloc] initWithBlock:^{
            // 往RunLoop里面添加Source\Timer\Observer
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            // 只要没有主动或被动退出loop 那么就继续让loop跑起来
            while (weakSelf && !weakSelf.isStopped) {
                // 这个方法在没有任务时就睡眠  任务完成了就会退出loop
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
