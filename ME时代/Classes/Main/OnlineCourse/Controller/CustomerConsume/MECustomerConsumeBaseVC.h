//
//  MECustomerConsumeBaseVC.h
//  志愿星
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECustomerConsumeBaseVC : MEBaseVC

- (instancetype)initWithClassifyId:(NSInteger)classifyId materialArray:(NSArray *)materialArray;

- (void)reloadDatas;

@end

NS_ASSUME_NONNULL_END
