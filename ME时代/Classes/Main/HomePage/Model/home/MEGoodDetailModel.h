//
//  MEGoodDetailModel.h
//  志愿星
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MEPriceAndStockModel.h"
#import "MEGoodSpecModel.h"


@interface MEGoodDetailCommentModel : MEBaseModel

@property (nonatomic, strong) NSString * goodcomment;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * dateted_at;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger value;

@end


@interface MEGoodDetailSpecModel : MEBaseModel

@property (nonatomic, strong) NSString * spec_name;
@property (nonatomic, strong) NSArray * spec_value;


@end

@interface MEGoodDetailModel : MEBaseModel

@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * desc;
//市场价
@property (nonatomic, strong) NSString * market_price;
//原价
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSArray *spec;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * custom_uid;
//区间价 2.0.2
@property (nonatomic, strong) NSString * interval_price;
//美豆相关
@property (nonatomic, strong) NSString * integral_lines;//美豆数
@property (nonatomic, strong) NSString * postage;//邮费
//预约
@property (nonatomic, strong) NSString *reserve_num;
@property (nonatomic, assign) NSInteger is_first_buy;
//产品类型 15 兑换码商品
@property (nonatomic, assign) NSInteger product_type;
//销量
@property (nonatomic, strong) NSString *sales;
//访问量
@property (nonatomic, strong) NSString *browse;
//购买数量
@property (nonatomic,assign) NSInteger buynum;
//选中的price和stock
@property (nonatomic, strong) MEPriceAndStockModel * psmodel;
//当前选中 【@（1），@（0）】
@property (nonatomic, strong) NSMutableArray *arrSelect;
//选中的sku 规格 dfdsfds+dfsdf
@property (nonatomic, strong) NSString * skus;
//属性id 1,2
@property (nonatomic, strong) NSString * spec_ids;
@property (nonatomic, strong) NSString * skusImage;



//0 不能分享 1 可以
@property (nonatomic, strong) NSString *is_clerk_share;
//商品类型 0 普通 1秒杀 2预告
@property (nonatomic,assign) NSInteger is_seckill;
//秒杀开始
@property (nonatomic, strong) NSString *seckill_start_time;
//秒杀结束
@property (nonatomic, strong) NSString *seckill_end_time;
//限购数量
@property (nonatomic,assign) NSInteger restrict_num;
//限时秒杀
@property (nonatomic, strong) NSString *rudeTip;
//通知
@property (nonatomic, strong) NSString *message;
//提示
@property (nonatomic, strong) NSString *tips;
//评论
@property (nonatomic, strong) NSArray *product_comment;
//好评比
@property (nonatomic, strong) NSString *equities;
//销量
@property (nonatomic,assign) NSInteger sell_num;
//库存
@property (nonatomic,assign) NSInteger stock;
//评论总数
@property (nonatomic, strong) NSString * comment_count;
//好评数
@property (nonatomic, strong) NSString * good_comment_count;
//嗮图数
@property (nonatomic, strong) NSString * show_pic_comment_count;

@property (nonatomic,assign) NSInteger value;


//拼团相关
@property (nonatomic, assign) CGFloat day;
@property (nonatomic, strong) NSString * end_time;
@property (nonatomic, strong) NSString * group_desc;
@property (nonatomic, strong) NSString * group_num;
@property (nonatomic, assign) NSInteger over_time;
@property (nonatomic, strong) NSString * red_packet;
@property (nonatomic, strong) NSString * start_time;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * image_url;
@property (nonatomic, strong) NSString * now;
@property (nonatomic, strong) NSString * group_total;
@property (nonatomic, strong) NSString * finish_group_total;
@property (nonatomic, strong) NSString * group_price;
//拼团订单相关
@property (nonatomic, assign) NSInteger group_id;
@property (nonatomic, assign) NSInteger group_sn;
@property (nonatomic, assign) BOOL isGroup;

//签到相关
@property (nonatomic, strong) NSString * draw_price;
@property (nonatomic, assign) BOOL isPrize;
@property (nonatomic, strong) NSString * activity_id;

//视力预约
@property (nonatomic, assign) NSInteger only_weapp_show;
@property (nonatomic, strong) NSString * company_name;
@property (nonatomic, strong) NSString * company_province;
@property (nonatomic, strong) NSString * company_city;
@property (nonatomic, strong) NSString * company_area;
@property (nonatomic, strong) NSString * company_addr_detail;
@property (nonatomic, strong) NSString * company_longitude;
@property (nonatomic, strong) NSString * company_latitude;
@property (nonatomic, strong) NSString * company_phone;

@end


