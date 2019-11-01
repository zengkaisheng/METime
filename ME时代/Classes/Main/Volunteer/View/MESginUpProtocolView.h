//
//  MESginUpProtocolView.h
//  志愿星
//
//  Created by gao lei on 2019/10/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MESginUpProtocolView : UIView

+ (void)showSginUpProtocolViewWithTitle:(NSString *)title content:(NSString *)content confirmBlock:(kMeBasicBlock)confirmBlock superView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
