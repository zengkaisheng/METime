//
//  MEActivityRecruitListCell.h
//  ME时代
//
//  Created by gao lei on 2019/10/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MERecruitListModel;

@interface MEActivityRecruitListCell : UITableViewCell

- (void)setUIWithModel:(MERecruitListModel *)model;

@end

NS_ASSUME_NONNULL_END
