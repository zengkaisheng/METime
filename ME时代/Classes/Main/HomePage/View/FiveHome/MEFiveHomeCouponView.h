//
//  MEFiveHomeCouponView.h
//  志愿星
//
//  Created by gao lei on 2019/10/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define kMEFiveHomeCouponViewHeight (SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight)

@interface MEFiveHomeCouponView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic ,copy) kMeIndexBlock selectIndexBlock;
@property (nonatomic, copy) kMeBasicBlock scrollBlock;

- (void)setUIWithMaterialArray:(NSArray *)materialArray;
- (void)reloadCategoryTitlesWithIndex:(NSInteger)index;

- (void)setScrollViewCanScroll:(BOOL)canScroll;

@end

NS_ASSUME_NONNULL_END
