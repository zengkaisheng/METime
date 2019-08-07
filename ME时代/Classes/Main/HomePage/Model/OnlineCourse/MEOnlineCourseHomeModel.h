//
//  MEOnlineCourseHomeModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECourseHomeVideoListModel : MEBaseModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray * data;

@end

@interface MEOnlineCourseHomeModel : MEBaseModel

@property (nonatomic, strong) NSArray * top_banner;
@property (nonatomic, strong) NSArray * onLine_banner;
@property (nonatomic, strong) MECourseHomeVideoListModel * video_list;

@end

NS_ASSUME_NONNULL_END
