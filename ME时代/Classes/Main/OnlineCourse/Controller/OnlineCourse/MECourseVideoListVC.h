//
//  MECourseVideoListVC.h
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECourseVideoListVC : MEBaseVC

//新版本B端查看更多课程列表 1、推荐学习课程 2、学过的课程 3、收藏的课程
- (instancetype)initWithType:(NSInteger)type;

- (instancetype)initWithCategoryId:(NSInteger)categoryId listType:(NSString *)listType;

@end

NS_ASSUME_NONNULL_END
