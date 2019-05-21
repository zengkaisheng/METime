//
//  MEDistributionOrderCell.h
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEDistrbutionOrderModel;
const static CGFloat kMEDistributionOrderCellHeight = 132;

@interface MEDistributionOrderCell : UITableViewCell

- (void)setUIWithModel:(id)model Type:(MEDistrbutionOrderStyle)type;
- (void)setUIWithModel:(MEDistrbutionOrderModel *)model;

@end
