//
//  MEBStoreMannagerCell.h
//  ME时代
//
//  Created by hank on 2019/2/19.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBStoreMannagercontentInfoModel;
const static CGFloat kMEBStoreMannagerCellHeight = 44;

@interface MEBStoreMannagerCell : UITableViewCell

- (void)setUiWithModel:(MEBStoreMannagercontentInfoModel *)model;
+ (CGFloat)getCellHeightWithModel:(MEBStoreMannagercontentInfoModel*)model;

@end

NS_ASSUME_NONNULL_END
