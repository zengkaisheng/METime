//
//  MEClerksSortCell.h
//  ME时代
//
//  Created by hank on 2019/1/6.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEClerksSortModel;

const static CGFloat kMEClerksSortCellHeight = 142;

@interface MEClerksSortCell : UITableViewCell

- (void)setUIWithModel:(MEClerksSortModel *)model;

@end

NS_ASSUME_NONNULL_END
