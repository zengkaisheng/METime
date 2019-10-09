//
//  MECommissionListCell.h
//  ME时代
//
//  Created by gao lei on 2019/10/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEMoneyDetailedModel;

const static CGFloat kMECommissionListCellHeight = 94;
NS_ASSUME_NONNULL_BEGIN

@interface MECommissionListCell : UITableViewCell

- (void)setUIWithModel:(MEMoneyDetailedModel *)model;

@end

NS_ASSUME_NONNULL_END
