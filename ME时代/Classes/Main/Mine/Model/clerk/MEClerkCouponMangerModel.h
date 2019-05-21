//
//  MEClerkCouponMangerModel.h
//  ME时代
//
//  Created by hank on 2019/5/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEClerkCouponMangerModel : MEBaseModel

@property (nonatomic, strong) NSString * clerk_commission_ratio;
@property (nonatomic, assign) BOOL isset_clerk_commission_ratio;
@property (nonatomic, strong) NSString * system_clerk_percent;

@end

NS_ASSUME_NONNULL_END
