//
//  MEMakeOrderHeaderCell.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodDetailModel;
@class MEShoppingCartModel;

const static CGFloat kMEMakeOrderHeaderCellHeight = 111;

@interface MEMakeOrderHeaderCell : UITableViewCell

//isComb 是否是980活动 isInteral是否兑换
- (void)setUIWithModle:(MEGoodDetailModel *)model isComb:(BOOL)isComb isInteral:(BOOL)isInteral;
- (void)setShopCartUIWithModle:(MEShoppingCartModel *)model;

@end
