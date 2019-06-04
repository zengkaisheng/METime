//
//  MENewFilterGoodsTopHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/5/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MENewFilterGoodsTopHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (nonatomic,copy)kMeIndexBlock selectedIndexBlock; //banner图点击下标
@property (nonatomic,copy)kMeIndexBlock titleSelectedIndexBlock;

- (void)setUIWithBackgroundImage:(NSString *)bgImage bannerImage:(NSArray *)bannerImages;

- (void)setUIWithTitleArray:(NSArray *)titles;

- (void)reloadTitleViewWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
