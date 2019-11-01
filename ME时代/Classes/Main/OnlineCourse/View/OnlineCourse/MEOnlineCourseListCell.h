//
//  MEOnlineCourseListCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEOnlineCourseListModel;
@class MEMyCollectionModel;

NS_ASSUME_NONNULL_BEGIN

#define kMEOnlineCourseListCellHeight 99

@interface MEOnlineCourseListCell : UITableViewCell

- (void)setUIWithModel:(MEOnlineCourseListModel *)model isHomeVC:(BOOL)isHome;

- (void)setUIWithCollectionModel:(MEMyCollectionModel *)model;

@end

NS_ASSUME_NONNULL_END
