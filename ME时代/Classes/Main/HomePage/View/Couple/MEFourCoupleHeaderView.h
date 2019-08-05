//
//  MEFourCoupleHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/6/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^kMeHeaderViewBlock)(NSInteger tag, BOOL isUp);

@interface MEFourCoupleHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;

@property (nonatomic,copy)kMeIndexBlock selectedIndexBlock; //banner图点击下标
@property (nonatomic,copy)kMeHeaderViewBlock titleSelectedIndexBlock;

- (void)setUIWithBannerImage:(NSArray *)bannerImages isJD:(BOOL)isJD;
- (void)reloadSiftButtonWithSelectedBtn:(UIButton *)selectedBtn isUp:(BOOL)isUp isTop:(BOOL)isTop;

@end

NS_ASSUME_NONNULL_END
