//
//  MERecruitJoinUserListCell.h
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MERecruitJoinUserModel;
@class MELoveListModel;

@interface MERecruitJoinUserListCell : UITableViewCell

- (void)setUIWithModel:(MERecruitJoinUserModel *)model;

- (void)setLoveListUIWithModel:(MELoveListModel *)model;

@end

NS_ASSUME_NONNULL_END
