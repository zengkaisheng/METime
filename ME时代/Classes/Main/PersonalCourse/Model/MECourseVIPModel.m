//
//  MECourseVIPModel.m
//  志愿星
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseVIPModel.h"

@implementation MECourseVIPDetailModel

MEModelIdToIdField

@end


@implementation MECourseVIPModel

MEModelObjectClassInArrayWithDic((@{@"vip" : [MECourseVIPDetailModel class]}))


@end
