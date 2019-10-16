//
//  MEStudiedRecommentCell.h
//  ME时代
//
//  Created by gao lei on 2019/10/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEStudiedCourseModel;
@class MECareerCourseListModel;
#define kMEStudiedRecommentCellHeight 116+164*kMeFrameScaleX()


@interface MEStudiedRecommentCell : UITableViewCell

@property (nonatomic, copy) kMeBasicBlock likeCourseBlock;

- (void)setUIWithModel:(MEStudiedCourseModel *)model;
//一起创业
- (void)setCareerUIWithModel:(MECareerCourseListModel *)model;

@end

NS_ASSUME_NONNULL_END
