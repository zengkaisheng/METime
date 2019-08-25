//
//  MEEditFollowsVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEEditFollowsVC : MEBaseVC

@property (nonatomic, copy) kMeObjBlock finishBlock;
@property (nonatomic, assign) BOOL isEdit;
 - (instancetype)initWithInfo:(NSDictionary *)info customerId:(NSInteger)customerId;

@end

NS_ASSUME_NONNULL_END
