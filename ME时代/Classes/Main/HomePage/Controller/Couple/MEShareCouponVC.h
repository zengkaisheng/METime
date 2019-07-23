//
//  MEShareCouponVC.h
//  ME时代
//
//  Created by gao lei on 2019/7/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MECoupleModel;
@class MEPinduoduoCoupleInfoModel;
@class MEJDCoupleModel;

@interface MEShareCouponVC : MEBaseVC

- (instancetype)initWithTBModel:(MECoupleModel *)model codeword:(NSString *)codeword;
- (instancetype)initWithPDDModel:(MEPinduoduoCoupleInfoModel *)model codeword:(NSString *)codeword;
- (instancetype)initWithJDModel:(MEJDCoupleModel *)model codeword:(NSString *)codeword;

@end

NS_ASSUME_NONNULL_END
