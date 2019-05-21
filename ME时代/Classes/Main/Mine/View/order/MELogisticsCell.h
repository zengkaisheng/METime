//
//  MELogisticsCell.h
//  ME时代
//
//  Created by hank on 2018/10/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MELogistDataModel;
const static CGFloat kMELogisticsCellHeight = 62.0f;

@interface MELogisticsCell : UITableViewCell

+ (CGFloat)getCellHeightWithModel:(MELogistDataModel *)model;
- (void)setUIWIthModel:(MELogistDataModel *)model isSelect:(BOOL)isSelect;

@end
