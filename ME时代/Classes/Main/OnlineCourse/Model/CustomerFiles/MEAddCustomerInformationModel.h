//
//  MEAddCustomerInformationModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddCustomerInformationModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * wechat;
@property (nonatomic, strong) NSString * qq;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * best_communication_time;
@property (nonatomic, strong) NSString * tall;
@property (nonatomic, strong) NSString * weight;
@property (nonatomic, strong) NSString * blood_type;
@property (nonatomic, strong) NSString * interest;
@property (nonatomic, strong) NSString * traits_of_character;
@property (nonatomic, strong) NSString * married;
@property (nonatomic, strong) NSString * job;
@property (nonatomic, strong) NSString * month_earning;
@property (nonatomic, strong) NSString * consumption_habit;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * customer_classify_id;

@end

NS_ASSUME_NONNULL_END
