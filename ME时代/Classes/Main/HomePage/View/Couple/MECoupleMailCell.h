//
//  MECoupleMailCell.h
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MECoupleModel;
@class MEPinduoduoCoupleModel;
@class MEJDCoupleModel;

#define kMECoupleMailCellHeight (kMECoupleMailCellWdith +93)
#define kMECoupleMailCellWdith ((SCREEN_WIDTH - 30)/2)
#define kMEMargin (5)

@interface MECoupleMailCell : UICollectionViewCell

- (void)setJDUIWithModel:(MEJDCoupleModel *)model;
- (void)setUIWithModel:(MECoupleModel *)model;
- (void)setpinduoduoUIWithModel:(MEPinduoduoCoupleModel *)model;

@end
