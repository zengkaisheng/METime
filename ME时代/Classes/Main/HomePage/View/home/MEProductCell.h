//
//  MEProductCell.h
//  志愿星
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEGoodModel;

const static CGFloat kMEProductCellHeight  = 245;
#define kMEProductCellWdith ((SCREEN_WIDTH - (15*2))/2)
//#define kMEMargin (7.5)
#define kMEMargin ((IS_iPhoneX?8:7.5)*kMeFrameScaleX())

@interface MEProductCell : UICollectionViewCell

- (void)setUIWithModel:(MEGoodModel *)model;
- (void)setUIWithModel:(MEGoodModel *)model WithKey:(NSString *)key;
- (void)setServiceUIWithModel:(MEGoodModel *)model;

@end
