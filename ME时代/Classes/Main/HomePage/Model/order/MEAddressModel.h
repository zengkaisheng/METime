//
//  MEAddressModel.h
//  ME时代
//
//  Created by gao lei on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEAddressModel : MEBaseModel

@property (nonatomic, assign) NSInteger address_id;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * create_time;
@property (nonatomic, strong) NSString * detail_address;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, assign) NSInteger is_default;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * telphone;
@property (nonatomic, strong) NSString * truename;
@property (nonatomic, strong) NSString * update_time;

@end
