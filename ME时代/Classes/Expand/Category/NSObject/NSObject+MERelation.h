//
//  NSObject+MERelation.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MERelation)

/**
 使用NSStringFromClass的关联self到UIApplication的delegate
 */
+(instancetype)me_instance;
/**
 把关联设为nil
 */
+(void)me_setNilForDefaultTarget;

/**
 使用NSStringFromClass的关联self到target
 */
+(instancetype)me_instanceForTarget:(id)target;
/**
 把关联设为nil
 */
+(void)me_setNilForTarget:(id)target;

/**
 使用strKeyName关联self到target
 */
+(instancetype)me_instanceForTarget:(id)target keyName:(NSString *)strKeyName;
/**
 把关联设为nil
 */
+(void)me_setNilForTarget:(id)target keyName:(NSString *)strKeyName;

@end
