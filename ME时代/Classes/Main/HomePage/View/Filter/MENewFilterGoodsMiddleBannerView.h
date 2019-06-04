//
//  MENewFilterGoodsMiddleBannerView.h
//  ME时代
//
//  Created by gao lei on 2019/6/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MENewFilterGoodsMiddleBannerView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;

@property (nonatomic,copy)kMeIndexBlock selectedIndexBlock;

- (void)setUIWithImages:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
