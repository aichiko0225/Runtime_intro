//
//  NSObject+AssociatedObject.m
//  Runtime_intro
//  
//  Created by ash on 2020/2/9.
//  Copyright © 2020 ash. All rights reserved.
//

#import "NSObject+AssociatedObject.h"
#import <objc/runtime.h>

@implementation BClass

- (void)method1 {
    NSLog(@"!!!!! %@", _cmd);
}

@end


@implementation AClass

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method1"]) {
//        BClass *bclass = [[BClass alloc] init];
//        Method m1 = class_getInstanceMethod(bclass, @selector(method1));
//        char * ch = method_getTypeEncoding(m1);
//        class_addMethod(self.class, @selector(method1), (IMP)[BClass methodForSelector:@selector(method1)], ch);
    }
    return [super resolveInstanceMethod:sel];
}

@end


@implementation NSObject (AssociatedObject)

- (void)setAssociatedObject:(id)associatedObject {
    static char *AssociatedObjectKey1 = "AssociatedKey";
    static const void *AssociatedKey2 = "AssociatedKey";
    
    objc_setAssociatedObject(self, @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

@end
