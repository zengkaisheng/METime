//
//  MEProductDetalsBuyedContentCell.h
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>


const static CGFloat kMEProductDetalsBuyedContentCellHeight = 200.0;
const static CGFloat kMEProductDetalsBuyedContentCellWidth = 110.0;

@class MEGoodModel;
@interface MEProductDetalsBuyedContentCell : UICollectionViewCell

- (void)setUIWithModel:(MEGoodModel *)model;
- (void)setUIServiceWithModel:(id)model;

@end
