//
//  MECommonTool.h
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MECommonTool : NSObject

+ (void)initAppSomeThing;

/**
 *  拿指定VC
 */
+ (id)getVCWithClassWtihClassName:(Class)targetClass targetResponderView:(UIResponder *)targetResponder;
+ (UIViewController *)getClassWtihClassName:(Class)aClass targetVC:(UIViewController *)target;

/**
 *  校验手机号码
 */
+ (BOOL)isValidPhoneNum:(NSString *)strPhoneNum;

//color->image
+ (UIImage*) createImageWithColor:(UIColor*) color;

+ (void)showMessage:(NSString *)text view:(UIView *)view;
+ (void)SHOWHUDWITHHUD:(MBProgressHUD *)HUD test:(NSString *)text;

+ (void)showWithTellPhone:(NSString *)Number inView:(UIView *)view;

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
+ (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;

+ (void)doNavigationWithEndLocation:(NSArray *)endLocation;

//save image to system
+ (void)saveImg:(UIImage *)img;
//比较时间
+ (BOOL)compareOneDay:(NSString *)oneDayStr withAnotherDay:(NSString *)anotherDayStr;
//获取当前时间
+(NSString*)getCurrentTimesWithFormat:(NSString *)str;
//检查版本
+ (void)checkVersion;
+ (void)newCheckVersion;
+ (void)getUIPasteboardContent;

+ (NSString *)changeformatterWithFen:(id)money;
+ (BOOL)openWXMiniProgram:(NSString *)path username:(NSString *)username;
+(BOOL) openWeChat:(NSString *)url;
//时时间戳转换
+ (NSString *)changeTimeStrWithtime:(NSString*)timeStampString;
+ (NSMutableAttributedString *)fristStrWithFont:(UIFont *)font content:(NSString *)content;

+ (NSString *)getImagePath:(UIImage *)Image filename:(NSString*)filaname;
+ (NSString *)getNoCompressImagePath:(UIImage *)Image filename:(NSString*)filaname;
@end
