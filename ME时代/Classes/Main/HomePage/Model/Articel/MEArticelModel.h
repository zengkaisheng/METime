//
//  MEArticelModel.h
//  ME时代
//
//  Created by hank on 2018/12/3.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEArticelModel : MEBaseModel

@property (nonatomic, assign) NSInteger article_category_id;
@property (nonatomic, assign) NSInteger article_id;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * copyright_notice;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * images_url;
@property (nonatomic, strong) NSString * pay_model;
@property (nonatomic, assign) NSInteger read;
@property (nonatomic, assign) NSInteger share;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * created_at;
@end
