//
//  MEourseClassifyModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEourseClassifyModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_show;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
//视频参数
@property (nonatomic, strong) NSString * video_type_name;
@property (nonatomic, strong) NSString * video_type_title;
@property (nonatomic, strong) NSString * video_type_desc;
//音频参数
@property (nonatomic, strong) NSString * audio_type_name;
@property (nonatomic, strong) NSString * audio_type_title;
@property (nonatomic, strong) NSString * audio_type_desc;

@end

NS_ASSUME_NONNULL_END
