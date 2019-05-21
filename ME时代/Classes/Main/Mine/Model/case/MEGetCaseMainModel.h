//
//  MEGetCaseMainModel.h
//  ME时代
//
//  Created by hank on 2018/12/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEGetCaseMainModel : MEBaseModel

@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSString * all_money;
@property (nonatomic, strong) NSString * bank;
@property (nonatomic, strong) NSString * branch;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * checked_at;
@property (nonatomic, strong) NSString * error_desc;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, assign) NSInteger money_check_id;
@property (nonatomic, strong) NSString * nullity_money;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * payed_at;
@property (nonatomic, strong) NSString * service_money;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * true_name;
@property (nonatomic, strong) NSString * updated_at;

@end
