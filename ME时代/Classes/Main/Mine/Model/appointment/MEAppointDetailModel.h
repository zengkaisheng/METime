//
//  MEAppointDetailModel.h
//  ME时代
//
//  Created by hank on 2018/10/22.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEAppointDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * arrive_time;
@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * detail_address;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, assign) NSInteger is_use;//0已预约 1已使用 2未使用
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * reserve_sn;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * telphone;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * true_name;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString *reserve_number;
@property (nonatomic, assign) NSInteger is_first_buy;

@property (nonatomic, strong) NSString * name;//用户名称
@property (nonatomic, strong) NSString * member_cellphone;//用户手机号
@end
