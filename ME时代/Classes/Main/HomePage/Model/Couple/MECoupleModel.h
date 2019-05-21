//
//  MECoupleModel.h
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@class MECouponInfo;

@interface MECoupleSmallImageModel : MEBaseModel

@property (nonatomic, copy) NSArray *string;

@end

@interface MECoupleModel : MEBaseModel

//@property (nonatomic, strong) NSString * Cid;
//@property (nonatomic, strong) NSString * Commission;
//@property (nonatomic, strong) NSString * Commission_jihua;
//@property (nonatomic, strong) NSString * Commission_queqiao;
//@property (nonatomic, strong) NSString * D_title;
//@property (nonatomic, strong) NSString * Dsr;
//@property (nonatomic, strong) NSString * GoodsID;
//@property (nonatomic, strong) NSString * ID;
//@property (nonatomic, strong) NSString * Introduce;
//@property (nonatomic, strong) NSString * IsTmall;
//@property (nonatomic, strong) NSObject * Jihua_link;
//@property (nonatomic, strong) NSString * Jihua_shenhe;
//@property (nonatomic, strong) NSString * Org_Price;
//@property (nonatomic, strong) NSString * Pic;
//@property (nonatomic, strong) NSString * Price;
//@property (nonatomic, strong) NSString * Quan_condition;
//@property (nonatomic, strong) NSString * Quan_id;
//@property (nonatomic, strong) NSString * Quan_link;
//@property (nonatomic, strong) NSObject * Quan_m_link;
//@property (nonatomic, strong) NSString * Quan_price;
//@property (nonatomic, strong) NSString * Quan_receive;
//@property (nonatomic, strong) NSString * Quan_surplus;
//@property (nonatomic, strong) NSString * Quan_time;
//@property (nonatomic, strong) NSString * Que_siteid;
//@property (nonatomic, strong) NSString * Sales_num;
//@property (nonatomic, strong) NSString * SellerID;
//@property (nonatomic, strong) NSString * Title;
//@property (nonatomic, strong) NSString * Yongjin_type;


@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * commission_rate;
@property (nonatomic, strong) NSString * coupon_click_url;
@property (nonatomic, strong) NSString * coupon_end_time;
@property (nonatomic, strong) NSString * coupon_info;
@property (nonatomic, assign) NSInteger coupon_remain_count;
@property (nonatomic, strong) NSString * coupon_start_time;
@property (nonatomic, assign) NSInteger  coupon_total_count;
@property (nonatomic, strong) NSString * couponSale;
@property (nonatomic, strong) NSString * item_description;
@property (nonatomic, strong) NSString * item_url;
@property (nonatomic, strong) NSString * nick;
@property (nonatomic, strong) NSString * num_iid;
@property (nonatomic, strong) NSString * pict_url;
@property (nonatomic, strong) NSString * seller_id;
@property (nonatomic, strong) NSString * shop_title;
@property (nonatomic, strong) MECoupleSmallImageModel * small_images;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * user_type;
@property (nonatomic, strong) NSString * volume;
@property (nonatomic, strong) NSString * zk_final_price;
@property (nonatomic, strong) NSString * couponPrice;
@property (nonatomic, strong) NSString * truePrice;
@property (nonatomic, strong) NSString * coupon_share_url;
@property (nonatomic, strong) NSString * coupon_id;


- (void)resetModelWithModel:(MECouponInfo *)model;
@end
