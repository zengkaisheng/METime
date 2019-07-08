//
//  MEGroupOrderModel.h
//  ME时代
//
//  Created by gao lei on 2019/7/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGroupOrderExpressModel : MEBaseModel

@property (nonatomic, strong) NSString * express_name;
@property (nonatomic, assign) NSInteger express_num;
@property (nonatomic, strong) NSString * express_url;
@property (nonatomic, strong) NSArray *data;

@end

@interface MEGroupOrderModel : MEBaseModel

@property (nonatomic, strong) NSString * all_freight;
@property (nonatomic, assign) NSInteger all_integral;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * goods_price;
@property (nonatomic, assign) NSInteger group_id;
@property (nonatomic, strong) NSString * group_price;
@property (nonatomic, strong) NSString * group_sn;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * images_url;
@property (nonatomic, assign) NSInteger is_apprise;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * order_amount;
@property (nonatomic, strong) NSString * order_discount_amount;
@property (nonatomic, assign) NSInteger order_discount_num;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * order_spec_name;
@property (nonatomic, strong) NSString * order_status;
@property (nonatomic, strong) NSString * order_status_name;
@property (nonatomic, assign) NSInteger order_type;
@property (nonatomic, strong) NSString * product_name;
@property (nonatomic, assign) NSInteger product_number;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * warehouse_ids;
@property (nonatomic, strong) NSArray *express_detail;

@end

NS_ASSUME_NONNULL_END
