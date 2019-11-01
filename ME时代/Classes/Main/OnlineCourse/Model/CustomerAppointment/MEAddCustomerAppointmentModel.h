//
//  MEAddCustomerAppointmentModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddCustomerAppointmentModel : MEBaseModel

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * customer_files_id;//顾客档案ID
@property (nonatomic, strong) NSString * appointment_date;//预约日期
@property (nonatomic, strong) NSString * appointment_time;//预约时间
@property (nonatomic, strong) NSString * object_id;       //项目ID
@property (nonatomic, strong) NSString * sales_consultant;//销售顾问member_id
@property (nonatomic, strong) NSString * cosmetologist;   //美容师member_id
@property (nonatomic, strong) NSString * workmanship_charge;//手工费

@end

NS_ASSUME_NONNULL_END
