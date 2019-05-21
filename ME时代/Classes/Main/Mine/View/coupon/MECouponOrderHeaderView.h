//
//  MECouponOrderHeaderView.h
//  ME时代
//
//  Created by hank on 2018/12/27.
//  Copyright © 2018 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMECouponOrderHeaderViewHeight = 160;
@class MECouponDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface MECouponOrderHeaderView : UIView

@property (nonatomic,strong) kMeBasicBlock block;
- (void)setUIWithModel:(MECouponDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
