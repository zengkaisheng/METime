//
//  MEDistrbutionOrderModel.h
//  ME时代
//
//  Created by gao lei on 2018/9/21.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEDistrbutionOrderModel : MEBaseModel

@property (nonatomic, strong) NSString * all_amount;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, assign) NSInteger is_ratio;
@property (nonatomic, strong) NSString * is_ratio_name;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * order_goods_sn;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, assign) NSInteger product_integral_id;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * product_image;
@property (nonatomic, strong) NSString * product_name;
@property (nonatomic, assign) NSInteger product_number;
@property (nonatomic, strong) NSString * spec_ids;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * order_spec_name;
@end
