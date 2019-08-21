//
//  MECustomerDetailVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECustomerDetailVC : MEBaseVC

@property (nonatomic, copy) kMeBasicBlock finishBlock;

- (instancetype)initWithCustomerId:(NSInteger)customerId;

@property (nonatomic, assign) BOOL isAdd;

@end

NS_ASSUME_NONNULL_END
