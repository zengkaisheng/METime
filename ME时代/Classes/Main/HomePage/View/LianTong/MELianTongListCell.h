//
//  MELianTongListCell.h
//  ME时代
//
//  Created by gao lei on 2019/9/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEGoodModel;

#define kMELianTongListCellHeight 245
#define kMELianTongListCellWdith ((SCREEN_WIDTH - (15*2))/2)
#define kMEMargin ((IS_iPhoneX?8:7.5)*kMeFrameScaleX())

NS_ASSUME_NONNULL_BEGIN

@interface MELianTongListCell : UICollectionViewCell

- (void)setUIWithModel:(MEGoodModel *)model;

@end

NS_ASSUME_NONNULL_END
