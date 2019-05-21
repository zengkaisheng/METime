//
//  MEMakeOrderAttrModel.h
//  ME时代
//
//  Created by hank on 2018/9/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@class MEGoodDetailModel;
@interface MEMakeOrderAttrModel : MEBaseModel

@property (nonatomic, strong) NSString * product_id;
@property (nonatomic, strong) NSString * spec_ids;
@property (nonatomic, strong) NSString * num;
//用户地址id 默认 wu
@property (nonatomic, strong) NSString * user_address;
@property (nonatomic, strong) NSString * token;
//1 普通下单 4 兑换积分下单 9秒杀下单 15兑换码商品
@property (nonatomic, strong) NSString * order_type;
@property (nonatomic, strong) NSString * store_id;
//分享者id 无人分享则填0
@property (nonatomic, strong) NSString * share_id;
// 默认 无
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * channel;

//来自好友的分享
@property (nonatomic, strong) NSString *uid;
- (instancetype)initWithGoodDetailModel:(MEGoodDetailModel *)model;

@end
