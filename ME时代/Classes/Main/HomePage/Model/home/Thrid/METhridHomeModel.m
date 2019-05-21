//
//  METhridHomeModel.m
//  ME时代
//
//  Created by hank on 2019/1/24.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeModel.h"

@implementation METhridHomeBuyingGoodsModel


@end

@implementation METhridHomeAdModel


@end

@implementation METhridHomeserviceModel


@end

@implementation METhridHomeBackgroundModel

MEModelIdToIdField

@end

@implementation METhridHomeModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{return @{@"member_exclusive" : @"new_member_exclusive"};}

MEModelObjectClassInArrayWithDic((@{@"service" : [METhridHomeserviceModel class],@"top_banner" : [METhridHomeAdModel class],@"scare_buying_goods" : [METhridHomeBuyingGoodsModel class]}))

- (NSArray*)scare_buying_goods{
    if(!_scare_buying_goods){
        _scare_buying_goods = [NSArray array];
    }
    return _scare_buying_goods;
}

- (NSArray*)service{
    if(!_service){
        _service = [NSArray array];
    }
    return _service;
}

- (NSArray*)top_banner{
    if(!_top_banner){
        _top_banner = [NSArray array];
    }
    return _top_banner;
}

@end
