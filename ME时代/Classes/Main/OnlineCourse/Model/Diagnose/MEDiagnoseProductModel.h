//
//  MEDiagnoseProductModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEDiagnoseProductModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * telephone;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * type_name;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
