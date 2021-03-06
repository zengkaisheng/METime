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
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * signature;

@end

@interface MERecruitCommentBackModel : MEBaseModel

@property (nonatomic, assign) NSInteger comment_id;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_own;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) CGFloat contentHeight;

@end


@interface MERecruitCommentModel : MEBaseModel

@property (nonatomic, assign) NSInteger activity_id;
@property (nonatomic, strong) NSArray * comment_back;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_own;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger praise_num;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) CGFloat contentHeight;
//公益秀相关
@property (nonatomic, assign) NSInteger is_praise;
@property (nonatomic, strong) NSString * nick_name;

//我的评论相关
@property (nonatomic, strong) NSString * activity;
@property (nonatomic, assign) NSInteger c_type; //1招募活动 2g公益秀
@property (nonatomic, assign) NSInteger comment_id;

@end


@interface MERecruitDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * area;
@property (nonatomic, assign) NSInteger attention_num;       //关注数
@property (nonatomic, assign) NSInteger attention_status;    //关注状态：1已关注0未关注
@property (nonatomic, strong) NSString * city;
@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSArray * comment;
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
