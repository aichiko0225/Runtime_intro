//
//  Person.m
//  Runtime_intro
//  
//  Created by ash on 2020/2/9.
//  Copyright © 2020 ash. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        unsigned int outCount = 0;
        Ivar *vars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar var = vars[i];
            const char *name = ivar_getName(var);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList(self.class, &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        Ivar var = vars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:name];
        
        id value = [self valueForKey:key];
        [coder encodeObject:value forKey:key];
    }
}


+ (BOOL)supportsSecureCoding {
    return YES;
}


@end
