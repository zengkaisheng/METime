//
//  MEPrizeHeaderView.h
//  志愿星
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEPrizeDetailsModel;

const static CGFloat kMEPrizeHeaderViewHeight = 332;

@interface MEPrizeHeaderView : UIView

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (nonatomic, copy) kMeBasicBlock tapBlock;

- (void)setUIWithModel:(MEPrizeDetailsModel *)model;

@end

NS_ASSUME_NONNULL_END
