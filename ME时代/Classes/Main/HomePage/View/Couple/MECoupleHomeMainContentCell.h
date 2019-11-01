//
//  MECoupleHomeMainContentCell.h
//  志愿星
//
//  Created by hank on 2019/1/3.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MECoupleModel;
const static CGFloat kMECoupleHomeMainContentCellHeight = 168.0;
const static CGFloat kMECoupleHomeMainContentCellWidth = 110.0;
//new
const static CGFloat kMECoupleHomeMainContentCellHeightNew = 135.0;
const static CGFloat kMECoupleHomeMainContentCellWidthNew = 105.0;

@interface MECoupleHomeMainContentCell : UICollectionViewCell

- (void)setUIWIthModel:(MECoupleModel *)model;
@end

NS_ASSUME_NONNULL_END
