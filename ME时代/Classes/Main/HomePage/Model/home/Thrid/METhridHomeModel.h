//
//  METhridHomeModel.h
//  ME时代
//
//  Created by hank on 2019/1/24.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


//"product_id": 12,
//"product_type": 5,
//"images": "c6d1763e0b0b54f0780ce312861d83f5",
//"title": "ME时代负离子咖啡因连体身材管理器（买一套送一套）",
//"market_price": "3980.00",
//"money": "3980.00",
//"desc": "",
//"interval_price": "3980"

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
@property (nonatomic, strong) NSString * ad_url;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * color_start;
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
@property (nonatomic, strong) NSArray * scare_buying_goods;
@property (nonatomic, strong) NSArray * service;
@property (nonatomic, strong) NSArray * top_banner;
@property (nonatomic, strong) NSString *member_of_the_ritual_image;

@end

NS_ASSUME_NONNULL_END
