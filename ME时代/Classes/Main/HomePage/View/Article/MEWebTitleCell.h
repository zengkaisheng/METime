//
//  MEWebTitleCell.h
//  志愿星
//
//  Created by hank on 2018/12/4.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEArticelDetailModel;
//const static CGFloat kMEWebTitleCellHeight = 66;

@interface MEWebTitleCell : UITableViewCell

- (void)setUiWithModel:(MEArticelDetailModel *)model;
+ (CGFloat)getCellHeightWithModel:(MEArticelDetailModel *)model;
@end
