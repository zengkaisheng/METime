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

- (void)setUIWithBackgroundImage:(NSString *)bgImage bannerImage:(NSString *)bannerImage;

@end

NS_ASSUME_NONNULL_END
