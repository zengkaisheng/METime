//
//  MERushBuyContentCell.h
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class METhridHomeRudeGoodModel;
const static CGFloat kMERushBuyContentCellHeight = 150;

@interface MERushBuyContentCell : UITableViewCell

- (void)setUIWithModel:(METhridHomeRudeGoodModel *)model;

@end

NS_ASSUME_NONNULL_END
