//
//  MECouponBtModel.h
//  ME时代
//
//  Created by hank on 2019/4/30.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECouponBtModel : MEBaseModel


@property (nonatomic, assign) NSInteger check;
@property (nonatomic, strong) NSString * create_time;
@property (nonatomic, strong) NSString * expected_money;
@property (nonatomic, assign) NSInteger item_num;
@property (nonatomic, strong) NSString * item_title;
@property (nonatomic, strong) NSString * num_iid;
@property (nonatomic, strong) NSString * pic_url;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger ratio_status;
@property (nonatomic, strong) NSString * settle_money;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * status_name;

@end

NS_ASSUME_NONNULL_END
