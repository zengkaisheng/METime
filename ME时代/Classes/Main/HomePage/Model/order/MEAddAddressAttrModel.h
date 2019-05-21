//
//  MEAddAddressAttrModel.h
//  ME时代
//
//  Created by gao lei on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@class MEAddressModel;
/*
 token    是    string    登陆后的token
 truename    是    string    用户名
 is_default    是    int    1 默认地址 0普通地址
 telphone    是    string    手机号码
 province    是    string    省份
 city    是    string    市
 district    是    string    区
 detail_address    是    string    详细地址
 */


@interface MEAddAddressAttrModel : MEBaseModel

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *truename;
@property (nonatomic, assign) NSInteger is_default;
@property (nonatomic, copy) NSString *telphone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *detail_address;

@property (nonatomic, copy) NSString *address_id;

- (instancetype)initWithAddressModel:(MEAddressModel *)model;

@end
