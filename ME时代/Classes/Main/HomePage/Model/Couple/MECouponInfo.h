//
//  MECouponInfo.h
//  ME时代
//
//  Created by hank on 2019/1/4.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECouponInfo : MEBaseModel

@property (nonatomic, strong) NSString * coupon_activity_id;
@property (nonatomic, strong) NSString * coupon_amount;
@property (nonatomic, strong) NSString * coupon_end_time;
@property (nonatomic, assign) NSInteger coupon_remain_count;
@property (nonatomic, assign) NSInteger coupon_src_scene;
@property (nonatomic, strong) NSString * coupon_start_fee;
@property (nonatomic, strong) NSString * coupon_start_time;
@property (nonatomic, assign) NSInteger coupon_total_count;
@property (nonatomic, assign) NSInteger coupon_type;

@end

NS_ASSUME_NONNULL_END
