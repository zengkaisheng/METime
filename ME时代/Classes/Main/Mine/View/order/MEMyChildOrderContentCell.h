//
//  MEMyChildOrderContentCell.h
//  志愿星
//
//  Created by gao lei on 2018/9/21.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEOrderGoodModel;
@class MERefundGoodModel;
@class MEGroupOrderModel;

static const CGFloat kMEMyChildOrderContentCellHeight = 120;

@interface MEMyChildOrderContentCell : UITableViewCell

- (void)setUIWithModel:(MEOrderGoodModel *)model;
- (void)setSelfUIWithModel:(MEOrderGoodModel *)model extractStatus:(NSString *)status;

- (void)setUIWithRefundModel:(MERefundGoodModel *)model;

- (void)setUIWithGroupModel:(MEGroupOrderModel *)model;

- (void)setUIWithModel:(MEOrderGoodModel *)model;

@end
