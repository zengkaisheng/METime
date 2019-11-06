//
//  MEPersonalCourseListModel.h
//  志愿星
//
//  Created by gao lei on 2019/9/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECourseListModel : MEBaseModel

@property (nonatomic, assign) NSInteger after_sales_ratio;
@property (nonatomic, assign) NSInteger browse;
@property (nonatomic, assign) NSInteger buy_num;
@property (nonatomic, strong) NSString * charge_name;
@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, assign) NSInteger clerk_ratio;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger day_recommend;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, assign) NSInteger is_charge;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_hot;
@property (nonatomic, assign) NSInteger is_in_vip;
@property (nonatomic, assign) NSInteger is_show;
@property (nonatomic, assign) NSInteger marketing_ratio;
@property (nonatomic, assign) NSInteger member_parent_ratio;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger self_ratio;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger store_ratio;
@property (nonatomic, strong) NSString * study_num;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * type_name;
@property (nonatomic, assign) NSInteger unreal_browse;
@property (nonatomic, assign) NSInteger unreal_buy;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * cover;
//列表
@property (nonatomic, strong) NSString * courses_images;
@property (nonatomic, strong) NSString * courses_url;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, strong) NSString * time;

@property (nonatomic, assign) NSInteger ids;
@property (nonatomic, assign) NSInteger list_order;
@property (nonatomic, assign) NSInteger preview_time;
@property (nonatomic, assign) NSInteger status;

@end



@interface MEPersonalCourseListModel : MEBaseModel

@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSString * classify_name;
@property (nonatomic, strong) NSArray * courses;

@end

NS_ASSUME_NONNULL_END
