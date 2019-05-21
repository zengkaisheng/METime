//
//  MEAppointmentModel.h
//  ME时代
//
//  Created by hank on 2018/10/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEAppointmentModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger is_use;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * reserve_sn;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * reserve_number;
@end
