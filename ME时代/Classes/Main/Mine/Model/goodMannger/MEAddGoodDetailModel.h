//
//  MEAddGoodDetailModel.h
//  ME时代
//
//  Created by hank on 2019/3/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddGoodDetailGroupModel : MEBaseModel

@property (nonatomic,strong) NSString *group_num;
@property (nonatomic,strong) NSString *group_desc;
@property (nonatomic,strong) NSString *over_time;
@property (nonatomic,strong) NSString *red_packet;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *end_time;

@end

@interface MEAddGoodDetailSpecIdsValueModel : MEBaseModel

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *value;

@end

@interface MEAddGoodDetailSpecIdsModel : MEBaseModel

@property (nonatomic, copy) NSArray *spec_ids_value;
@property (nonatomic, strong) NSString *goods_price;
@property (nonatomic, strong) NSString *stock;
//购物
@property (nonatomic, strong) NSString *integral;
//分享
@property (nonatomic, strong) NSString *shop_integral;
@property (nonatomic, strong) NSString *spec_img;

@end

@interface MEAddGoodDetailSpecNameModel : MEBaseModel

@property (nonatomic,strong) NSArray *value;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *name;

@end


@interface MEAddGoodDetailModel : MEBaseModel

@property (nonatomic, assign) NSInteger article_category_id;
@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSString * category_name;
@property (nonatomic, assign) NSInteger company_id;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * image_rec;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * images_hot;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, strong) NSString * integral_lines;
@property (nonatomic, strong) NSString * intervalPrice;
@property (nonatomic, assign) NSInteger is_clerk_share;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_first_buy;
@property (nonatomic, assign) NSInteger is_hot;
@property (nonatomic, assign) NSInteger is_integral_convert;
@property (nonatomic, strong) NSString * is_meidou_exchang;
@property (nonatomic, strong) NSString * is_member_buy;
@property (nonatomic, assign) NSInteger is_new;
@property (nonatomic, assign) NSInteger is_recommend;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString *list_order;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * money;
//@property (nonatomic, strong) OtherProduct * otherProduct;
@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, strong) NSString * postage;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger product_position;
@property (nonatomic, assign) NSInteger product_type;
@property (nonatomic, assign) NSInteger ratio_after_sales;
@property (nonatomic, assign) NSInteger ratio_clerk;
@property (nonatomic, assign) NSInteger ratio_marketing;
@property (nonatomic, assign) NSInteger ratio_store;
@property (nonatomic, strong) NSString * reserve_end_time;
@property (nonatomic, assign) NSInteger reserve_num;
@property (nonatomic, strong) NSString * reserve_start_time;
@property (nonatomic, strong) NSString *restrict_num;
@property (nonatomic, strong) NSArray * seckill_time;
@property (nonatomic, strong) NSArray * spec_ids;
@property (nonatomic, strong) NSArray * spec_name;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger store_product_type;
@property (nonatomic, strong) NSString * tips;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * top_video;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger view_count;
@property (nonatomic, strong) MEAddGoodDetailGroupModel *group;

@end

NS_ASSUME_NONNULL_END
