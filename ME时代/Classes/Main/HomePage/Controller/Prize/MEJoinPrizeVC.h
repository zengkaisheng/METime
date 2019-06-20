//
//  MEJoinPrizeVC.h
//  ME时代
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEJoinPrizeVC : MEBaseVC

- (instancetype)initWithActivityId:(NSString *)activityId;

@property (nonatomic, copy) kMeBasicBlock finishBlock;

@end

NS_ASSUME_NONNULL_END
