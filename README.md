# CHGPermenantThread
线程保活：快速创建子线程并提供执行任务的block，并让子线程一直存活，直到CHGPermenantThread对象销毁或者主动调用stop

应用场景：当有一个任务，随时都有可能去执行它，那么应该放在子线程去执行，并且让子线程一直存活着，避免执行多次任务做多次创建销毁线程的动作，降低性能消耗

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
