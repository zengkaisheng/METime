//
//  MEPersonalCourseListCell.h
//  志愿星
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MECourseListModel;

#define kMEPersonalCourseListCellHeight 130

@interface MEPersonalCourseListCell : UITableViewCell

- (void)setUIWithModel:(MECourseListModel *)model;

@end

NS_ASSUME_NONNULL_END
