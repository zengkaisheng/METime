//
//  MEPinduoduoCoupleModel.h
//  ME时代
//
//  Created by hank on 2019/1/16.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEPinduoduoCoupleModel : MEBaseModel
@property (nonatomic, copy) NSString *goods_id;
//商品缩略图
@property (nonatomic, copy) NSString *goods_thumbnail_url;
//商品名称
@property (nonatomic, copy) NSString *goods_name;
//优惠券总数量
@property (nonatomic, copy) NSString *coupon_total_quantity;
//优惠券剩余数量
@property (nonatomic, copy) NSString *coupon_remain_quantity;
//优惠券生效时间
@property (nonatomic, assign) NSInteger coupon_start_time;
//优惠券失效时间
@property (nonatomic, assign) NSInteger coupon_end_time;
//已售卖件数
@property (nonatomic, copy) NSString *sold_quantity;
//优惠券面额，单位为分
@property (nonatomic, assign) CGFloat coupon_discount;
//最小单买价格（单位为分）
//@property (nonatomic, assign) CGFloat min_normal_price;
@property (nonatomic, assign) CGFloat min_group_price;
@property (nonatomic, assign) CGFloat min_ratio;
@end

NS_ASSUME_NONNULL_END
