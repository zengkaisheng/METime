//
//  MESginUpActivityInfoModel.h
//  志愿星
//
//  Created by gao lei on 2019/10/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MESginUpMemberInfoModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * signin_code;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * start_time;         //活动开始时间
@property (nonatomic, strong) NSString * end_time;           //活动结束时间
@property (nonatomic, strong) NSString * start_longitude;
@property (nonatomic, strong) NSString * start_latitude;
@property (nonatomic, strong) NSString * end_longitude;
@property (nonatomic, strong) NSString * end_latitude;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * duration;   //持续时长（信用时数）
@property (nonatomic, strong) NSString * integral;   //积分
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;

@end


@interface MESginUpActivityInfoModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * start_time;         //活动开始时间
@property (nonatomic, strong) NSString * end_time;           //活动结束时间
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, assign) NSInteger signin_num;
@property (nonatomic, assign) NSInteger signout_num;
@property (nonatomic, strong) NSString * signin_code;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger is_sign_in;
@property (nonatomic, strong) MESginUpMemberInfoModel * member_info;

@end

NS_ASSUME_NONNULL_END
