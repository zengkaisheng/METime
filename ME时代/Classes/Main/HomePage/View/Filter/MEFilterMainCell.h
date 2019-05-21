//
//  MEFilterMainCell.h
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEFilterMainModel;
const static CGFloat kMEFilterMainCellHeight = 46;

@interface MEFilterMainCell : UITableViewCell

- (void)setUIWithModel:(MEFilterMainModel *)model;
- (void)setUnreadUIWithModel:(MEFilterMainModel *)model;

@end
