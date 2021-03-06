//
//  MECoupleMailDetalVC.h
//  志愿星
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MECoupleModel;
@class MEPinduoduoCoupleModel;
@interface MECoupleMailDetalVC : MEBaseVC

@property (nonatomic, assign) BOOL isDynamic;
//@property (nonatomic, assign) NSInteger recordType;//区分位置 1、首页 2、优选 3、动态

- (instancetype)initWithModel:(MECoupleModel *)model;
- (instancetype)initWithPinduoudoModel:(MEPinduoduoCoupleModel *)model;
- (instancetype)initWithProductrId:(NSString *)ProductrId couponId:(NSString *)couponId couponurl:(NSString *)couponurl Model:(MECoupleModel *)model;


@end
