//
//  MEWithdrawalView.h
//  ME时代
//
//  Created by hank on 2018/12/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEWithdrawalParamModel;
@interface MEWithdrawalView : UIView

+ (CGFloat)getViewHeight;
@property (nonatomic, copy) kMeBasicBlock applyFinishBlock;
@property (nonatomic, assign) BOOL isCouponMoney;

@property (nonatomic, assign) BOOL isLianTong;
@end
