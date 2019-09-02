//
//  MECustomerExpenseDetailModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEExpenseDetailSubModel : MEBaseModel

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, strong) NSString * name;

@property (nonatomic, assign) NSInteger type;//1.充值 2.次卡 3.时间卡 4.产品

@property (nonatomic, assign) NSInteger customer_files_id;
@property (nonatomic, strong) NSString * expense_date;
@property (nonatomic, assign) NSInteger give_num;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) NSInteger source_id;
@property (nonatomic, assign) NSInteger total_num;
@property (nonatomic, strong) NSString * updated_at;

@end




@interface MECustomerExpenseDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * annual_average;    //年均消费
@property (nonatomic, strong) NSString * best_communication_time;//最佳致电时间
@property (nonatomic, strong) NSArray * ci_card;
@property (nonatomic, strong) NSString * classify_name;     //顾客分类名称
@property (nonatomic, assign) NSInteger expense_total;      //总消费
@property (nonatomic, assign) NSInteger residue_top_up;     //总剩余充值金额
@property (nonatomic, strong) NSString * monthly_average;   //月均消费
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSArray * product;
@property (nonatomic, strong) NSString * qq;
@property (nonatomic, strong) NSArray * time_card;
@property (nonatomic, strong) NSArray * top_up;
@property (nonatomic, strong) NSString * wechat;
@property (nonatomic, assign) NSInteger idField;

@end

NS_ASSUME_NONNULL_END
