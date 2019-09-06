//
//  MEOperateDataModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEOperateDataSubModel : MEBaseModel
//total
//@property (nonatomic, assign) NSInteger performance;            //总业绩
//@property (nonatomic, assign) NSInteger residue_top_up_money;   //总剩余充值金额
//@property (nonatomic, assign) NSInteger customer_total;         //总顾客数
//@property (nonatomic, assign) NSInteger service_num;            //总服务数
@property (nonatomic, assign) NSInteger workmanship_charge;       //总手工费

//this_month
@property (nonatomic, assign) NSInteger performance;            //本月业绩
@property (nonatomic, assign) NSInteger top_up_total;           //本月充值金额
@property (nonatomic, assign) NSInteger residue_top_up_money;   //剩余充值金额
@property (nonatomic, assign) NSInteger object_num;             //本月销售卡项数
@property (nonatomic, assign) NSInteger customer_total;         //本月新增顾客数
@property (nonatomic, assign) NSInteger service_num;            //本月服务数

//appointment
@property (nonatomic, assign) NSInteger customer_num;          //顾客预约
//@property (nonatomic, assign) NSInteger workmanship_charge;     //手工费总数
@property (nonatomic, assign) NSInteger this_month_customer_num;  //月顾客预约累计总数
@property (nonatomic, assign) NSInteger this_day_customer_num;    //今日顾客数量占比
@property (nonatomic, assign) NSInteger this_month_workmanship_charge;//月手工费总数

@end



@interface MEOperateDataModel : MEBaseModel

@property (nonatomic, strong) MEOperateDataSubModel * appointment;//顾客预约
@property (nonatomic, strong) MEOperateDataSubModel * this_month; //本月业绩统计
@property (nonatomic, strong) MEOperateDataSubModel * total;      //累积业绩统计

@end

NS_ASSUME_NONNULL_END
