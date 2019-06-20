//
//  MEPrizeDetailsModel.m
//  ME时代
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPrizeDetailsModel.h"

@implementation MEPrizeLogModel

MEModelIdToIdField

@end

@implementation MEPrizeDetailsModel

MEModelIdToIdField
MEModelObjectClassInArrayWithDic((@{@"lucky" : [MEPrizeLogModel class],@"prizeLog" : [MEPrizeLogModel class],@"inviteLog":[MEPrizeLogModel class]}))

@end
