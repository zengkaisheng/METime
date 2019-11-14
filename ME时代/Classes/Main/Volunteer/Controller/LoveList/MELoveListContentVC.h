//
//  MELoveListContentVC.h
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MELoveListContentVC : MEBaseVC

- (instancetype)initWithType:(NSInteger)type dateType:(NSString *)dateType;

- (void)reloadDatasWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
