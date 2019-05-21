//
//  NSObject+MERelation.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "NSObject+MERelation.h"
#import <objc/runtime.h>

@implementation NSObject (MERelation)

+(instancetype)me_instance{
    return [self me_instanceForTarget:[UIApplication sharedApplication].delegate];
}

+(void)me_setNilForDefaultTarget{
    [self me_setNilForTarget:[UIApplication sharedApplication].delegate];
}

+(instancetype)me_instanceForTarget:(id)target{
    return [self me_instanceForTarget:target keyName:NSStringFromClass([self class])];
}

+(void)me_setNilForTarget:(id)target{
    [self me_setNilForTarget:target keyName:NSStringFromClass([self class])];
}

+(instancetype)me_instanceForTarget:(id)target keyName:(NSString *)strKeyName{
    if (!target) {
        NSAssert(YES, @"no target");
    }
    id obj = objc_getAssociatedObject(target, &strKeyName);
    if ([obj isKindOfClass:[self class]]) {
        return obj;
    }
    obj = [[self alloc]init];
    objc_setAssociatedObject(target, &strKeyName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return obj;
}

+(void)me_setNilForTarget:(id)target keyName:(NSString *)strKeyName{
    objc_setAssociatedObject(target, (__bridge const void *)(strKeyName), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
