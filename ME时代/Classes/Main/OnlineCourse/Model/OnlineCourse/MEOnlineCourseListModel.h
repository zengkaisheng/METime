//
//  MEOnlineCourseListModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEOnlineCourseListModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_charge; //是否收费 1 是 2 否
@property (nonatomic, assign) NSInteger browse;
@property (nonatomic, assign) NSInteger buy_num;
@property (nonatomic, strong) NSString * images_url;
//视频相关
@property (nonatomic, strong) NSString * video_images;
@property (nonatomic, strong) NSString * video_name;
@property (nonatomic, strong) NSString * video_price;
@property (nonatomic, strong) NSString * video_type_name;
@property (nonatomic, strong) NSString * video_urls;
@property (nonatomic, strong) NSString * video_desc;

//视频相关
@property (nonatomic, strong) NSString * audio_images;
@property (nonatomic, strong) NSString * audio_name;
@property (nonatomic, strong) NSString * audio_price;
@property (nonatomic, strong) NSString * audio_type_name;
@property (nonatomic, strong) NSString * audio_urls;
@property (nonatomic, strong) NSString * audio_desc;

@property (nonatomic, assign) BOOL isSelected;  //是否选中 默认NO

@end

NS_ASSUME_NONNULL_END
/*
 video_name    string    视频名
 images_url    string    视频封面
 video_price    string    视频价格
 browse    string    浏览次数
 buy_num    string    购买次数
 video_type_name    string    分类名
 */
