//
//  MEFourCouponSearchBaseVC.h
//  志愿星
//
//  Created by gao lei on 2019/6/17.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEFourCouponSearchBaseVC : MEBaseVC

- (instancetype)initWithType:(NSInteger)type;

- (void)searchCouponDataWithQueryStr:(NSString *)query;

@end

NS_ASSUME_NONNULL_END
