//
//  MECustomInputPhoneView.h
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MECustomInputPhoneView : UIView

+ (void)showCustomInputPhoneViewWithTitle:(NSString *)title contentTitle:(NSString *)contentTitle saveBlock:(kMeTextBlock)saveBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
