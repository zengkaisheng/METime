//
//  MEAppointmentListModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAppointmentListModel : MEBaseModel

@property (nonatomic, strong) NSString * appointment_date;
@property (nonatomic, strong) NSString * appointment_time;
@property (nonatomic, assign) NSInteger cosmetologist;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger customer_files_id;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger object_id;
@property (nonatomic, strong) NSString * object_name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) NSInteger sales_consultant;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger workmanship_charge;

@property (nonatomic, strong) NSString * sales_consultant_name;
@property (nonatomic, strong) NSString * cosmetologist_name;
@property (nonatomic, assign) NSInteger is_confirm;

@end

NS_ASSUME_NONNULL_END
