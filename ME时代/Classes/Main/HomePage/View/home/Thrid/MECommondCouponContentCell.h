//
//  MECommondCouponContentCell.h
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEPinduoduoCoupleModel;
const static CGFloat kMECommondCouponContentCellWdith = 105;
const static CGFloat kMECommondCouponContentCellHeight = 135;


@interface MECommondCouponContentCell : UICollectionViewCell

- (void)setUIWithModel:(MEPinduoduoCoupleModel *)model;

@end

NS_ASSUME_NONNULL_END
