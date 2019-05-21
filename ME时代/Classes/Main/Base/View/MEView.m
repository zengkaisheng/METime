//
//  MEView.m
//  ME时代
//
//  Created by hank on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MEView

#pragma mark - label

+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt str:(NSString *)text lineNum:(NSInteger)ln font:(UIFont *)ft{
    UILabel *lbl = [[UILabel alloc]initWithFrame:rt];
    lbl.text = text;
    if(color_txt)lbl.textColor = color_txt;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.numberOfLines = ln;
    if(ft)lbl.font = ft;
    
    return lbl;
}


+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt str:(NSString *)text lineNum:(NSInteger)ln{
    return [self lblWithFram:rt textColor:color_txt str:text lineNum:ln font:[UIFont systemFontOfSize:18]];
}

+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt str:(NSString *)text font:(UIFont *)ft{
    return [self lblWithFram:rt textColor:color_txt str:text lineNum:1 font:ft];
}

+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt bgColor:(UIColor *)color_bg str:(NSString *)text font:(UIFont *)ft{
    UILabel *lbl = [self lblWithFram:rt textColor:color_txt str:text font:ft];
    lbl.backgroundColor = color_bg;
    return lbl;
}

+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt font:(UIFont *)ft{
    return [self lblWithFram:rt textColor:color_txt str:@"" lineNum:1 font:ft];
}

+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt font:(UIFont *)ft align:(NSTextAlignment)align{
    UILabel *lbl = [self lblWithFram:rt textColor:color_txt str:@"" lineNum:1 font:ft];
    lbl.textAlignment = align;
    return lbl;
}
+(UILabel *)lblWithFram:(CGRect)rt textColor:(UIColor *)color_txt str:(NSString *)text font:(UIFont *)ft align:(NSTextAlignment)align{
    UILabel *lbl = [self lblWithFram:rt textColor:color_txt str:@"" lineNum:1 font:ft];
    lbl.textAlignment = align;
    lbl.text = text;
    return lbl;
}

#pragma mark - button

+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img{
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setImage:img forState:UIControlStateNormal];
    return btn;
}

+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title line:(NSInteger)ln{
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    if(img) [btn setBackgroundImage:img forState:UIControlStateNormal];
    btn.titleLabel.numberOfLines = ln;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:(19-title.length)];
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}


+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title{
    return [self btnWithFrame:rect Img:img title:title line:1];
}

+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act{
    MEBaseButton *btn = [self btnWithFrame:rect Img:img title:title];
    [btn addTarget:target action:act forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(MEBaseButton *)greenBtnWithFrame:(CGRect)rect title:(NSString *)title target:(id)target Action:(SEL)act{
    MEBaseButton *btn = [self btnWithFrame:rect Img:nil title:title target:target Action:act];
    //    [btn setNormalBgColor:K_COLOR_T8TGREEN hightlightBgColor:K_COLOR_T8TGREEN_SELECTED];
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    return btn;
}

+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act{
    return [self btnWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) Img:img title:title target:target Action:act];
}

+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act center:(CGPoint)ct{
    MEBaseButton *btn = [self btnWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) Img:img title:title target:target Action:act];
    btn.center = ct;
    return btn;
}

+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act titleColor:(UIColor *)color{
    MEBaseButton *btn = [self btnWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) Img:img title:title target:target Action:act];
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}

+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act center:(CGPoint)ct titleColor:(UIColor *)color{
    MEBaseButton *btn = [self btnWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) Img:img title:title target:target Action:act];
    btn.center = ct;
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}

+(MEBaseButton *)btnWithFrame:(CGRect)rect Title:(NSString *)title titleFont:(UIFont *)ft aboveImg:(UIImage *)img imgCenter:(CGPoint)ct_img target:(id)target Action:(SEL)act{
    MEBaseButton *btn = [self btnWithFrame:rect
                                  Img:nil
                                title:title
                               target:target
                               Action:act];
    btn.titleLabel.font = ft;
    UIImageView *imgv = [[UIImageView alloc]initWithImage:img];
    [btn addSubview:imgv];
    imgv.center = ct_img;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, img.size.width, 0, 0)];//2+10
    return btn;
}

+(MEBaseButton *)btnWithTitle:(NSString *)title titleFont:(UIFont *)ft aboveImg:(UIImage *)img target:(id)target Action:(SEL)act{
    MEBaseButton *btn = [self btnWithFrame:CGRectMake(0, 0, img.size.width+[title sizeWithFont:ft].width+20, img.size.height) Title:title titleFont:ft aboveImg:img imgCenter:CGPointMake(img.size.width/2, img.size.height/2) target:target Action:act];
    return btn;
}

+(MEBaseButton *)btnWithTitle:(NSString *)title aboveImg:(UIImage *)img target:(id)target Action:(SEL)act{
    return [self btnWithTitle:title titleFont:[UIFont boldSystemFontOfSize:18] aboveImg:img target:target Action:act];
}

#pragma mark - textfield

+(UITextField *)tfWithFrame:(CGRect)rect borderstyle:(UITextBorderStyle)bs placeholder:(NSString *)str delegate:(id)tar{
    UITextField *tf = [[UITextField alloc]initWithFrame:rect];
    tf.borderStyle = bs;
    tf.placeholder = str;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.delegate = tar;
    return tf;
}

+(UITextField *)tfWithFrame:(CGRect)rect border:(UITextBorderStyle)bs {
    UITextField *tf = [[UITextField alloc]initWithFrame:rect];
    tf.borderStyle = bs;
    
    return tf;
}
+(UITextField *)tfWithFrame:(CGRect)rect borderColor:(UIColor *)bdColor placeholder:(NSString *)str delegate:(id)tar{
    UITextField *tf = [[UITextField alloc]initWithFrame:rect];
    tf.borderStyle = UITextBorderStyleNone;
    tf.placeholder = str;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.delegate = tar;
    tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, rect.size.height)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    
    tf.layer.borderColor = bdColor.CGColor;
    tf.layer.borderWidth = 0.5;
    
    return tf;
}

+(UITextField *)tfWithFrame:(CGRect)rect bgImg:(UIImage *)img placeholder:(NSString *)str delegate:(id)tar{
    UITextField *tf = [[UITextField alloc]initWithFrame:rect];
    tf.borderStyle = UITextBorderStyleNone;
    tf.placeholder = str;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.delegate = tar;
    tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, rect.size.height)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.returnKeyType = UIReturnKeyDone;
    tf.background = img;
    
    return tf;
}

+(UITextField *)tfWithFrame:(CGRect)rect borderColor:(UIColor *)bdColor{
    UITextField *tf = [[UITextField alloc]initWithFrame:rect];
    tf.borderStyle = UITextBorderStyleNone;
    tf.layer.borderColor = bdColor.CGColor;
    tf.layer.borderWidth = 1;
    return tf;
}

+(UITextField *)tfWithFrame:(CGRect)rect{
    return [self tfWithFrame:rect border:UITextBorderStyleLine];
}

#pragma mark - HUD

//显示HUD 可自定图片、文字
+(void)SHOWHUDWITHHUD:(MBProgressHUD *)HUD imgn:(NSString *)imgname test:(NSString *)text{
    UIImage *img = [UIImage imageNamed:imgname];
    HUD.customView = [[UIImageView alloc]initWithImage:img];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.userInteractionEnabled = YES;
    if ([text isKindOfClass:[NSString class]]) {
        HUD.labelText = text;
    }
    HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.0];
}

+(MBProgressHUD *)SHOWHUDWITHImgn:(NSString *)imgname test:(NSString *)text{
    if (![imgname isKindOfClass:[NSString class]] || imgname.length < 1) {
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
        if (text.length > 10) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = text;
            hud.detailsLabelFont = hud.labelFont;
        }else{
            hud.labelText = text;
        }
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        hud.dimBackground = NO;
        [hud hide:YES afterDelay:1.0];
        return hud;
    }
    
    UIWindow *window = kMeCurrentWindow;//[[UIApplication sharedApplication].windows firstObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:window];
    HUD.center = CGPointMake(160, SCREEN_HEIGHT/2);
    HUD.userInteractionEnabled = YES;
    [window addSubview:HUD];
    [MEView SHOWHUDWITHHUD:HUD imgn:imgname test:text];
    return HUD;
}

//显示HUD 可自定文字
+(void)showOKHUDWithHUD:(MBProgressHUD *)HUD test:(NSString *)text{
    [self SHOWHUDWITHHUD:HUD imgn:kSuccessHUDImgName test:text];
}

+(void)showFailHUDWithHUD:(MBProgressHUD *)HUD text:(NSString *)text{
    [self SHOWHUDWITHHUD:HUD imgn:kFailHUDImgName test:text];
}

+(void)showFailHUDWithText:(NSString *)text{
    UIWindow *window = kMeCurrentWindow;//[[UIApplication sharedApplication].windows firstObject];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:window];
    HUD.center = CGPointMake(160, SCREEN_HEIGHT/2);
    HUD.userInteractionEnabled = YES;
    [window addSubview:HUD];
    
    [self showFailHUDWithHUD:HUD text:text];
}


//显示提示成功的HUD 可自定文字
+(void)showOKHUDWithText:(NSString *)text{
    UIWindow *window = kMeCurrentWindow;//[[UIApplication sharedApplication].windows firstObject];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:window];
    HUD.userInteractionEnabled = YES;
    HUD.center = CGPointMake(160, SCREEN_HEIGHT/2);
    [window addSubview:HUD];
    
    [self showOKHUDWithHUD:HUD test:text];
}


#pragma mark - RoundCornar

+(void)setRoundCornerFor:(UIView *)_v radiu:(CGFloat)r bdColor:(UIColor *)c_bd bdW:(CGFloat)w_bd{
    _v.layer.masksToBounds = YES;
    _v.layer.cornerRadius = r;
    _v.layer.borderWidth = w_bd;
    _v.layer.borderColor = c_bd.CGColor;
}

+(void)setRoundCornerFor:(UIView *)_v radiu:(CGFloat)r bdColor:(UIColor *)c_bd{
    [self setRoundCornerFor:_v radiu:r bdColor:c_bd bdW:1];
}

+(void)setRoundCornerFor:(UIView *)_v radiu:(CGFloat)r{
    [self setRoundCornerFor:_v radiu:r bdColor:[UIColor clearColor] bdW:1];
}



#define FONT_BBI [UIFont systemFontOfSize:14]

+(UIBarButtonItem *)borderItemWithTarget:(id)tar act:(SEL)act title:(NSString *)text{
    UIButton *btn = [self btnWithImg:[UIImage imageNamed:@"bbi_border"] title:text target:tar Action:act];
    btn.titleLabel.font = FONT_BBI;
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return bbi;
}

+(UIBarButtonItem *)unborderItemWithTarget:(id)tar act:(SEL)act title:(NSString *)text{
    return  [UIBarButtonItem unborderItemWithTarget:tar act:act title:text];
}


+(UIBarButtonItem *)ImageItemWithTarget:(id)tar act:(SEL)act imgn:(NSString *)imgn{
    UIButton *btn = [self btnWithImg:kMeGetAssetImage(imgn) title:@"" target:tar Action:act];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

#pragma mark - cell

+(void)setBgColorForCell:(UITableViewCell *)cell bgColor:(UIColor *)color{
    UIView *bg = [[UIView alloc]init];
    bg.backgroundColor = color;
    [cell setBackgroundView:bg];
    cell.textLabel.backgroundColor = cell.detailTextLabel.backgroundColor = color;
}



@end
