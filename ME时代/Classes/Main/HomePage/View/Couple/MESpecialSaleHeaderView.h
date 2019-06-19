//
//  MESpecialSaleHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MESpecialSaleHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;

@property (nonatomic,copy)kMeIndexBlock selectedIndexBlock; //banner图点击下标

- (void)setUIWithBannerImage:(NSArray *)bannerImages;

@end

NS_ASSUME_NONNULL_END
