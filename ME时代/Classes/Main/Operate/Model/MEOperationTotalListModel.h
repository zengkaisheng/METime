//
//  MEOperationTotalListModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEOperationTotalListModel : MEBaseModel

@property (nonatomic, assign) NSInteger customer_num;
@property (nonatomic, assign) NSInteger cosmetologist;
@property (nonatomic, strong) NSString * cosmetologist_name;
@property (nonatomic, assign) NSInteger workmanship_charge;

@property (nonatomic, assign) NSInteger type; //1.预约总数 2.手工费总数

@end

NS_ASSUME_NONNULL_END
