//
//  NSMutableArray+MEErrorHandle.m
//  ME时代
//
//  Created by gao lei on 2018/9/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "NSMutableArray+MEErrorHandle.h"

@implementation NSMutableArray (MEErrorHandle)

/**
 *  数组中插入数据
 */
- (void)insertObjectVerify:(id)object atIndex:(NSInteger)index{
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}
/**
 *  数组中添加数据
 */
- (void)addObjectVerify:(id)object{
    if (object) {
        [self addObject:object];
    }
}

@end
