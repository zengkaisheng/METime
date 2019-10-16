//
//  MEStudiedHomeModel.m
//  ME时代
//
//  Created by gao lei on 2019/10/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEStudiedHomeModel.h"

@implementation MEStudiedCourseModel

MEModelIdToIdField

@end


@implementation MEStudiedHomeModel

MEModelObjectClassInArrayWithDic((@{@"collected" : [MEStudiedCourseModel class], @"studied":[MEStudiedCourseModel class]}))

@end
