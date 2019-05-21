//
//  MEAddGoodDivideCell.h
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEAddGoodDivideCellHeight = 238;
@class MEAddGoodModel;

@interface MEAddGoodDivideCell : UITableViewCell
- (void)setUIWithModel:(MEAddGoodModel *)model;

@end

NS_ASSUME_NONNULL_END
