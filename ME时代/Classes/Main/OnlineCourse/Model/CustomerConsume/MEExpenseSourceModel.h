//
//  MEExpenseSourceModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEExpenseSourceModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * option;
@property (nonatomic, strong) NSString * nature;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger type; //1.来源 2.产品性质

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
