//
//  MEEditCustomerInfomationVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEEditCustomerInfomationVC : MEBaseVC

@property (nonatomic, copy) kMeBasicBlock finishBlock;

- (instancetype)initWithInfo:(NSDictionary *)info customerId:(NSInteger)customerId;

@end

NS_ASSUME_NONNULL_END
