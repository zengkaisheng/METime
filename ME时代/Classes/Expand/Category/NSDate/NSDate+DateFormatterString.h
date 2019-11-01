//
//  NSDate+DateFormatterString.h
//  志愿星
//
//  Created by gao lei on 2019/7/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (DateFormatterString)
//时间转字符串
- (NSString *)getNowDateFormatterString;
//字符串转时间
- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString;

@end

NS_ASSUME_NONNULL_END
