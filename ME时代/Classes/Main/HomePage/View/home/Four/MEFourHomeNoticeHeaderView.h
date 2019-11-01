//
//  MEFourHomeNoticeHeaderView.h
//  志愿星
//
//  Created by gao lei on 2019/7/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEAdModel;
NS_ASSUME_NONNULL_BEGIN

@interface MEFourHomeNoticeHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView1;
@property (nonatomic,copy)kMeIndexBlock selectedIndexBlock; //banner图点击下标

- (void)setUIWithArray:(NSArray *)array leftBanner:(MEAdModel *)leftBanner;

@end

NS_ASSUME_NONNULL_END
