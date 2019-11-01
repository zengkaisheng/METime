//
//  AppDelegate.h
//  志愿星
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic , assign)NSInteger unMessageCount;

/** 横竖屏 */
@property (nonatomic, assign) UIInterfaceOrientationMask orientationMask;

- (void)reloadTabBar;

@end

