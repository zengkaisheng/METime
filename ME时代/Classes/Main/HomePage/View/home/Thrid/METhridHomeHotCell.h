//
//  METhridHomeHotCell.h
//  ME时代
//
//  Created by hank on 2019/4/13.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class METhridHomeHotGoodModel;
const static CGFloat kMEThridHomeHotCellHeight = 214;

@interface METhridHomeHotCell : UITableViewCell

- (void)setUIWIthModel:(METhridHomeHotGoodModel *)model payBlock:(kMeBasicBlock)payBlock;

@end

NS_ASSUME_NONNULL_END
