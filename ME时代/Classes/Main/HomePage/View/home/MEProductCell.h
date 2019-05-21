//
//  MEProductCell.h
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEGoodModel;

const static CGFloat kMEProductCellHeight  = 230;
#define kMEProductCellWdith ((SCREEN_WIDTH - (15*3))/2)
#define kMEMargin (7.5)


@interface MEProductCell : UICollectionViewCell

- (void)setUIWithModel:(MEGoodModel *)model;
- (void)setUIWithModel:(MEGoodModel *)model WithKey:(NSString *)key;
- (void)setServiceUIWithModel:(MEGoodModel *)model;

@end
