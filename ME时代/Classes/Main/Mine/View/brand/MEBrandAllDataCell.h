//
//  MEBrandAllDataCell.h
//  志愿星
//
//  Created by hank on 2019/3/8.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBrandManngerAllModel;
const static CGFloat kMEBrandAllDataCellHeight = 174;

@interface MEBrandAllDataCell : UITableViewCell

- (void)setUIWithModel:(MEBrandManngerAllModel *)model;

@end

NS_ASSUME_NONNULL_END
