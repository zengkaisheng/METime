//
//  MERecruitDetailModel.h
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MERecruitJoinUserModel : MEBaseModel

@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * join_time;

@end


@interface MERecruitDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * area;
@property (nonatomic, assign) NSInteger attention_status;    //关注状态：1已关注0未关注
@property (nonatomic, strong) NSString * city;
@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, strong) NSString * distance;           //距离
@property (nonatomic, strong) NSString * end_date;           //活动结束时间
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * join_end_date;      //招募结束时间
@property (nonatomic, assign) NSInteger join_num;            //报名人数
@property (nonatomic, strong) NSString * join_start_date;    //招募开始时间
@property (nonatomic, assign) NSInteger join_status;         //报名状态：1已报名0未报名
@property (nonatomic, strong) NSArray * join_users;          //报名人员
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, assign) NSInteger need_num;            //活动名额
@property (nonatomic, strong) NSString * organizers;         //举办方
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * start_date;         //活动开始时间
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * tel;                //联系电话
@property (nonatomic, strong) NSString * time_remaining;     //倒计时
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
