//
//  MEMyOrderDetailVC.h
//  志愿星
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEMyOrderDetailVC : MEBaseVC

- (instancetype)initWithType:(MEOrderStyle)type orderGoodsSn:(NSString *)orderGoodsSn;
- (instancetype)initWithOrderGoodsSn:(NSString *)orderGoodsSn;
//自提
- (instancetype)initSelfWithType:(MEOrderStyle)type orderGoodsSn:(NSString *)orderGoodsSn;

@property (nonatomic, assign) BOOL isTopUp;//联通充值订单
@end
