//
//  MECoupleMailVC.h
//  志愿星
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MECoupleMailVC : MEBaseVC

- (instancetype)initWithQuery:(NSString *)query;
- (instancetype)initWithType:(MECouponSearchType)type;
- (instancetype)initWithAdId:(NSString *)adId;

@property (nonatomic,copy) NSString *titleStr;


@end
