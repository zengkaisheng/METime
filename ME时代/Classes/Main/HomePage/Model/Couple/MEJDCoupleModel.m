//
//  MEJDCoupleModel.m
//  ME时代
//
//  Created by hank on 2019/2/18.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEJDCoupleModel.h"

@implementation CouponContentInfo : MEBaseModel


@end

@implementation ImageContentInfo : MEBaseModel

@end

@implementation CouponInfo : MEBaseModel
MEModelObjectClassInArrayWithDic(@{@"couponList":[CouponContentInfo class]})
@end

@implementation ImageInfo : MEBaseModel

MEModelObjectClassInArrayWithDic(@{@"imageList":[ImageContentInfo class]})


@end

@implementation PriceInfo : MEBaseModel

@end

@implementation CommissionInfo : MEBaseModel

@end


@implementation MEJDCoupleModel

@end
