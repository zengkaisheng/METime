//
//  MEExpenseDetailsModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEExpenseDetailsModel : MEBaseModel

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger customer_files_id;
@property (nonatomic, strong) NSString * expense_date;//消费时间
@property (nonatomic, assign) NSInteger expense_id;
@property (nonatomic, strong) NSString * give_content;//赠送产品内容
@property (nonatomic, assign) NSInteger give_service_num;//赠送服务次数
@property (nonatomic, strong) NSString * give_time; //赠送时长
@property (nonatomic, assign) NSInteger give_num;//赠送次数
@property (nonatomic, strong) NSString * give_money;
@property (nonatomic, strong) NSString * give_object;//赠送项目
@property (nonatomic, strong) NSString * give_product;//赠送产品
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger num;//购买次数
@property (nonatomic, strong) NSString * open_time;//开卡时间
@property (nonatomic, strong) NSString * time;//购买时长
@property (nonatomic, strong) NSString * total_time;//总时长
@property (nonatomic, strong) NSArray * product_nature_id;//产品性质
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * require;//充值金划扣要求
@property (nonatomic, strong) NSArray * source_id;//消费来源
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * top_up_time;//充值时间
@property (nonatomic, assign) NSInteger total_num;//总次数
@property (nonatomic, assign) NSInteger type;//4.充值 1.次卡 2.时间卡 3.产品
@property (nonatomic, strong) NSString * updated_at;


@end

NS_ASSUME_NONNULL_END
