//
//  MEBargainRuleView.h
//  志愿星
//
//  Created by gao lei on 2019/7/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEBargainRuleView : UIView

+ (void)showBargainRuleViewWithTitle:(NSString *)title cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
