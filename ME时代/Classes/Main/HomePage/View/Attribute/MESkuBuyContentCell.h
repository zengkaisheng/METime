//
//  MESkuBuyContentCell.h
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodSpecModel;
#define kMESkuBuyContentCellMargin 20
#define kMESkuBuyContentCellHeight 28
#define kMESkuBuyContentCellWidth ((SCREEN_WIDTH - 4 * kMESkuBuyContentCellMargin) /3)

@interface MESkuBuyContentCell : UICollectionViewCell

- (void)setmodelWithStr:(MEGoodSpecModel *)model isSelect:(BOOL)isSelect;

@end
