//
//  MECareerHomeCategoryModel.h
//  ME时代
//
//  Created by gao lei on 2019/10/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECareerHomeCategoryModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
