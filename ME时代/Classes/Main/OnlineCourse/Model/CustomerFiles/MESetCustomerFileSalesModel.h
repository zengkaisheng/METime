//
//  MESetCustomerFileSalesModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MESetCustomerFileSalesModel : MEBaseModel

@property (nonatomic, assign) NSInteger customer_files_id;

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * objectives_and_requirements;
@property (nonatomic, strong) NSString * interest_object;
@property (nonatomic, strong) NSString * main_projects;
@property (nonatomic, strong) NSString * consumption;

@end

NS_ASSUME_NONNULL_END
