//
//  MEPinduoduoCoupleInfoModel.h
//  ME时代
//
//  Created by hank on 2019/1/17.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEPinduoduoCoupleInfoModel : MEBaseModel

@property (nonatomic, assign) NSInteger avgDesc;
@property (nonatomic, assign) NSInteger avgLgst;
@property (nonatomic, assign) NSInteger avgServ;
@property (nonatomic, strong) NSString * catId;
@property (nonatomic, strong) NSArray * catIds;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString * categoryName;
//优惠券面额，单位为分
@property (nonatomic, assign) NSInteger coupon_discount;
//优惠券失效时间，UNIX时间戳
@property (nonatomic, strong) NSString * coupon_end_time;
@property (nonatomic, assign) NSInteger couponMinOrderAmount;
//优惠券剩余数量
@property (nonatomic, assign) NSInteger coupon_remain_quantity;
//优惠券生效时间，UNIX时间戳
@property (nonatomic, strong) NSString * coupon_start_time;
//优惠券总数量
@property (nonatomic, assign) NSInteger coupon_total_quantity;
@property (nonatomic, assign) NSInteger createAt;
@property (nonatomic, assign) CGFloat descPct;
@property (nonatomic, strong) NSString * goodsDesc;
@property (nonatomic, assign) NSInteger goodsEvalCount;
@property (nonatomic, assign) NSInteger goodsEvalScore;
//商品轮播图
@property (nonatomic, strong) NSArray * goods_gallery_urls;
@property (nonatomic, assign) NSInteger goodsId;
//多多进宝商品主图
@property (nonatomic, strong) NSString * goods_image_url;
//商品名称
@property (nonatomic, strong) NSString * goods_name;
@property (nonatomic, strong) NSString * goods_thumbnail_url;
@property (nonatomic, assign) BOOL hasCoupon;
@property (nonatomic, strong) NSString * hasMallCoupon;
@property (nonatomic, assign) CGFloat lgstPct;
@property (nonatomic, strong) NSString * mallCouponDiscountPct;
@property (nonatomic, strong) NSString * mallCouponEndTime;
@property (nonatomic, strong) NSString * mallCouponId;
@property (nonatomic, strong) NSString * mallCouponMaxDiscountAmount;
@property (nonatomic, strong) NSString * mallCouponMinOrderAmount;
@property (nonatomic, strong) NSString * mallCouponRemainQuantity;
@property (nonatomic, strong) NSString * mallCouponStartTime;
@property (nonatomic, strong) NSString * mallCouponTotalQuantity;
@property (nonatomic, assign) NSInteger mallCps;
@property (nonatomic, assign) NSInteger mallId;
@property (nonatomic, strong) NSString * mallName;
@property (nonatomic, assign) NSInteger mallRate;
@property (nonatomic, assign) NSInteger merchantType;
@property (nonatomic, assign) NSInteger minGroupPrice;
@property (nonatomic, assign) NSInteger min_group_price;
@property (nonatomic, assign) NSInteger optId;
@property (nonatomic, strong) NSArray * optIds;
@property (nonatomic, strong) NSString * optName;
@property (nonatomic, assign) NSInteger promotionRate;
@property (nonatomic, assign) CGFloat servPct;
//已售卖件数
@property (nonatomic, assign) NSInteger sold_quantity;

@end

NS_ASSUME_NONNULL_END
