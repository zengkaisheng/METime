//
//  METopUpSuccessVC.h
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface METopUpSuccessVC : MEBaseVC

- (instancetype)initWithMoney:(NSString *)money sucessConfireBlock:(kMeBasicBlock)block;

@end

NS_ASSUME_NONNULL_END
