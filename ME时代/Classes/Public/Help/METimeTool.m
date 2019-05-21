//
//  METimeTool.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "METimeTool.h"

@implementation METimeModel

@end

@implementation METimeTool

+ (NSMutableArray *)latelyWeekTime{
    NSMutableArray *wekArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 7; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M.d"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        NSDateFormatter *YAMFormatter = [[NSDateFormatter alloc] init];
        [YAMFormatter setDateFormat:@"Y-M-d"];
        NSString *YANStr = [YAMFormatter stringFromDate:curDate];//几月几号
        
        //转换英文为中文
        NSString *chinaStr = [self cTransformFromE:weekStr index:i];
        //NSLog(@"%@",strTime);
        METimeModel *model = [METimeModel new];
        model.month = dateStr;
        model.week = chinaStr;
        model.yearAndMonth = YANStr;
        [wekArr addObject:model];
    }
    return wekArr;
}

+ (NSMutableArray *)getTime{
    NSMutableArray *timeArr = [[NSMutableArray alloc] init];
    NSArray *arrTime = @[@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",
                         @"10:30",@"11:00",@"11:30",@"12:00",@"12:30",
                         @"13:00",@"13:30",@"14:00",@"14:30",@"15:00",
                         @"15:30",@"16:00",@"16:30",@"17:00",@"17:30",
                         @"18:00",@"18:30",@"19:00",@"19:30",@"20:00",
                         @"20:30",@"21:00",@"21:30",@"22:00"];
    for (NSInteger i = 0; i < arrTime.count; i ++) {
        NSString *obj = arrTime[i];
        METimeModel *model = [METimeModel new];
        model.time = obj;
        [timeArr addObject:model];
    }
    return timeArr;
}

+(NSString *)timestampSwitchTime:(NSString *)timestamp andFormatter:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [fmt setDateFormat:format];
    return [fmt stringFromDate:date];
}

//+(NSString*)getCurrentTimes{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate *datenow = [NSDate date];
//    NSString *currentTimeString = [formatter stringFromDate:datenow];
//    NSLog(@"currentTimeString =  %@",currentTimeString);
//    return currentTimeString;
//}


//+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
//    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
//    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
//    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
//    NSComparisonResult result = [dateA compare:dateB];
//    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
//    if (result == NSOrderedDescending) {
//        //在指定时间前面 过了指定时间 过期
//        NSLog(@"oneDay  is in the future");
//        return 1;
//    }
//    else if (result == NSOrderedAscending){
//        //没过指定时间 没过期
//        //NSLog(@"Date1 is in the past");
//        return -1;
//    }
//    //刚好时间一样.
//    //NSLog(@"Both dates are the same");
//    return 0;
//
//}

+ (NSString *)cTransformFromE:(NSString *)theWeek index:(NSInteger)index{
    NSString *chinaStr;
    if(theWeek){
        if(index == 0){
            chinaStr = @"今天";
        }else if (index == 1){
            chinaStr = @"明天";
        }else if (index == 2){
            chinaStr = @"后天";
        }else{
            if([theWeek isEqualToString:@"Monday"]){
                chinaStr = @"周一";
            }else if([theWeek isEqualToString:@"Tuesday"]){
                chinaStr = @"周二";
            }else if([theWeek isEqualToString:@"Wednesday"]){
                chinaStr = @"周三";
            }else if([theWeek isEqualToString:@"Thursday"]){
                chinaStr = @"周四";
            }else if([theWeek isEqualToString:@"Friday"]){
                chinaStr = @"周五";
            }else if([theWeek isEqualToString:@"Saturday"]){
                chinaStr = @"周六";
            }else if([theWeek isEqualToString:@"Sunday"]){
                chinaStr = @"周日";
            }
        }
    }
    return chinaStr;
}




@end
