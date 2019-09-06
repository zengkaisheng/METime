//
//  METopUpTipsView.h
//  ME时代
//
//  Created by gao lei on 2019/9/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface METopUpTipsView : UIView
//支付成功
+ (void)showTopUpTipsViewWithName:(NSString *)name phone:(NSString *)phone tips:(NSString *)tips cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;
//充值操作
+ (void)showTopUpTipsViewWithPhone:(NSString *)phone money:(NSString *)money successBlock:(kMeBasicBlock)successBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
