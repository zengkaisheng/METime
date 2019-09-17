//
//  MEPersonalCourseListModel.m
//  ME时代
//
//  Created by gao lei on 2019/9/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersonalCourseListModel.h"

@implementation MECourseListModel

MEModelIdToIdField

@end


@implementation MEPersonalCourseListModel

MEModelObjectClassInArrayWithDic((@{@"courses" : [MECourseListModel class]}))

@end
