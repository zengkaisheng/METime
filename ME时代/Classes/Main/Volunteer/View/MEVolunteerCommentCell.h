//
//  MEVolunteerCommentCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MERecruitCommentModel;

@interface MEVolunteerCommentCell : UITableViewCell

@property (nonatomic, copy) kMeTextBlock answerBlock;

- (void)setUIWithModel:(MERecruitCommentModel *)model;

- (void)setListUIWithModel:(MERecruitCommentModel *)model;

- (void)setSelfCommentUIWithModel:(MERecruitCommentModel *)model;

@end

NS_ASSUME_NONNULL_END
