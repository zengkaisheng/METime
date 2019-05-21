//
//  MEView.h
//  ME时代
//
//  Created by hank on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEBaseButton.h"

#define kSuccessHUDImgName @"HUD_success"
#define kFailHUDImgName @"HUD_fail"

@interface MEView : NSObject

#pragma mark - label

/*
 
 参数：
 rt     位置大小
 ft     字体大小，
 text    显示的文字
 color_txt  文字颜色
 align    对齐方式
 ln     行数
 color_bg  背景颜色
 */
+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt str:(NSString *)text lineNum:(NSInteger)ln;
+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt str:(NSString *)text lineNum:(NSInteger)ln font:(UIFont *)ft;
+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt font:(UIFont *)ft;
+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt str:(NSString *)text font:(UIFont *)ft;
+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt bgColor:(UIColor *)color_bg str:(NSString *)text font:(UIFont *)ft;
+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt str:(NSString *)text font:(UIFont *)ft align:(NSTextAlignment)align;
+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt font:(UIFont *)ft align:(NSTextAlignment)align;

#pragma mark - button
+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img;
+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title;
+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title line:(NSInteger)ln;
+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act;
+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act;
+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act center:(CGPoint)ct;
+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act titleColor:(UIColor *)color;
+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act center:(CGPoint)ct titleColor:(UIColor *)color;
+(MEBaseButton *)btnWithTitle:(NSString *)title aboveImg:(UIImage *)img target:(id)target Action:(SEL)act;
+(MEBaseButton *)btnWithTitle:(NSString *)title titleFont:(UIFont *)ft aboveImg:(UIImage *)img target:(id)target Action:(SEL)act;

+(MEBaseButton *)btnWithFrame:(CGRect)rect Title:(NSString *)title titleFont:(UIFont *)ft aboveImg:(UIImage *)img imgCenter:(CGPoint)ct_img target:(id)target Action:(SEL)act;
+(MEBaseButton *)greenBtnWithFrame:(CGRect)rect title:(NSString *)title target:(id)target Action:(SEL)act;

#pragma mark - textfield


+(UITextField *)tfWithFrame:(CGRect)rect;
+(UITextField *)tfWithFrame:(CGRect)rect borderColor:(UIColor *)bdColor;
+(UITextField *)tfWithFrame:(CGRect)rect borderColor:(UIColor *)bdColor placeholder:(NSString *)str delegate:(id)tar;
+(UITextField *)tfWithFrame:(CGRect)rect borderstyle:(UITextBorderStyle)bs placeholder:(NSString *)str  delegate:(id)tar;
+(UITextField *)tfWithFrame:(CGRect)rect bgImg:(UIImage *)img placeholder:(NSString *)str delegate:(id)tar;



#pragma mark - HUD

//显示HUD 可自定图片、文字
+(void)SHOWHUDWITHHUD:(MBProgressHUD *)HUD imgn:(NSString *)imgname test:(NSString *)text;
+(MBProgressHUD *)SHOWHUDWITHImgn:(NSString *)imgname test:(NSString *)text;
//显示HUD 可自定文字
+(void)showOKHUDWithHUD:(MBProgressHUD *)HUD test:(NSString *)text;
//显示提示成功的HUD 可自定文字
+(void)showOKHUDWithText:(NSString *)text;

+(void)showFailHUDWithHUD:(MBProgressHUD *)HUD text:(NSString *)text;

+(void)showFailHUDWithText:(NSString *)text;

#pragma mark - RoundCornar

+(void)setRoundCornerFor:(UIView *)_v radiu:(CGFloat)r;
+(void)setRoundCornerFor:(UIView *)_v radiu:(CGFloat)r bdColor:(UIColor *)c_bd;
+(void)setRoundCornerFor:(UIView *)_v radiu:(CGFloat)r bdColor:(UIColor *)c_bd bdW:(CGFloat)w_bd;

#pragma mark - bbi

//返回带边框的UIBarButtonItem
+(UIBarButtonItem *)borderItemWithTarget:(id)tar act:(SEL)act title:(NSString *)text;
//返回不带边框的UIBarButtonItem
+(UIBarButtonItem *)unborderItemWithTarget:(id)tar act:(SEL)act title:(NSString *)text;
//返回图片样式的UIBarButtonItem
+(UIBarButtonItem *)ImageItemWithTarget:(id)tar act:(SEL)act imgn:(NSString *)imgn;


#pragma mark - cell


+(void)setBgColorForCell:(UITableViewCell *)cell bgColor:(UIColor *)color;

@end
