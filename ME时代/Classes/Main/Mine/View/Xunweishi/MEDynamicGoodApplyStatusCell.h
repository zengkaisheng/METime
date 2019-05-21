//
//  MEDynamicGoodApplyStatusCell.h
//  SunSum
//
//  Created by hank on 2019/3/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEDynamicGoodApplyModel;
const static CGFloat kMEDynamicGoodApplyStatusCellHeight = 162;

@interface MEDynamicGoodApplyStatusCell : UITableViewCell

- (void)setUIWithModel:(MEDynamicGoodApplyModel *)model;

@end

NS_ASSUME_NONNULL_END
