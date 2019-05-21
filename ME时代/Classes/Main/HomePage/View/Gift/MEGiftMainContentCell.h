//
//  MEGiftMainContentCell.h
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEShoppingCartModel;
const static CGFloat kMEGiftMainContentCellHeight = 85;

@interface MEGiftMainContentCell : UITableViewCell

/**
 加
 */
@property (nonatomic, copy) kMeLblBlock AddBlock;

/**
 减
 */
@property (nonatomic, copy) kMeLblBlock CutBlock;

- (void)setUIWIthModel:(MEShoppingCartModel *)model;
@end
