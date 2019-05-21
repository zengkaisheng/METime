//
//  MENewHomeMainCell.h
//  ME时代
//
//  Created by hank on 2018/11/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodModel;
const static CGFloat kMENewHomeMainCellHeight = 244;

@interface MENewHomeMainCell : UITableViewCell

+ (CGFloat)getCellHeight;
- (void)setUIWithModel:(MEGoodModel *)model;
- (void)setServiceUIWithModel:(MEGoodModel *)model;
@end
