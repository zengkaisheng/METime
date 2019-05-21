//
//  NSArray+MEErrorHandle.m
//  ME时代
//
//  Created by gao lei on 2018/9/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "NSArray+MEErrorHandle.h"

@implementation NSArray (MEErrorHandle)

/**
 *  防止数组越界
 */
- (id)objectAtIndexVerify:(NSUInteger)index{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}
/**
 *  防止数组越界
 */
- (id)objectAtIndexedSubscriptVerify:(NSUInteger)idx{
    if (idx < self.count) {
        return [self objectAtIndexedSubscript:idx];
    }else{
        return nil;
    }
}

@end
