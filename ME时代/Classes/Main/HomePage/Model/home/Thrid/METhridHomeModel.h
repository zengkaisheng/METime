//
//  METhridHomeModel.h
//  ME时代
//
//  Created by hank on 2019/1/24.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface METhridHomeStudyTogetherModel : MEBaseModel

@property (nonatomic, strong) NSArray * left_banner;      //左图
@property (nonatomic, strong) NSArray * right_banner;     //右图

@end


@interface METhridHomeBuyingGoodsModel : MEBaseModel

@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger product_type;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * interval_price;

@end

@interface METhridHomeAdModel : MEBaseModel

@property (nonatomic, strong) NSString * ad_id;
@property (nonatomic, strong) NSString * ad_name;
@property (nonatomic, strong) NSString * ad_img;
@property (nonatomic, assign) NSInteger ad_position_id;
@property (nonatomic, strong) NSString * ad_url;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * color_start;
@property (nonatomic, strong) NSString * color_end;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, strong) NSString * keywork;
@property (nonatomic, assign) NSInteger  show_type; //0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger tool;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger is_need_login;//0 不需要登录 1 需要登录
@property (nonatomic, assign) NSInteger bargain_id;  //砍价活动
@property (nonatomic, assign) NSInteger activity_id; //签到活动

@property (nonatomic, assign) NSInteger audio_id;    //音频ID
@property (nonatomic, assign) NSInteger video_id;    //视频ID


@end

@interface METhridHomeserviceModel : MEBaseModel

@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * interval_price;
@property (nonatomic, assign) NSInteger  product_id;

@end

@interface METhridHomeBackgroundModel : MEBaseModel

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * keyworks;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger show_type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger tool;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) NSInteger voting_id;

@end



@interface METhridHomeModel : MEBaseModel

@property (nonatomic, strong) METhridHomeBackgroundModel * coupon_background;
@property (nonatomic, strong) METhridHomeBackgroundModel * scare_buying_banner;
@property (nonatomic, strong) METhridHomeBackgroundModel * member_exclusive;
@property (nonatomic, strong) METhridHomeAdModel * right_bottom_img;
@property (nonatomic, strong) NSArray * scare_buying_goods;
@property (nonatomic, strong) NSArray * service;
@property (nonatomic, strong) NSArray * top_banner;
@property (nonatomic, strong) NSString *member_of_the_ritual_image;

@property (nonatomic, strong) NSArray * media_banner;      //首页课程banner
@property (nonatomic, strong) NSArray * excellent_course;  //精品课程
@property (nonatomic, strong) METhridHomeStudyTogetherModel *study_together;//一起学习

@end

NS_ASSUME_NONNULL_END
