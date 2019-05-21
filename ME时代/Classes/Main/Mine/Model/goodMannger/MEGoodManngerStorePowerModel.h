//
//  MEGoodManngerStorePowerModel.h
//  ME时代
//
//  Created by hank on 2019/3/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGoodManngerStorePowerModel : MEBaseModel
//1 是 2否
@property (nonatomic, assign) NSInteger is_services;

@property (nonatomic, assign) NSInteger is_goods;

@property (nonatomic, assign) NSInteger is_brokerage;

@end

NS_ASSUME_NONNULL_END
