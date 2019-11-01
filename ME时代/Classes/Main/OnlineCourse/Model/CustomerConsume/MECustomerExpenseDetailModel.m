//
//  MECustomerExpenseDetailModel.m
//  志愿星
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerExpenseDetailModel.h"

@implementation MEExpenseDetailSubModel

MEModelIdToIdField

@end



@implementation MECustomerExpenseDetailModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"ci_card" : [MEExpenseDetailSubModel class], @"product" : [MEExpenseDetailSubModel class], @"time_card" : [MEExpenseDetailSubModel class], @"top_up" : [MEExpenseDetailSubModel class]}))

@end
