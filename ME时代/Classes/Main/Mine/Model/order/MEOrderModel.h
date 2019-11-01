//
//  MEOrderModel.h
//  志愿星
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEOrderGoodModel : MEBaseModel

@property (nonatomic, strong) NSString * all_amount;
@property (nonatomic, assign) NSInteger apprise_status;
@property (nonatomic, assign) NSInteger company_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * freight;
@property (nonatomic, strong) NSString * get_phone_bill;  //可领话费
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * order_goods_sn;
@property (nonatomic, strong) NSString * order_goods_status;
@property (nonatomic, strong) NSString * order_goods_status_name;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * order_spec_id;
@property (nonatomic, strong) NSString * order_spec_name;
@property (nonatomic, strong) NSString * product_amount;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * product_image;
@property (nonatomic, strong) NSString * product_name;
@property (nonatomic, assign) NSInteger product_number;
@property (nonatomic, assign) NSInteger product_type;
@property (nonatomic, strong) NSString * refund_sn;
@property (nonatomic, assign) NSInteger refund_status;
@property (nonatomic, assign) NSInteger return_cash_store;
@property (nonatomic, assign) NSInteger share_id;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString * updated_at;


@property (nonatomic, strong) NSString *integral_lines;
@property (nonatomic, strong) NSString *order_type;
//拼团相关
@property (nonatomic, assign) NSInteger address_edit;
@property (nonatomic, strong) NSString * channel;
@property (nonatomic, assign) NSInteger is_export;
@property (nonatomic, assign) NSInteger share_uid;
@property (nonatomic, assign) NSInteger warehouse_id;
//联通订单相关
@property (nonatomic, assign) NSInteger is_check;
@property (nonatomic, assign) NSInteger top_up_status;
@property (nonatomic, strong) NSString *top_up_status_name;

@property (nonatomic, assign) BOOL isTopUp;//联通充值订单

@end


@interface MEOrderModel : MEBaseModel

@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic, strong) NSString *order_status;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSString *order_status_name;
//自提订单"get_status": "未提取",
@property (nonatomic, strong) NSString *get_status;
//联通订单相关
@property (nonatomic, strong) NSString *girl_number;
@property (nonatomic, assign) NSInteger top_up_status;
@property (nonatomic, strong) NSString *top_up_status_name;

@property (nonatomic, assign) BOOL isTopUp;//联通充值订单

@end
