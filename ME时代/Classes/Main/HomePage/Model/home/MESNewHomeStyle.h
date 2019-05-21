//
//  MESNewHomeStyle.h
//  ME时代
//
//  Created by hank on 2018/12/4.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MESNewContentHomeStyle : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger style_type;
@property (nonatomic, assign) NSInteger tool;
@property (nonatomic, strong) NSString * updated_at;

@end

@interface MESNewHomeStyle : MEBaseModel

@property (nonatomic, strong) MESNewContentHomeStyle * top_style;
@property (nonatomic, strong) MESNewContentHomeStyle * shop_style;
@property (nonatomic, strong) MESNewContentHomeStyle * posters_style;
@property (nonatomic, strong) MESNewContentHomeStyle * article_style;
@property (nonatomic, strong) MESNewContentHomeStyle * store_style;

@property (nonatomic, strong) MESNewContentHomeStyle * gift_style;
@property (nonatomic, strong) MESNewContentHomeStyle * taobao_coupon_style;
@end
