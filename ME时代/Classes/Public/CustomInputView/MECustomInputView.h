//
//  MECustomInputView.h
//  志愿星
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^kMeCustomerBlock)(NSString *str, BOOL isShow);

@interface MECustomInputView : UIView

+ (void)showCustomInputViewWithTitle:(NSString *)title content:(NSString *)content showChooseBtn:(BOOL)isShow isInput:(BOOL)isInput saveBlock:(kMeCustomerBlock)saveBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
