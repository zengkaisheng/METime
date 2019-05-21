//
//  MeMyActityMineCell.h
//  ME时代
//
//  Created by hank on 2019/1/6.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEMineActiveModel;
const static CGFloat kMeMyActityMineCellHeight = 162;

@interface MeMyActityMineCell : UITableViewCell

- (void)setUIWithModel:(MEMineActiveModel *)model;

@end

NS_ASSUME_NONNULL_END
