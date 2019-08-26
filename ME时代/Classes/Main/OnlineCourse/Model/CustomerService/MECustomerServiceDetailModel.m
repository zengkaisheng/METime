//
//  MECustomerServiceDetailModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerServiceDetailModel.h"

@implementation MEServiceDetailSubModel

MEModelIdToIdField

@end


@implementation MECustomerServiceDetailModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"ci_card_service" : [MEServiceDetailSubModel class], @"product_service" : [MEServiceDetailSubModel class], @"time_card_service" : [MEServiceDetailSubModel class]}))

@end
