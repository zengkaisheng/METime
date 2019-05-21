//
//  MECoupleMailDetalVC.h
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MECoupleModel;
@class MEPinduoduoCoupleModel;
@interface MECoupleMailDetalVC : MEBaseVC

- (instancetype)initWithModel:(MECoupleModel *)model;
- (instancetype)initWithPinduoudoModel:(MEPinduoduoCoupleModel *)model;
- (instancetype)initWithProductrId:(NSString *)ProductrId couponId:(NSString *)couponId couponurl:(NSString *)couponurl;

@end
