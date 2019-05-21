//
//  NSMutableArray+MEErrorHandle.h
//  ME时代
//
//  Created by gao lei on 2018/9/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MEErrorHandle)

/**
 数组中插入数据
 
 @param object 数据
 @param index 下标
 */
- (void)insertObjectVerify:(id)object atIndex:(NSInteger)index;
/**
 数组中添加数据
 
 @param object 数据
 */
- (void)addObjectVerify:(id)object;


@end
