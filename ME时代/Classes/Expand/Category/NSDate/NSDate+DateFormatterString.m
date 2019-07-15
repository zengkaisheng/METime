//
//  NSDate+DateFormatterString.m
//  ME时代
//
//  Created by gao lei on 2019/7/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "NSDate+DateFormatterString.h"

@implementation NSDate (DateFormatterString)

- (NSString *)getNowDateFormatterString {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [NSDate date];
    NSString* dateString = [dateFormatter stringFromDate:startDate];
//    NSLog(@"现在的时间 === %@",dateString);
    return dateString;
}

- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:timeString];
    return date;
}
    
    

@end
