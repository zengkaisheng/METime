//
//  METhridHomeRudeGoodModel.h
//  ME时代
//
//  Created by hank on 2019/1/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface METhridHomeRudeGoodModel : MEBaseModel

@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * imageRec;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * images_hot;
//区间价
@property (nonatomic, strong) NSString * interval_price;
//市场价
@property (nonatomic, strong) NSString * market_price;
//购买价
@property (nonatomic, strong) NSString * money;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger product_type;
//秒杀价
@property (nonatomic, strong) NSString * seckill_price;
@property (nonatomic, assign) NSInteger sell_num;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, strong) NSString * title;

@end

NS_ASSUME_NONNULL_END
