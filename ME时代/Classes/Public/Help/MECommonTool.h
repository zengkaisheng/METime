//
//  MECommonTool.h
//  志愿星
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

/**
 *  校验身份证号码是否正确
 */
+ (BOOL)checkIdentityStringValid:(NSString *)identity;

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
//获取粘贴板优惠券信息
+ (void)getUIPasteboardContent;

+ (void)postAuthRegId;

+ (NSString *)changeformatterWithFen:(id)money;
+ (BOOL)openWXMiniProgram:(NSString *)path username:(NSString *)username;
+(BOOL) openWeChat:(NSString *)url;
//时时间戳转换
+ (NSString *)changeTimeStrWithtime:(NSString*)timeStampString;
+ (NSMutableAttributedString *)fristStrWithFont:(UIFont *)font content:(NSString *)content;

+ (NSString *)getImagePath:(UIImage *)Image filename:(NSString*)filaname;
+ (NSString *)getNoCompressImagePath:(UIImage *)Image filename:(NSString*)filaname;

//获取ip地址
+ (NSString *)getIpAddresses;
@end
