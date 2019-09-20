//
//  MECourseVideoPlayVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MECourseDetailModel;

@interface MECourseVideoPlayVC : MEBaseVC

- (instancetype)initWithModel:(MECourseDetailModel *)model videoList:(NSArray *)videoList;

@property (nonatomic, assign) NSInteger listenTime; //试听时间

- (void)reloadDatas;

@end

NS_ASSUME_NONNULL_END
