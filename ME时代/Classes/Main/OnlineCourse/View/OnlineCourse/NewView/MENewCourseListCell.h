//
//  MENewCourseListCell.h
//  志愿星
//
//  Created by gao lei on 2019/10/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEOnlineCourseListModel;

#define kMENewCourseListCellHeight 99

@interface MENewCourseListCell : UITableViewCell

- (void)setUIWithModel:(MEOnlineCourseListModel *)model;

@end

NS_ASSUME_NONNULL_END
