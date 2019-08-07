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

@property (nonatomic, assign) NSInteger browse;
@property (nonatomic, assign) NSInteger buy_num;
@property (nonatomic, strong) NSString * images_url;
@property (nonatomic, strong) NSString * video_images;
@property (nonatomic, strong) NSString * video_name;
@property (nonatomic, strong) NSString * video_price;
@property (nonatomic, strong) NSString * video_type_name;
@property (nonatomic, strong) NSString * video_urls;

@end

NS_ASSUME_NONNULL_END
