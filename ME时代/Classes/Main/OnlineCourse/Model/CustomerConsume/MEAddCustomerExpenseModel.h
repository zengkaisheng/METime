//
//  MEAddCustomerExpenseModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddCustomerExpenseModel : MEBaseModel

//添加消费
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * customer_files_id;//顾客档案ID
@property (nonatomic, assign) NSInteger type; //类型：1次卡项目2时间卡项目3产品4会员充值
@property (nonatomic, strong) NSString * money; //消费金额/充值金额
@property (nonatomic, strong) NSString * content;//项目内容/购买产品内容/充值活动内容
@property (nonatomic, strong) NSString * remark;//备注
//次卡项目
@property (nonatomic, strong) NSString * name; //项目名称/产品名称
@property (nonatomic, strong) NSString * source_id; //消费来源
@property (nonatomic, strong) NSString * expense_date; //次卡消费时间 消费时间
@property (nonatomic, strong) NSString * num; //购买次数
@property (nonatomic, strong) NSString * give_num; //赠送次数
@property (nonatomic, strong) NSString * total_num; //总次数
//时间卡项目
@property (nonatomic, strong) NSString * open_time; //开卡时间
@property (nonatomic, strong) NSString * time;//购买时长
@property (nonatomic, strong) NSString * give_time;//赠送时长
@property (nonatomic, strong) NSString * total_time;//总时长
//产品
@property (nonatomic, strong) NSString * give_content;//赠送产品内容
@property (nonatomic, strong) NSString * product_nature_id;//产品性质ID
@property (nonatomic, strong) NSString * give_service_num; //赠送服务次数
//充值
@property (nonatomic, strong) NSString * top_up_time;//充值时间
@property (nonatomic, strong) NSString * give_object;//赠送项目
@property (nonatomic, strong) NSString * give_product;//赠送产品
@property (nonatomic, strong) NSString * require;//充值金划扣要求

@end

NS_ASSUME_NONNULL_END
