//
//  NSObject+AssociatedObject.h
//  Runtime_intro
//  
//  Created by ash on 2020/2/9.
//  Copyright © 2020 ash. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AClass : NSObject

- (void)method1;

@end

@interface BClass : NSObject

@end

@interface NSObject (AssociatedObject)

@property (nonatomic, strong) id associatedObject;

@end

NS_ASSUME_NONNULL_END
