//
//  NSObject+MEDebugDescription.m
//  ME时代
//
//  Created by gao lei on 2018/9/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "NSObject+MEDebugDescription.h"

@implementation NSObject (MEDebugDescription)

- (NSString *)debugDescription{
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSString class]])
    {
        return self.debugDescription;
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil"; // 默认值为nil字符串
        [dictionary setObject:value forKey:name];
    }
    free(properties);
    return [NSString stringWithFormat:@"<%@: %p> -- %@", [self class], self, dictionary];
}

@end
