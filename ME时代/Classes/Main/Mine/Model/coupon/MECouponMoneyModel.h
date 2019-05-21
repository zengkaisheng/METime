//
//  MECouponMoneyModel.h
//  ME时代
//
//  Created by hank on 2019/1/24.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECouponMoneyModel : MEBaseModel
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * goods_thumbnail_url;
@property (nonatomic, strong) NSString * goods_name;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) CGFloat promotion_rate;
@property (nonatomic, assign) CGFloat order_amount;
@property (nonatomic, assign) CGFloat promotion_amount;


@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, assign) NSInteger goodsPrice;
@property (nonatomic, assign) NSInteger goodsQuantity;

@property (nonatomic, strong) NSString * haveStatistical;
@property (nonatomic, assign) NSInteger idField;

@property (nonatomic, assign) NSInteger orderCreateTime;
@property (nonatomic, strong) NSString * orderGroupSuccessTime;
@property (nonatomic, assign) NSInteger orderModifyAt;
@property (nonatomic, strong) NSString * orderPayTime;
@property (nonatomic, strong) NSString * orderSn;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, strong) NSString * orderStatusDesc;
@property (nonatomic, strong) NSString * orderVerifyTime;
@property (nonatomic, strong) NSString * pId;

@property (nonatomic, strong) NSString * updatedAt;

@end

NS_ASSUME_NONNULL_END
