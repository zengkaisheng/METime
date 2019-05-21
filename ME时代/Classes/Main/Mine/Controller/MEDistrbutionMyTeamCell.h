//
//  MEDistrbutionMyTeamCell.h
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEDistributionTeamModel;

const static CGFloat kMEDistrbutionMyTeamCellHeight = 80;

@interface MEDistrbutionMyTeamCell : UITableViewCell

- (void)setUIWithModel:(MEDistributionTeamModel *)model;
@end
