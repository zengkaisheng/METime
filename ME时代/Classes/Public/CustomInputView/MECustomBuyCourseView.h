//
//  MECustomBuyCourseView.h
//  志愿星
//
//  Created by gao lei on 2019/9/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MECustomBuyCourseView : UIView
//购买课程
+ (void)showCustomBuyCourseViewWithTitle:(NSString *)title content:(NSString *)content buyBlock:(kMeBasicBlock)buyBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

//购买Vip
+ (void)showCustomBuyVIPViewWithTitle:(NSString *)title confirmBtn:(NSString *)confirmBtn buyBlock:(kMeBasicBlock)buyBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
