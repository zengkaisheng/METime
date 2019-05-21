//
//  UIBarButtonItem+MEExtension.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MEExtension)

/**
 *  导航栏上有图片的
 *  @param image     图片名称
 *  @param highImage 高亮状态下图片名称
 *
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action StringName:(NSString *)name TextColor:(UIColor*)color;
+ (UIBarButtonItem *)unborderItemWithTarget:(id)tar act:(SEL)act title:(NSString *)text;
+ (UIBarButtonItem *)unborderItemWithTarget:(id)tar act:(SEL)act title:(NSString *)text selectTitle:(NSString *)selectTitle isLeftItem:(BOOL)isLeft;
+ (UIBarButtonItem *)unborderItemWithTarget:(id)tar act:(SEL)act title:(NSString *)text selectTitle:(NSString *)selectTitle;
- (void)setTextItemTextColor:(UIColor *)color;

+ (UIBarButtonItem *)enlargeTouchitemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

@end
