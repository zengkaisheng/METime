//
//  MEStudiedHomeModel.h
//  志愿星
//
//  Created by gao lei on 2019/10/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEStudiedCourseModel : MEBaseModel

@property (nonatomic, assign) NSInteger browse;
@property (nonatomic, assign) NSInteger buy_num;
@property (nonatomic, strong) NSString * c_desc;
@property (nonatomic, assign) NSInteger c_id;
@property (nonatomic, strong) NSString * c_images;
@property (nonatomic, strong) NSString * c_images_url;
@property (nonatomic, strong) NSString * c_name;
@property (nonatomic, assign) NSInteger c_type;  //课程类型 1视频 2音频
@property (nonatomic, strong) NSString * c_type_name;
@property (nonatomic, assign) NSInteger class_like_num;  //点赞数
@property (nonatomic, assign) NSInteger click_num;
@property (nonatomic, assign) NSInteger comments_num;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_like;  //是否点赞1是0否
@property (nonatomic, assign) NSInteger is_new;
@property (nonatomic, assign) NSInteger order_list;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * study_time;  //多少分钟前看过
@property (nonatomic, strong) NSString * updated_at;

@end


@interface MEStudiedHomeModel : MEBaseModel

@property (nonatomic, strong) NSArray * collected;  //收藏的课程
@property (nonatomic, strong) MEStudiedCourseModel * recomment;  //推荐学习
@property (nonatomic, strong) NSArray * studied;    //学过的课程

@end

NS_ASSUME_NONNULL_END
