//
//  MEBynamicHomeModel.h
//  ME时代
//
//  Created by hank on 2019/1/24.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MEBynamicHomepraiseModel : MEBaseModel

@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, strong) NSString * nick_name;

@end


@interface MEBynamicJDModel : MEBaseModel

@property (nonatomic, strong) NSString * url;

@end

@interface MEBynamicHomecommentModel : MEBaseModel

@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * content;

@end

@interface MEBynamicHomeModel : MEBaseModel

@property (nonatomic, strong) NSArray * comment;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, assign) NSString *idField;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSArray * praise;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL praise_over;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * goods_images;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * header_pic;

@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString *goods_title;
@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, assign) NSInteger skip_type;
@property (nonatomic, assign) CGFloat min_ratio;

//淘宝
@property (nonatomic, strong) NSString * tbk_num_iids;
@property (nonatomic, strong) NSString * tbk_coupon_id;
@property (nonatomic, strong) NSString * tbk_coupon_share_url;
//拼多多
@property (nonatomic, strong) NSString * ddk_goods_id;

//京东
@property (nonatomic, strong) NSString * jd_material_url;
@property (nonatomic, strong) NSString * jd_link;
@property (nonatomic, strong) NSArray * imageList;
@property (nonatomic, strong) NSString * skuName;
@property (nonatomic, strong) NSString * discount;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * useStartTime;
@property (nonatomic, strong) NSString * useEndTime;

@property (nonatomic, copy) NSString * ad_url; //活动链接
@property (nonatomic, copy) NSString * ad_id; //拼多多列表

@end

NS_ASSUME_NONNULL_END
