//
//  METimeTool.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface METimeModel : MEBaseModel

@property (nonatomic ,copy) NSString *yearAndMonth;
@property (nonatomic ,copy) NSString *week;//星期
@property (nonatomic ,copy) NSString *month;//月
@property (nonatomic ,copy) NSString *time;//时间
@property (nonatomic ,assign) BOOL canTouch;

@end

@interface METimeTool : NSObject

+ (NSMutableArray *)latelyWeekTime;
+ (NSMutableArray *)getTime;
+(NSString *)timestampSwitchTime:(NSString *)timestamp andFormatter:(NSString *)format;
@end
