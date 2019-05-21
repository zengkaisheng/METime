//
//  MEGoodManngerCell.h
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEGoodManngerCellHeight = 202;

@class MEGoodManngerModel;
@interface MEGoodManngerCell : UITableViewCell

@property (nonatomic, copy) kMeBasicBlock delBlock;
- (void)setUiWithModel:(MEGoodManngerModel *)model;

@end

NS_ASSUME_NONNULL_END
