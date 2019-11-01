//
//  MECustomerTypeListVC.h
//  志愿星
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MELivingHabitListModel;

@interface MECustomerTypeListVC : MEBaseVC

@property (nonatomic, copy) kMeObjBlock contentBlock;
@property (nonatomic, copy) kMeBasicBlock deleteBlock;

- (instancetype)initWithHabitModel:(MELivingHabitListModel *)model;

@end

NS_ASSUME_NONNULL_END
