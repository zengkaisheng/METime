//
//  METhridHomeGoodGoodMainCell.h
//  ME时代
//
//  Created by hank on 2019/4/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEGoodModel;
const static CGFloat kMEThridHomeGoodGoodMainCellHeight = 135;

@interface METhridHomeGoodGoodMainCell : UITableViewCell

- (void)setUIWithModel:(MEGoodModel *)model;

@end

NS_ASSUME_NONNULL_END
