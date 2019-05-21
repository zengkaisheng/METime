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

@end
