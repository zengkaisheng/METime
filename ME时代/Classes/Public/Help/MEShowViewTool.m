//
//  MEShowViewTool.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShowViewTool.h"

@implementation MEShowViewTool
    
+ (void)showMessage:(NSString *)text view:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (text.length > 10) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = text;
        hud.detailsLabel.font = hud.label.font;
    }else{
        hud.label.text = text;
    }
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}
    
+ (void)SHOWHUDWITHHUD:(MBProgressHUD *)HUD test:(NSString *)text{
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.userInteractionEnabled = YES;
    HUD.label.numberOfLines = 0;
    if ([text isKindOfClass:[NSString class]]) {
        HUD.label.text = text;
    }
    HUD.removeFromSuperViewOnHide = YES;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.0];
}
    
@end
