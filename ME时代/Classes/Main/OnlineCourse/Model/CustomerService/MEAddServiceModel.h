//
//  MEAddServiceModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddServiceModel : MEBaseModel
//添加服务
@property (nonatomic, strong) NSString * token;
@property (nonatomic, assign) NSInteger type; //服务类型：1次卡服务2时间卡服务3套盒产品服务
@property (nonatomic, strong) NSString * customer_files_id;//顾客档案ID
@property (nonatomic, strong) NSString * service_name; //服务项目名称
@property (nonatomic, strong) NSString * total_num; //总次数
@property (nonatomic, strong) NSString * residue_num; //剩余次数
@property (nonatomic, strong) NSString * residue_time; //剩余时间
@property (nonatomic, strong) NSString * open_card_time; //开卡时间

//添加服务记录
@property (nonatomic, strong) NSString * service_id; //服务ID
@property (nonatomic, strong) NSString * service_time;//服务时间
@property (nonatomic, strong) NSString * member; //服务人员
@property (nonatomic, strong) NSString * change;//改善情况
@property (nonatomic, strong) NSString * customer_check; //顾客确认
@property (nonatomic, strong) NSString * remark;//备注
@property (nonatomic, strong) NSString * come_in_count;//到店次数


@end

NS_ASSUME_NONNULL_END
