//
//  MEGroupOrderDetailModel.m
//  ME时代
//
//  Created by gao lei on 2019/7/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupOrderDetailModel.h"


@implementation MEGroupOrderGoodSpecModel

MEModelIdToIdField

@end


@implementation MEGroupMemberModel

@end


@implementation MEGroupOrderAddresModel

MEModelIdToIdField

@end


@implementation MEGroupOrderGoodsModel

MEModelIdToIdField

@end



@implementation MEGroupOrderDetailModel

MEModelIdToIdField
MEModelObjectClassInArrayWithDic(@{@"groupMember" : [MEGroupMemberModel class]})

@end
