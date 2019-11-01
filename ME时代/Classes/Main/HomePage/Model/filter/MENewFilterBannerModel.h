//
//  MENewFilterBannerModel.h
//  志愿星
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MENewFilterBannerModel : MEBaseModel

@property (nonatomic, strong) NSString *ad_id;
@property (nonatomic, strong) NSString *ad_name;
@property (nonatomic, strong) NSString *ad_img;
@property (nonatomic, assign) NSInteger ad_position_id;
@property (nonatomic, strong) NSString *ad_url;
@property (nonatomic, strong) NSString *color_end;
@property (nonatomic, strong) NSString *color_start;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *deleted_at;
@property (nonatomic, strong) NSString *end_at;
@property (nonatomic, strong) NSString *keywork;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger show_type;
@property (nonatomic, strong) NSString *start_at;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger tool;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *updated_at;

@end

NS_ASSUME_NONNULL_END
