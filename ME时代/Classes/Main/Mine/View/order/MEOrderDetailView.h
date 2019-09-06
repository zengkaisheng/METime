//
//  MEOrderDetailView.h
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEAppointDetailModel;
@class MEOrderDetailModel;
const static CGFloat kMEOrderDetailViewHeight = 182;
const static CGFloat kMEOrderDetailViewLogistHeight = 72;
const static CGFloat kMEOrderDetailViewTopUpHeight = 68;
@interface MEOrderDetailView : UIView

@property (nonatomic, copy) kMeBasicBlock topUpBlock;

- (void)setUIWithModel:(MEOrderDetailModel *)model orderType:(MEOrderStyle)type;
- (void)setAppointUIWithModel:(MEAppointDetailModel *)model orderType:(MEAppointmenyStyle)type;
+ (CGFloat)getViewHeightWithType:(MEOrderStyle)type Model:(MEOrderDetailModel *)model;

@end
