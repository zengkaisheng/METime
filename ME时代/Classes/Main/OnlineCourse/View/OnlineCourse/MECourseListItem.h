//
//  MECourseListItem.h
//  志愿星
//
//  Created by gao lei on 2019/8/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMECourseListItemHeight 75
#define kMECourseListItemWdith ((SCREEN_WIDTH - 43)/2)
#define kMECourseListItemMargin (15)
@class MEOnlineCourseListModel;

@interface MECourseListItem : UICollectionViewCell

- (void)setUIWithModel:(MEOnlineCourseListModel *)model;

@end

NS_ASSUME_NONNULL_END
