//
//  MEGroupListCell.h
//  ME时代
//
//  Created by gao lei on 2019/7/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEGroupListModel;

#define kMEGroupListCellHeight 117

@interface MEGroupListCell : UITableViewCell

@property (nonatomic, copy) kMeBasicBlock groupBlock;

- (void)setUIWithModel:(MEGroupListModel *)model;

- (void)setHomeUIWithModel:(MEGroupListModel *)model;
@end

NS_ASSUME_NONNULL_END
