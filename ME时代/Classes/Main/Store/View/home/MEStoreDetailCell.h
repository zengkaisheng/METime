//
//  MEStoreDetailCell.h
//  ME时代
//
//  Created by hank on 2018/10/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodModel;
const static CGFloat kMEStoreDetailCellHeight = 105.0f;

@interface MEStoreDetailCell : UITableViewCell

- (void)setUIWithModel:(MEGoodModel *)model;

@end
