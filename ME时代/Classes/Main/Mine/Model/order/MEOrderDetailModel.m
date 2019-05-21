//
//  MEOrderDetailModel.m
//  ME时代
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEOrderDetailModel.h"
#import "MEOrderModel.h"

@implementation MEexpressDetailModel

@end

@implementation MEStoreGetModel
MEModelIdToIdField
@end

@implementation MEOrderDetailExpressModel

@end

@implementation MEOrderDetailAddressModel
MEModelIdToIdField
@end


@implementation MEOrderDetailModel
MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"children" : [MEOrderGoodModel class],@"express_detail" : [MEexpressDetailModel class]}))
@end
