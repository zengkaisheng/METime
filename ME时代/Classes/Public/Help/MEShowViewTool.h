//
//  MEShowViewTool.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEShowViewTool : NSObject
    
+ (void)showMessage:(NSString *)text view:(UIView *)view;
+ (void)SHOWHUDWITHHUD:(MBProgressHUD *)HUD test:(NSString *)text;
    
@end
