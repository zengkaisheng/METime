//
//  MEProductDetailsHeaderView.h
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodDetailModel;
#define kMEProductDetailsHeaderViewHeight (375*kMeFrameScaleX())

@interface MEProductDetailsHeaderView : UIView

//商品详情
- (void)setUIWithModel:(MEGoodDetailModel *)model;
//积分详情
- (void)setIntergalUIWithModel:(MEGoodDetailModel *)model;
+ (CGFloat)getViewHeight;
@end
