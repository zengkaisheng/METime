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

- (void)setUIWithModel:(MEGroupListModel *)model;

@end

NS_ASSUME_NONNULL_END
