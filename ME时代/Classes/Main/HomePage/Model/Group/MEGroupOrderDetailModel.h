//
//  MEGroupOrderDetailModel.h
//  ME时代
//
//  Created by gao lei on 2019/7/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGroupOrderGoodSpecModel : MEBaseModel

@property (nonatomic, strong) NSString * goods_price;
@property (nonatomic, strong) NSString * group_price;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * integral_lines;
@property (nonatomic, strong) NSString * seckill_price;
@property (nonatomic, strong) NSString * spec_img;
@property (nonatomic, assign) NSInteger stock;

@end


@interface MEGroupMemberModel : MEBaseModel

@property (nonatomic, assign) NSInteger group_id;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger is_group;
@property (nonatomic, assign) NSInteger is_oneself;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * name;

@end


@interface MEGroupOrderAddresModel : MEBaseModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger address_id;
@property (nonatomic, strong) NSString * area_id;
@property (nonatomic, strong) NSString * city_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * province_id;
@property (nonatomic, strong) NSString * standby_mobile;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString * updated_at;

@end


@interface MEGroupOrderGoodsModel : MEBaseModel

@property (nonatomic, assign) NSInteger address_edit;
@property (nonatomic, strong) NSString * all_amount;
@property (nonatomic, assign) NSInteger apprise_status;
@property (nonatomic, strong) NSString * channel;
@property (nonatomic, assign) NSInteger company_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * freight;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_export;
@property (nonatomic, strong) NSString * order_goods_sn;
@property (nonatomic, strong) NSString * order_goods_status;
@property (nonatomic, strong) NSString * order_goods_status_name;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * order_spec_id;
@property (nonatomic, strong) NSString * order_spec_name;
@property (nonatomic, strong) NSString * product_amount;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * product_image;
@property (nonatomic, strong) NSString * product_name;
@property (nonatomic, assign) NSInteger product_number;
@property (nonatomic, assign) NSInteger product_type;
@property (nonatomic, strong) NSString * refund_sn;
@property (nonatomic, strong) NSString * refund_status;
@property (nonatomic, assign) NSInteger share_id;
@property (nonatomic, assign) NSInteger share_uid;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger warehouse_id;

@end


@interface MEGroupOrderDetailModel : MEBaseModel

@property (nonatomic, strong) MEGroupOrderAddresModel * address;
@property (nonatomic, strong) NSString * all_freight;
@property (nonatomic, assign) NSInteger all_integral;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSArray * groupMember;
@property (nonatomic, assign) NSInteger group_id;
@property (nonatomic, strong) NSString * group_sn;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * image_url;
@property (nonatomic, assign) NSInteger is_apprise;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger need_num;
@property (nonatomic, strong) NSString * group_num;
@property (nonatomic, strong) NSString * order_amount;
@property (nonatomic, strong) NSString * order_discount_amount;
@property (nonatomic, assign) NSInteger order_discount_num;
@property (nonatomic, strong) MEGroupOrderGoodsModel * order_goods;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * order_status;
@property (nonatomic, strong) NSString * order_status_name;
@property (nonatomic, assign) NSInteger order_type;
@property (nonatomic, strong) NSString * over_time;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * warehouse_ids;

@property (nonatomic, strong) MEGroupOrderGoodSpecModel *goods_spec;

@end

NS_ASSUME_NONNULL_END
