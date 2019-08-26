//
//  MECustomerServiceDetailModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEServiceDetailSubModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger customer_files_id;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * open_card_time;
@property (nonatomic, assign) NSInteger residue_num;
@property (nonatomic, strong) NSString * residue_time;
@property (nonatomic, strong) NSString * service_name;
@property (nonatomic, assign) NSInteger total_num;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;

@end


@interface MECustomerServiceDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * annual_average;
@property (nonatomic, strong) NSString * best_communication_time;
@property (nonatomic, strong) NSArray * ci_card_service;
@property (nonatomic, assign) NSInteger come_total;
@property (nonatomic, strong) NSString * consumption_habit;
@property (nonatomic, strong) NSString * monthly_average;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSArray * product_service;
@property (nonatomic, strong) NSString * qq;
@property (nonatomic, strong) NSArray * time_card_service;
@property (nonatomic, strong) NSString * wechat;
@property (nonatomic, assign) NSInteger idField;

@end

NS_ASSUME_NONNULL_END
