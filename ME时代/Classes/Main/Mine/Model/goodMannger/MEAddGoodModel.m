//
//  MEAddGoodModel.m
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAddGoodModel.h"

@implementation MEAddGoodspecJsoneModel
@end

@implementation MEAddGoodspecNameModel
@end

@implementation MEAddGoodModel

+(MEAddGoodModel *)getModel{
    MEAddGoodModel *model = [MEAddGoodModel new];
    model.token = kMeUnNilStr(kCurrentUser.token);
    model.store_product_type = 1;
    model.is_new = 1;
    model.is_hot = 1;
    model.is_recommend = 1;
    model.is_clerk_share = 1;
    model.state = 1;
    model.tool = 2;
    model.ratio_after_sales = 0;
    model.ratio_marketing = 0;
    model.ratio_store = 0;
    return model;
}

- (NSMutableArray *)arrAddSpec{
    if(!_arrAddSpec){
        _arrAddSpec = [NSMutableArray array];
    }
    return _arrAddSpec;
}

- (NSMutableArray *)arrSpec{
    if(!_arrSpec){
        _arrSpec = [NSMutableArray array];
    }
    return _arrSpec;
}

@end
