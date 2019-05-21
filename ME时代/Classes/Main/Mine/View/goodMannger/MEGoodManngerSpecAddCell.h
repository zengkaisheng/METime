//
//  MEGoodManngerSpecAddCell.h
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  MEGoodManngerGoodSpec;
const static CGFloat kMEGoodManngerSpecAddCellHeight = 55;


@interface MEGoodManngerSpecAddCell : UITableViewCell

- (void)setUIWithModel:(MEGoodManngerGoodSpec *)model;

@end

NS_ASSUME_NONNULL_END
