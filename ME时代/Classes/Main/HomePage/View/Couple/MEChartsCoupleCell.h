//
//  MEChartsCoupleCell.h
//  ME时代
//
//  Created by gao lei on 2019/6/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MECoupleModel;
@class MEPinduoduoCoupleModel;
@class MEJDCoupleModel;

NS_ASSUME_NONNULL_BEGIN
const static CGFloat kMEChartsCoupleCellHeight = 140;

@interface MEChartsCoupleCell : UITableViewCell

- (void)setJDUIWithModel:(MEJDCoupleModel *)model;
- (void)setUIWithModel:(MECoupleModel *)model;
- (void)setpinduoduoUIWithModel:(MEPinduoduoCoupleModel *)model;

@end

NS_ASSUME_NONNULL_END
