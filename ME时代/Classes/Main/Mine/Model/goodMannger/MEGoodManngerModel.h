//
//  MEGoodManngerModel.h
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGoodManngerModel : MEBaseModel

@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString * image_rec;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * images_hot;
@property (nonatomic, strong) NSString * interval_price;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, assign) NSInteger ratio_after_sales;
@property (nonatomic, assign) NSInteger ratio_marketing;
@property (nonatomic, assign) NSInteger ratio_store;
@property (nonatomic, assign) NSInteger reserve_num;
@property (nonatomic, strong) NSString * sales;
//@property (nonatomic, strong) NSArray * spec;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;


@end

NS_ASSUME_NONNULL_END
