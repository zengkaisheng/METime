//
//  MERefundModel.h
//  ME时代
//
//  Created by gao lei on 2019/5/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MERefundGoodModel : MEBaseModel

@property (nonatomic, strong) NSString *product_name;
@property (nonatomic, strong) NSString *product_image;
@property (nonatomic, strong) NSString *order_spec_name;
@property (nonatomic, strong) NSString *order_goods_status;
@property (nonatomic, assign) NSInteger product_number;
@property (nonatomic, strong) NSString *product_amount;
@property (nonatomic, strong) NSString *product_image_url;
@property (nonatomic, strong) NSString *order_goods_status_name;

@end

@interface MERefundModel : MEBaseModel

@property (nonatomic, strong) NSString *refund_sn;
@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic, strong) NSString *refund_money;
@property (nonatomic, assign) NSInteger refund_status; //1、退款中 2、退款成功 3、退款失败
@property (nonatomic, strong) NSArray *order_goods;
@property (nonatomic, strong) NSString *refund_status_name;

@end

NS_ASSUME_NONNULL_END
