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

@implementation MECourseHomeMenuListSubModel
MEModelIdToIdField
@end


@implementation MECourseHomeMenuListModel
MEModelIdToIdField
@end


@implementation MECourseHomeVideoListModel

MEModelObjectClassInArrayWithDic((@{@"data" : [MEOnlineCourseListModel class]}))

@end


@implementation MECourseHomeCategoryModel

MEModelIdToIdField
MEModelObjectClassInArrayWithDic((@{@"video_list":[MEOnlineCourseListModel class]}))

@end


@implementation MEOnlineCourseHomeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"courseNew":@"new"};
}

MEModelObjectClassInArrayWithDic((@{@"top_banner" : [MEAdModel class], @"onLine_banner" : [MEAdModel class], @"banner" : [MEAdModel class], @"menu_list":[MECourseHomeMenuListModel class], @"category":[MECourseHomeCategoryModel class], @"recommend":[MEOnlineCourseListModel class], @"courseNew":[MEOnlineCourseListModel class], @"j_goods":[MEOnlineCourseListModel class], @"b_audio":[MEOnlineCourseListModel class]}))

@end
