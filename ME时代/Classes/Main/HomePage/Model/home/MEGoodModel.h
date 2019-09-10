//
//  MEGoodModel.h
//  ME时代
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEGoodModel : MEBaseModel

@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * images_url;

@property (nonatomic, strong) NSString * market_price;//市场价
@property (nonatomic, strong) NSString * money;//真实价格
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger product_type;//1商品 7拼团商品 13砍价商品 17联通兑换商品
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * desc;
//推荐
@property (nonatomic, strong) NSString *image_rec;
@property (nonatomic, strong) NSString *image_rec_url;
//热门
@property (nonatomic, strong) NSString *images_hot;
@property (nonatomic, strong) NSString *images_hot_url;

//美豆相关
@property (nonatomic, strong) NSString * list_order;
@property (nonatomic, strong) NSString * integral_lines;

//预约
@property (nonatomic, strong) NSString * reserve_num;

@property (nonatomic, strong) NSString * time;

@property (nonatomic, strong) NSString * interval_price;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger join_type;
@property (nonatomic, strong) NSString * end_time;
@property (nonatomic, assign) NSInteger total;
//秒杀相关
@property (nonatomic, assign) NSInteger stock;//库存
@property (nonatomic, assign) NSInteger sell_num;//销量
@property (nonatomic, assign) NSInteger sales;//虚拟销量
//联通兑换
@property (nonatomic, assign) NSInteger get_phone_bill;//话费


@end
