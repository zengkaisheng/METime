//
//  MEMakeOrderAttrModel.m
//  ME时代
//
//  Created by hank on 2018/9/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMakeOrderAttrModel.h"
#import "MEGoodDetailModel.h"

@implementation MEMakeOrderAttrModel


- (instancetype)initWithGoodDetailModel:(MEGoodDetailModel *)model{
    if(self = [super init]){
        self.product_id = [NSString stringWithFormat:@"%@",@(model.product_id)];
        self.spec_ids = model.spec_ids;
        self.num = [NSString stringWithFormat:@"%@",@(model.buynum)];
        self.token = kMeUnNilStr(kCurrentUser.token);
        self.order_type = @"1";
        self.store_id = @"1";
        self.share_id = @"0";
        self.remark = @"";
        self.user_address = @"";
        self.channel = @"app";
    }
    return self;
}


@end
