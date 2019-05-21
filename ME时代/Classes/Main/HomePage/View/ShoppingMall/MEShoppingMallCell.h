//
//  MEShoppingMallCell.h
//  ME时代
//
//  Created by hank on 2018/12/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodModel;
#define kMEShoppingMallCellHeight  (149 * kMeFrameScaleX())

@interface MEShoppingMallCell : UITableViewCell

- (void)setUIWithModel:(MEGoodModel *)model;

@end
