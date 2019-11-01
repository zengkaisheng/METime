//
//  MEHomeRecommendModel.h
//  志愿星
//
//  Created by gao lei on 2019/7/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEHomeRecommendModel : MEBaseModel

@property (nonatomic, assign) NSInteger article_category_id;
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger company_id;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * end_time;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger ids;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * image_rec;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * images_hot;
@property (nonatomic, strong) NSString * images_hot_url;
@property (nonatomic, strong) NSString * images_url;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, strong) NSString * integral_lines;
@property (nonatomic, strong) NSString * interval_price;
@property (nonatomic, assign) NSInteger is_clerk_share;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_delete;
@property (nonatomic, assign) NSInteger is_first_buy;
@property (nonatomic, assign) NSInteger is_hot;
@property (nonatomic, assign) NSInteger is_integral_convert;
@property (nonatomic, assign) NSInteger is_meidou_exchang;
@property (nonatomic, strong) NSString * is_member_buy;
@property (nonatomic, assign) NSInteger is_new;
@property (nonatomic, assign) NSInteger is_recommend;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger list_order;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, assign) NSInteger only_weapp_show;
@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, strong) NSString * postage;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger product_position;
@property (nonatomic, assign) NSInteger product_type;
@property (nonatomic, assign) NSInteger ratio_after_sales;
@property (nonatomic, assign) NSInteger ratio_clerk;
@property (nonatomic, assign) NSInteger ratio_marketing;
@property (nonatomic, assign) NSInteger ratio_store;
@property (nonatomic, assign) NSInteger reserve_num;
@property (nonatomic, assign) NSInteger restrict_num;
@property (nonatomic, strong) NSString * seckill_time;
@property (nonatomic, strong) NSString * start_time;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger stock;//库存
@property (nonatomic, assign) NSInteger sell_num;//销量
@property (nonatomic, assign) NSInteger sales;//虚拟销量
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger store_product_type;
@property (nonatomic, strong) NSString * tips;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * top_video;
@property (nonatomic, assign) NSInteger type;//1商品、2砍价、3拼团、4秒杀、5签到
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger view_count;
//砍价
@property (nonatomic, strong) NSString * amount_money;
@property (nonatomic, assign) NSInteger bargin_count;
@property (nonatomic, assign) NSInteger bargin_num;
@property (nonatomic, assign) NSInteger bargin_type;
@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) NSInteger hours;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, strong) NSString * rule;
@property (nonatomic, assign) NSInteger start_num;
@property (nonatomic, assign) NSInteger finish_bargin_num;
//拼团
@property (nonatomic, assign) NSInteger finish_group_total;
@property (nonatomic, strong) NSString * group_desc;
@property (nonatomic, strong) NSString * group_num;
@property (nonatomic, assign) NSInteger group_total;
@property (nonatomic, strong) NSString * image_url;
@property (nonatomic, assign) NSInteger over_time;
@property (nonatomic, strong) NSString * red_packet;
@property (nonatomic, strong) NSString * share_packet;
//签到
@property (nonatomic, assign) NSInteger join_number;
@property (nonatomic, assign) NSInteger join_type;
@property (nonatomic, assign) NSInteger total;
@end

NS_ASSUME_NONNULL_END
