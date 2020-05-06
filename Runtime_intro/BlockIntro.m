//
//  BlockIntro.m
//  Runtime_intro
//  
//  Created by ash on 2020/5/5.
//  Copyright © 2020 ash. All rights reserved.
//
    

#import "BlockIntro.h"

//什么是Block？
//Block变量截获
//Block的几种形式

//什么是Block？
//Block是将函数及其执行上下文封装起来的对象。

//Block的几种形式
//分为全局Block(_NSConcreteGlobalBlock)、栈Block(_NSConcreteStackBlock)、堆Block(_NSConcreteMallocBlock)三种形式
//其中栈Block存储在栈(stack)区，堆Block存储在堆(heap)区，全局Block存储在已初始化数据(.data)区

//1、不使用外部变量的block是全局block
//2、使用外部变量并且未进行copy操作的block是栈block
//3、对栈block进行copy操作，就是堆block，而对全局block进行copy，仍是全局block



@implementation BlockIntro

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSInteger num = 3;
        NSInteger(^block)(NSInteger) = ^NSInteger(NSInteger n) {
            return n*num;
        };
        
        num = 1;
        
        NSInteger num1 = block(2);
        
        NSLog(@"%ld", num1);
    }
    return self;
}

static NSInteger num3 = 300;

NSInteger num4 = 3000;

- (void)blockTest
{
    NSInteger num = 30;
    
    static NSInteger num2 = 3;
    
    __block NSInteger num5 = 30000;
    
    void(^block)(void) = ^{
        
        NSLog(@"%zd",num);//局部变量
        
        NSLog(@"%zd",num2);//静态变量
        
        NSLog(@"%zd",num3);//全局变量
        
        NSLog(@"%zd",num4);//全局静态变量
        
        NSLog(@"%zd",num5);//__block修饰变量
    };
    
    block();
}


- (void)blockTest1
{
    //1、不使用外部变量的block是全局block
    NSLog(@"%@",[^{
        NSLog(@"globalBlock");
    } class]);
    
    //2、使用外部变量并且未进行copy操作的block是栈block
    NSInteger num = 10;
    NSLog(@"%@",[^{
        NSLog(@"stackBlock:%zd",num);
    } class]);
    
    [self testWithBlock:^{
        NSLog(@"%@",self);
    }];
    
    //3、对栈block进行copy操作，就是堆block，而对全局block进行copy，仍是全局block
    
    void (^globalBlock)(void) = ^{
        NSLog(@"globalBlock");
    };
    
    NSLog(@"%@",[globalBlock class]);
    
    // 对栈block进行copy操作，就是堆block
    NSInteger num1 = 10;

    void (^mallocBlock)(void) = ^{
        NSLog(@"stackBlock:%zd", num1);
    };

    NSLog(@"%@",[mallocBlock class]);
    
    
}

- (void)testWithBlock:(dispatch_block_t)block {
    block();

    NSLog(@"%@",[block class]);
    
    
    dispatch_block_t tempBlock = block;
    
    NSLog(@"%@,%@",[block class], [tempBlock class]);
    
    //对栈blockcopy之后，并不代表着栈block就消失了
    //左边的mallock是堆block，右边被copy的仍是栈block
}

@end
