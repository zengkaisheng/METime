//
//  MECustomerServiceLogsModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerServiceLogsModel.h"

@implementation MEServiceLogsDataModel

MEModelIdToIdField

@end



@implementation MEServiceLogsModel

MEModelObjectClassInArrayWithDic((@{@"data" : [MEServiceLogsDataModel class]}))

@end



@implementation MECustomerServiceLogsModel

MEModelIdToIdField

@end
