//
//  MECouponOrderCell.h
//  ME时代
//
//  Created by hank on 2018/12/27.
//  Copyright © 2018 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMECouponOrderCellHeight = 144;
@class MECouponMoneyModel;
@class MEJDCouponMoneyModel;
@class MECouponBtModel;
NS_ASSUME_NONNULL_BEGIN

@interface MECouponOrderCell : UITableViewCell

- (void)setUIWithModel:(MECouponMoneyModel *)model;
- (void)setJDUIWithModel:(MEJDCouponMoneyModel *)model;
- (void)setTbUIWithModel:(MECouponBtModel *)model;

@end

NS_ASSUME_NONNULL_END
