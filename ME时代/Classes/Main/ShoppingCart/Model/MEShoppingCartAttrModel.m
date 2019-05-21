//
//  MEShoppingCartAttrModel.m
//  ME时代
//
//  Created by gao lei on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShoppingCartAttrModel.h"
#import "MEGoodDetailModel.h"

@implementation MEShoppingCartAttrModel

- (instancetype)initWithGoodmodel:(MEGoodDetailModel *)model{
    if(self = [super init]){
        self.token = kMeUnNilStr(kCurrentUser.token);
        self.goodsId = model.product_id;
        self.goodsNum = model.buynum;
        self.type = 0;
//        self.userid = kCurrentUser.userId;
        NSMutableArray *arrSpc = [NSMutableArray array];
        [model.arrSelect enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {\
            NSInteger selectIndex = [obj integerValue];
            MEGoodDetailSpecModel *oldSectionModel = kMeUnArr(model.spec)[idx];
            MEGoodSpecModel *ospecModel = kMeUnArr(oldSectionModel.spec_value)[selectIndex];
            [arrSpc addObject:@(ospecModel.idField)];
        }];
        NSString *str = [arrSpc componentsJoinedByString:@","];
#warning -nowOnlyOne 目前一个
        self.specId = [str integerValue];
        self.store_id = 1;
    }
    return self;
}

@end
