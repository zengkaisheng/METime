//
//  MECouponMaterModel.h
//  ME时代
//
//  Created by hank on 2019/1/4.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECouponMaterModel : MEBaseModel

@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, strong) NSString * commission_rate;
@property (nonatomic, strong) NSString * coupon_id;
@property (nonatomic, assign) NSInteger coupon_remain_count;
@property (nonatomic, strong) NSString * coupon_share_url;
@property (nonatomic, assign) NSInteger coupon_total_count;
@property (nonatomic, strong) NSString * item_url;
@property (nonatomic, assign) NSInteger num_iid;
@property (nonatomic, strong) NSString * pict_url;
@property (nonatomic, assign) NSInteger seller_id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, assign) NSInteger volume;
@property (nonatomic, strong) NSString * white_image;
@property (nonatomic, strong) NSString * zk_final_price;

@end

NS_ASSUME_NONNULL_END
