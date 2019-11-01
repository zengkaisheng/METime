//
//  MEAppointmentDateModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAppointmentDateModel : MEBaseModel

@property (nonatomic, strong) NSString * appointment_date;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * day;
@property (nonatomic, assign) NSInteger has;

@end

NS_ASSUME_NONNULL_END
