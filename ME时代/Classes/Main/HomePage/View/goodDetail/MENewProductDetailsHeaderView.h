//
//  MENewProductDetailsHeaderView.h
//  ME时代
//
//  Created by hank on 2019/1/9.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEGoodDetailModel;
@interface MENewProductDetailsHeaderView : UIView


- (void)reloadStockAndSaled:(MEGoodDetailModel *)model;
- (void)setUIWithModel:(MEGoodDetailModel *)model;
+ (CGFloat)getHeightWithModel:(MEGoodDetailModel *)model;

@property (nonatomic, strong) kMeBasicBlock selectSkuBlock;

@end

NS_ASSUME_NONNULL_END
