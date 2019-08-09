//
//  MECourseVideoDetailModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECourseVideoDetailModel : MEBaseModel

@property (nonatomic, assign) NSInteger browse;
@property (nonatomic, assign) NSInteger buy_num;
@property (nonatomic, strong) NSString * click_num;
@property (nonatomic, assign) NSInteger comments_num;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger day_recommend;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * images_url;
@property (nonatomic, assign) NSInteger is_buy;
@property (nonatomic, assign) NSInteger is_charge;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_hot;
@property (nonatomic, assign) NSInteger is_show;
@property (nonatomic, assign) NSInteger preview_time;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * video_desc;
@property (nonatomic, strong) NSString * video_detail;
@property (nonatomic, assign) NSInteger video_id;
@property (nonatomic, strong) NSString * video_images;
@property (nonatomic, strong) NSString * video_name;
@property (nonatomic, strong) NSString * video_price;
@property (nonatomic, assign) NSInteger video_type;
@property (nonatomic, strong) NSString * video_type_name;
@property (nonatomic, strong) NSString * video_url;
@property (nonatomic, strong) NSString * video_urls;

@end

NS_ASSUME_NONNULL_END
