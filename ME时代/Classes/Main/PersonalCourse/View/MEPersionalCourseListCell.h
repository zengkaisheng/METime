//
//  MEPersionalCourseListCell.h
//  ME时代
//
//  Created by gao lei on 2019/9/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MECourseListModel;

#define kMEPersionalCourseListCellHeight 99

@interface MEPersionalCourseListCell : UITableViewCell

- (void)setUIWithModel:(MECourseListModel *)model isFree:(BOOL)isFree;

@end

NS_ASSUME_NONNULL_END
