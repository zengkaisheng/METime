//
//  MEBaseModel.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import <objc/runtime.h>

@implementation MEBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if ([super init] && [dic isKindOfClass:[NSDictionary class]]) {
        self = [[self class] mj_objectWithKeyValues:dic];
    }
    return self;
}

MJCodingImplementation

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithDic:[self mj_keyValues]];
}

- (NSString *)description {
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSString class]]) {
        return self.debugDescription;
    }
    //初始化一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //得到当前class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) { //循环并用KVC得到每个属性的值
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";//默认值为nil字符串
        [dictionary setObject:value forKey:name];//装载到字典里
    }
    //释放
    free(properties);
    //return
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,dictionary];
}



@end
