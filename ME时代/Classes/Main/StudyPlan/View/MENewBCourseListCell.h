//
//  MENewBCourseListCell.h
//  志愿星
//
//  Created by gao lei on 2019/10/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEStudiedCourseModel;
#define kMENewBCourseListCellHeight 104

@interface MENewBCourseListCell : UITableViewCell

- (void)setUIWithModel:(MEStudiedCourseModel *)model;

@end

NS_ASSUME_NONNULL_END
