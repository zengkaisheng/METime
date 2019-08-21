//
//  MECourseDetailModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECourseDetailModel : MEBaseModel

@property (nonatomic, assign) NSInteger browse;
@property (nonatomic, assign) NSInteger buy_num;
@property (nonatomic, strong) NSString * click_num;
@property (nonatomic, assign) NSInteger comments_num;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger day_recommend;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * images_url;
@property (nonatomic, assign) NSInteger is_buy;
@property (nonatomic, assign) NSInteger is_charge; //是否收费 1.是 2.否
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_hot;
@property (nonatomic, assign) NSInteger is_show;
@property (nonatomic, assign) NSInteger preview_time;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger is_collection; //1收藏 2未收藏
@property (nonatomic, assign) NSInteger is_diagnosis_report; //是否诊断过
//视频相关
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
//音频相关
@property (nonatomic, strong) NSString * audio_desc;
@property (nonatomic, strong) NSString * audio_detail;
@property (nonatomic, assign) NSInteger audio_id;
@property (nonatomic, strong) NSString * audio_images;
@property (nonatomic, strong) NSString * audio_name;
@property (nonatomic, strong) NSString * audio_price;
@property (nonatomic, assign) NSInteger audio_type;
@property (nonatomic, strong) NSString * audio_type_name;
@property (nonatomic, strong) NSString * audio_url;
@property (nonatomic, strong) NSString * audio_urls;

@end

NS_ASSUME_NONNULL_END
/*
 视频相关
 video_name    string    视频名
 video_desc    string    视频介绍
 video_type    string    视频类型
 video_price    string    视频价格
 browse    string    浏览次数
 buy_num    string    购买次数
 comments_num    string    点赞次数
 click_num    string    点击次数
 video_detail    string    视频详情
 images_url    string    封面图
 video_urls    string    视频播放地址
 video_type_name    string    视频类型名
 is_buy    string    是否购买过 1是 2 否
 preview_time    string    预览时长 以秒为单位
 音频相关
 audio_name    string    音频名
 audio_desc    string    音频简介
 audio_type    string    音频类型
 browse    string    浏览次数
 buy_num    string    购买次数
 click_num    string    点击次数
 audio_detail    string    音频详情
 images_url    string    音频封面
 audio_urls    string    音频地址
 is_buy    string    是否购买过 1是 2 否
 preview_time    string    预览时长 以秒为单位
 */
