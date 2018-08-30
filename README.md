# CHGPermenantThread
线程保活：快速创建子线程并提供执行任务的block，自动管理线程生命周期

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
