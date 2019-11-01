//
//  MECheckAllPrizePeopleVC.h
//  志愿星
//
//  Created by gao lei on 2019/6/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECheckAllPrizePeopleVC : MEBaseVC

@property (nonatomic,copy) kMeBasicBlock reloadBlock;
- (instancetype)initWithType:(NSInteger)type count:(NSInteger)count activityId:(NSInteger)activityId;

@end

NS_ASSUME_NONNULL_END
