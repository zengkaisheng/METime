//
//  MECustomerFilesInfoModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerFilesInfoModel.h"
#import "MECustomerFollowTpyeModel.h"

@implementation MECustomerInfoFollowModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"followList" : [MECustomerFollowTpyeModel class]}))

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
