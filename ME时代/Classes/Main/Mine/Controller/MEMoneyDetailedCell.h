//
//  MEMoneyDetailedCell.h
//  ME时代
//
//  Created by hank on 2018/9/26.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEMoneyDetailedModel;
const static CGFloat kMEMoneyDetailedCellHeight = 67;

@interface MEMoneyDetailedCell : UITableViewCell

- (void)setUIWithModel:(MEMoneyDetailedModel *)model;

@end
