//
//  MECustomerConsumeDetailVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECustomerConsumeDetailVC : MEBaseVC

@property (nonatomic, copy) kMeBasicBlock finishBlock;

- (instancetype)initWithPhone:(NSString *)phone;

- (instancetype)initWithFilesId:(NSInteger)filesId;

@end

NS_ASSUME_NONNULL_END
