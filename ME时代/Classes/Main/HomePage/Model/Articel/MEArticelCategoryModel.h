//
//  MEArticelCategoryModel.h
//  ME时代
//
//  Created by hank on 2018/12/3.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEArticelCategoryModel : MEBaseModel

@property (nonatomic, strong) NSString * article_name;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, strong) NSString * updated_at;

@end
