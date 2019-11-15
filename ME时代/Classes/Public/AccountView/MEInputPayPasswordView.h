//
//  MEInputPayPasswordView.h
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEInputPayPasswordView : UIView

+ (void)showInputPayPasswordViewWithTitle:(NSString *)title money:(NSString *)money confirmBlock:(kMeTextBlock)confirmBlock forgetBlock:(kMeBasicBlock)forgetBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
