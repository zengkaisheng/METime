//
//  MEBargainSuccessView.h
//  ME时代
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEBargainSuccessView : UIView

+ (void)showBargainSuccessWithTitle:(NSString *)title shareBlock:(kMeBasicBlock)shareBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
