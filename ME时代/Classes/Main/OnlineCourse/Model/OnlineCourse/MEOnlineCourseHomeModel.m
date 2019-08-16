//
//  MEOnlineCourseHomeModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineCourseHomeModel.h"
#import "MEAdModel.h"
#import "MEOnlineCourseListModel.h"

@implementation MECourseHomeVideoListModel

MEModelObjectClassInArrayWithDic((@{@"data" : [MEOnlineCourseListModel class]}))

@end



@implementation MEOnlineCourseHomeModel

MEModelObjectClassInArrayWithDic((@{@"top_banner" : [MEAdModel class], @"onLine_banner" : [MEAdModel class], @"banner" : [MEAdModel class]}))

@end
