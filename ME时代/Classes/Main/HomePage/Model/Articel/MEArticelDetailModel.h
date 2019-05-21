//
//  MEArticelDetailModel.h
//  ME时代
//
//  Created by hank on 2018/12/3.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEArticelDetailModel : MEBaseModel

@property (nonatomic, assign) NSInteger article_category_id;
@property (nonatomic, assign) NSInteger article_id;
@property (nonatomic, assign) NSInteger article_type;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * copyright_notice;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * images_url;
@property (nonatomic, assign) NSInteger list_order;
@property (nonatomic, strong) NSString * pay_model;
@property (nonatomic, assign) NSInteger read;
@property (nonatomic, assign) NSInteger share;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * tips;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * ad_images_url;
@property (nonatomic, strong) NSString * ad_url;
@property (nonatomic, assign) BOOL is_ad;
@end
