//
//  MEOnlineCourseHomeModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECourseHomeMenuListSubModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * menu_name;
@property (nonatomic, assign) NSInteger order_by;
@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * to_level;
@property (nonatomic, strong) NSString * updated_at;

@end



@interface MECourseHomeMenuListModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * menu_name;
@property (nonatomic, assign) NSInteger order_by;
@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray * subclass;
@property (nonatomic, strong) NSString * to_level;
@property (nonatomic, strong) NSString * updated_at;

@end



@interface MECourseHomeVideoListModel : MEBaseModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray * data;

@end


@interface MECourseHomeCategoryModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * video_type_name;
@property (nonatomic, strong) NSArray * video_list;

@end


@interface MEOnlineCourseHomeModel : MEBaseModel

@property (nonatomic, strong) NSArray * top_banner;
@property (nonatomic, strong) NSArray * onLine_banner;
@property (nonatomic, strong) MECourseHomeVideoListModel * video_list;

//视/音频首页相关内容
@property (nonatomic, strong) NSArray * banner;
@property (nonatomic, strong) MECourseHomeVideoListModel * hot_video;
@property (nonatomic, strong) NSArray * menu_list;
@property (nonatomic, strong) NSArray * category;

@end

NS_ASSUME_NONNULL_END
