//
//  MERecruitDetailVC.h
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MERecruitDetailVC : MEBaseVC

- (instancetype)initWithRecruitId:(NSInteger)recruitId;

- (instancetype)initWithRecruitId:(NSInteger)recruitId latitude:(NSString *)latitude longitude:(NSString *)longitude;


@end

NS_ASSUME_NONNULL_END
