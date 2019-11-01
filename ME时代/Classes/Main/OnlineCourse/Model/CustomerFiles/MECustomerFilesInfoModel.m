//
//  MECustomerFilesInfoModel.m
//  志愿星
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerFilesInfoModel.h"
#import "MECustomerFollowTypeModel.h"

@implementation MECustomerInfoFollowModel

MEModelIdToIdField

@end



@implementation MECustomerInfoHabitSubModel

MEModelIdToIdField

@end



@implementation MECustomerInfoHabitModel

MEModelObjectClassInArrayWithDic((@{@"habit_arr" : [MECustomerInfoHabitSubModel class]}))

@end



@implementation MECustomerFilesInfoModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"habit" : [MECustomerInfoHabitModel class], @"follow" : [MECustomerInfoFollowModel class]}))

@end
