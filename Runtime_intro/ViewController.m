//
//  ViewController.m
//  Runtime_intro
//  
//  Created by ash on 2020/2/8.
//  Copyright © 2020 ash. All rights reserved.
//
    

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+AssociatedObject.h"
#import <pthread/pthread.h>

@interface Sark : NSObject

@property (nonatomic, copy) NSString *name;
- (void)speak;

@end

@implementation Sark

- (void)speak {
    NSLog(@"my name's %@", self.name);
}

@end

@protocol Invoker <NSObject>

@required
// 在调用对象中的方法前执行对功能的横切
- (void)preInvoke:(NSInvocation *)inv withTarget:(id)target;
@optional
// 在调用对象中的方法后执行对功能的横切
- (void)postInvoke:(NSInvocation *)inv withTarget:(id)target;

@end

@interface Student : NSObject

-(void)study:(NSString *)subject andRead:(NSString *)bookName;
-(void)study:(NSString *)subject :(NSString *)bookName;

@end

@implementation Student

-(void)study:(NSString *)subject :(NSString *)bookName
{
    NSLog(@"Invorking method on %@ object with selector %@",[self class],NSStringFromSelector(_cmd));
}

-(void)study:(NSString *)subject andRead:(NSString *)bookName
{
    NSLog(@"Invorking method on %@ object with selector %@",[self class],NSStringFromSelector(_cmd));
}
@end


@interface AspectProxy : NSProxy

/** 通过NSProxy实例转发消息的真正对象 */
@property(strong) id proxyTarget;
/** 能够实现横切功能的类（遵守Invoker协议）的实例 */
@property(strong) id<Invoker> invoker;
/** 定义了哪些消息会调用横切功能 */
@property(readonly) NSMutableArray *selectors;

// AspectProxy类实例的初始化方法
- (id)initWithObject:(id)object andInvoker:(id<Invoker>)invoker;
- (id)initWithObject:(id)object selectors:(NSArray *)selectors andInvoker:(id<Invoker>)invoker;
// 向当前的选择器列表中添加选择器
- (void)registerSelector:(SEL)selector;

@end

@implementation AspectProxy

- (id)initWithObject:(id)object selectors:(NSArray *)selectors andInvoker:(id<Invoker>)invoker{
    _proxyTarget = object;
    _invoker = invoker;
    _selectors = [selectors mutableCopy];
    
    return self;
}

- (id)initWithObject:(id)object andInvoker:(id<Invoker>)invoker{
    return [self initWithObject:object selectors:nil andInvoker:invoker];
}

// 添加另外一个选择器
- (void)registerSelector:(SEL)selector{
    NSValue *selValue = [NSValue valueWithPointer:selector];
    [self.selectors addObject:selValue];
}

// 为目标对象中被调用的方法返回一个NSMethodSignature实例
// 运行时系统要求在执行标准转发时实现这个方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.proxyTarget methodSignatureForSelector:sel];
}

/**
 *  当调用目标方法的选择器与在AspectProxy对象中注册的选择器匹配时，forwardInvocation:会
 *  调用目标对象中的方法，并根据条件语句的判断结果调用AOP（面向切面编程）功能
 */
- (void)forwardInvocation:(NSInvocation *)invocation{
    // 在调用目标方法前执行横切功能
    if ([self.invoker respondsToSelector:@selector(preInvoke:withTarget:)]) {
        if (self.selectors != nil) {
            SEL methodSel = [invocation selector];
            for (NSValue *selValue in self.selectors) {
                if (methodSel == [selValue pointerValue]) {
                    [[self invoker] preInvoke:invocation withTarget:self.proxyTarget];
                    break;
                }
            }
        }else{
            [[self invoker] preInvoke:invocation withTarget:self.proxyTarget];
        }
    }
    
    // 调用目标方法
    [invocation invokeWithTarget:self.proxyTarget];
    
    // 在调用目标方法后执行横切功能
    if ([self.invoker respondsToSelector:@selector(postInvoke:withTarget:)]) {
        if (self.selectors != nil) {
            SEL methodSel = [invocation selector];
            for (NSValue *selValue in self.selectors) {
                if (methodSel == [selValue pointerValue]) {
                    [[self invoker] postInvoke:invocation withTarget:self.proxyTarget];
                    break;
                }
            }
        }else{
            [[self invoker] postInvoke:invocation withTarget:self.proxyTarget];
        }
    }
}

@end


@interface AuditingInvoker : NSObject<Invoker>//遵守Invoker协议
@end

@implementation AuditingInvoker

- (void)preInvoke:(NSInvocation *)inv withTarget:(id)target{
    NSLog(@"before sending message with selector %@ to %@ object", NSStringFromSelector([inv selector]),[target class]);
}
- (void)postInvoke:(NSInvocation *)inv withTarget:(id)target{
    NSLog(@"after sending message with selector %@ to %@ object", NSStringFromSelector([inv selector]),[target class]);

}
@end

@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
//    [super load];
    [self test1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"ViewController = %@ , 地址 = %p", self, &self);
    
    id cls = [Sark class];
    NSLog(@"Sark class = %@ 地址 = %p", cls, &cls);
    
    void *obj = &cls;
    NSLog(@"Void *obj = %@ 地址 = %p", obj,&obj);
    
    [(__bridge id)obj speak];
    
    Sark *sark = [[Sark alloc]init];
    NSLog(@"Sark instance = %@ 地址 = %p",sark,&sark);
    
    [sark speak];
//    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(viewWillAppear:)];
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//    invocation.target = self;
//    invocation.selector = @selector(viewWillAppear:);
//    [invocation invoke];
    
    id student = [[Student alloc] init];

    // 设置代理中注册的选择器数组
    NSValue *selValue1 = [NSValue valueWithPointer:@selector(study:andRead:)];
    NSArray *selValues = @[selValue1];
    // 创建AuditingInvoker
    AuditingInvoker *invoker = [[AuditingInvoker alloc] init];
    // 创建Student对象的代理studentProxy
    id studentProxy = [[AspectProxy alloc] initWithObject:student selectors:selValues andInvoker:invoker];
    
    // 使用指定的选择器向该代理发送消息---例子1
    [studentProxy study:@"Computer" andRead:@"Algorithm"];
    
    // 使用还未注册到代理中的其他选择器，向这个代理发送消息！---例子2
    [studentProxy study:@"mathematics" :@"higher mathematics"];
    
    // 为这个代理注册一个选择器并再次向其发送消息---例子3
    [studentProxy registerSelector:@selector(study::)];
    [studentProxy study:@"mathematics" :@"higher mathematics"];
}

+ (void)test1 {
    Class class = [self class];
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(xxx_viewWillAppear:);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(originalMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector,  method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
    AClass *aclass = [[AClass alloc] init];
    [aclass method1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"super viewWillAppear: %@", self);
    
//    pthread_mutex_t lock;
//    
//    pthread_mutex_init(&(lock),NULL); 
}

@end
