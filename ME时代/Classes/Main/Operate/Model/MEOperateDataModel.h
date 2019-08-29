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
@property (nonatomic, assign) NSInteger balance_total;          //总余额
@property (nonatomic, assign) NSInteger customer_classify_total;//顾客各分类数
@property (nonatomic, assign) NSInteger customer_total;         //顾客数
@property (nonatomic, strong) NSString * give_num_total;        //赠送次数
@property (nonatomic, assign) NSInteger oject_total;            //总项目次数
@property (nonatomic, assign) NSInteger top_up_total;           //总充值

//this_month
@property (nonatomic, assign) NSInteger customer_num;           //客次数
@property (nonatomic, assign) NSInteger expense;                //本月消耗
@property (nonatomic, assign) NSInteger object_num;             //项目数
@property (nonatomic, assign) NSInteger performance;            //本月业绩
@property (nonatomic, assign) NSInteger workmanship_charge;     //手工费

//appointment
//@property (nonatomic, assign) NSInteger customer_num;          //顾客预约
@property (nonatomic, assign) NSInteger this_month_customer_num; //月顾客预约累计总数
@property (nonatomic, assign) NSInteger this_day_customer_num;   //今日顾客数量占比
@property (nonatomic, assign) NSInteger this_month_workmanship_charge;//月手工费总数
//@property (nonatomic, assign) NSInteger workmanship_charge;    //手工费总数

@end



@interface MEOperateDataModel : MEBaseModel

@property (nonatomic, strong) MEOperateDataSubModel * appointment;//顾客预约
@property (nonatomic, strong) MEOperateDataSubModel * this_month; //本月数据统计
@property (nonatomic, strong) MEOperateDataSubModel * total;      //门店表现

@end

NS_ASSUME_NONNULL_END
