//
//  MEShoppingCartCell.h
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEShoppingCartModel;
const static CGFloat kMEShoppingCartCellHeight = 117;

@interface MEShoppingCartCell : UITableViewCell

- (void)setUIWIthModel:(MEShoppingCartModel *)model;

/**
 选中
 */
@property (nonatomic, copy) kMeBOOLBlock ClickRowBlock;

/**
 加
 */
@property (nonatomic, copy) kMeLblBlock AddBlock;

/**
 减
 */
@property (nonatomic, copy) kMeLblBlock CutBlock;




@end
