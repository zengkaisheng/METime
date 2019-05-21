//
//  METhridHomeTopCell.h
//  ME时代
//
//  Created by hank on 2019/4/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEThridHomeTopCellHeight = 142;

@class MEHomeRecommendAndSpreebuyModel;
@interface METhridHomeTopCell : UITableViewCell

- (void)setUiWithModel:(MEHomeRecommendAndSpreebuyModel *)model;

//@property (nonatomic,copy)kMeBasicBlock fblock;
//@property (nonatomic,copy)kMeBasicBlock sblock;

@end

NS_ASSUME_NONNULL_END
