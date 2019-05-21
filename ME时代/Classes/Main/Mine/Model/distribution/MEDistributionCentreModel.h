//
//  MEDistributionCentreModel.h
//  ME时代
//
//  Created by gao lei on 2018/9/21.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEDistributionCentreModel : MEBaseModel

@property (nonatomic, assign) NSInteger all_integral;
@property (nonatomic, assign) NSInteger count_order;
@property (nonatomic, assign) NSInteger count_user;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, strong) NSString * parent_name;
@property (nonatomic, assign) NSInteger use_integral;
@property (nonatomic, assign) NSInteger wait_integral;

@end
