//
//  RunLoopIntro.m
//  Runtime_intro
//  
//  Created by ash on 2020/5/6.
//  Copyright © 2020 ash. All rights reserved.
//
    

#import "RunLoopIntro.h"

//RunLoop是通过内部维护的事件循环(Event Loop)来对事件/消息进行管理的一个对象。

// 一般来讲，一个线程一次只能执行一个任务，执行完成后线程就会退出。
//如果我们需要一个机制，让线程能随时处理事件但并不退出。这种模型通常被称作 Event Loop。 Event Loop 在很多系统和框架里都有实现，
//比如 Node.js 的事件处理，比如 Windows 程序的消息循环，再比如 OSX/iOS 里的 RunLoop。
//实现这种模型的关键点在于：如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。


@implementation RunLoopIntro

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)runLoopTest {
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    @autoreleasepool {
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        
        [runLoop run];
        
    }
    
}

//线程和RunLoop是一一对应的,其映射关系是保存在一个全局的 Dictionary 里
//自己创建的线程默认是没有开启RunLoop的

- (void)runLoopTest2 {
     NSLog(@"1");
    // test方法并不会执行。
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"2");

        [self performSelector:@selector(test) withObject:nil afterDelay:10];
        
        NSLog(@"3");
    });

    NSLog(@"4");
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
          
        NSLog(@"2");
      
        [[NSRunLoop currentRunLoop] run];
          
        [self performSelector:@selector(test) withObject:nil afterDelay:10];

        NSLog(@"3");
    });
    //test方法依然不执行
    // 原因是如果RunLoop的mode中一个item都没有，RunLoop会退出。
    // 即在调用RunLoop的run方法后，由于其mode中没有添加任何item去维持RunLoop的时间循环，RunLoop随即还是会退出。
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
          
        NSLog(@"2");
        [self performSelector:@selector(test) withObject:nil afterDelay:10];
      
        [[NSRunLoop currentRunLoop] run];
        
        NSLog(@"3");
    });

    
    //怎样保证子线程数据回来更新UI的时候不打断用户的滑动操作
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}

- (void)test {
    NSLog(@"5");
}

- (void)reloadData {
    // 刷新页面
}

@end
