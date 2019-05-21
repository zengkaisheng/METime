//
//  AppDelegate.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "AppDelegate.h"
#import "METabBarVC.h"
#import "MERCConversationListVC.h"
#import <UserNotifications/UserNotifications.h>
#import "METabBarVC.h"
#import "MELoginVC.h"
#import "MEJupshContentModel.h"

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "MENavigationVC.h"
#import "METhridProductDetailsVC.h"
#import "MEMyOrderDetailVC.h"

#import "MEGuideVC.h"
#import "MEAppointmentDetailVC.h"
#import "MEArticleDetailVC.h"
#import "MEArticelModel.h"

@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MECommonTool initAppSomeThing];
    
#pragma mark - init IM sdk
    [[TUIKit sharedInstance] initKit:sdkAppid accountType:sdkAccountType withConfig:[TUIKitConfig defaultConfig]];
    if([MEUserInfoModel isLogin] && kMeUnNilStr(kCurrentUser.tls_data.tls_id).length && kMeUnNilStr(kCurrentUser.tls_data.user_tls_key).length){
        NSLog(@"%@    %@",kMeUnNilStr(kCurrentUser.tls_data.tls_id),kMeUnNilStr(kCurrentUser.tls_data.user_tls_key));
        [[TUIKit sharedInstance] loginKit:kMeUnNilStr(kCurrentUser.tls_data.tls_id) userSig:kMeUnNilStr(kCurrentUser.tls_data.user_tls_key) succ:^{
            NSLog(@"sucess");
        } fail:^(int code, NSString *msg) {
            NSLog(@"fial");
        }];
    }
    
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                
            } else {
                //点击不允许
                
            }
        }];
    }
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        
    }
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    
    
#pragma mark - 极光tuis
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey
                          channel:@"App Store"
                 apsForProduction:JpushType
            advertisingIdentifier:advertisingId];
    if([MEUserInfoModel isLogin]){
        //极光alias
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setAlias:kMeUnNilStr(kCurrentUser.uid) completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:0];
        });
    }
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    NSString *frist = [[NSUserDefaults standardUserDefaults] objectForKey:kMEAppVersion];
    if(kMeUnNilStr(frist).length){
        [self.window setRootViewController:[METabBarVC new]];
    }else{
        MEGuideVC *fvc = [[MEGuideVC alloc] init];
        [self.window setRootViewController:fvc];
    }
    [self.window makeKeyAndVisible];
    [MECommonTool newCheckVersion];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImUnread) name:TUIKitNotification_TIMRefreshListener object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onForceOffline:) name:TUIKitNotification_TIMUserStatusListener object:nil];
    //
    return YES;
}

#pragma mark - 友盟分享的回调
#pragma mark 这里判断是否发起的请求为微信支付


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[UMSocialManager defaultManager] handleOpenURL:url];
    //用WXApi的方法调起微信客户端的支付页面
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    //如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",UMWXAppId]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"url =%@",url);
#pragma mark 支付宝的回调之后的方法
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        
    }
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
#pragma mark 微信的回调之后的方法
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",UMWXAppId]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}

- (void)onResp:(BaseResp*)resp{
    //这里判断回调信息是否为 支付
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
                //如果支付成功的话，全局发送一个通知，支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:WXPAY_SUCCESSED];
                break;
            default:
                //如果支付失败的话，全局发送一个通知，支付失败
                [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:WXPAY_FAILED];
                NSString *strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"%@",strMsg);
                //                kMeAlter(@"提示", strMsg);
                break;
        }
    }
}


#pragma mark - IM

- (void)onForceOffline:(NSNotification *)notification
{
    if ([MEUserInfoModel isLogin]){
        [MEUserInfoModel logout];
        HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"提示" andMessage:@"您的帐号在别的设备上登录，您被迫下线！请退出重新登录!"];
        alertView.isSupportRotating = YES;
        [alertView addButtonWithTitle:@"确定" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            [MEWxLoginVC presentLoginVCWithIsShowCancel:NO SuccessHandler:nil failHandler:nil];
        }];
        [alertView show];
    }
}



- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

//获取deviceToken方法
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    NSLog(@"deviceToken%@",token);
    [self configOnAppRegistAPNSWithDeviceToken:deviceToken];
    
}

- (void)configOnAppRegistAPNSWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    //    [[TIMManager sharedInstance] log:TIM_LOG_INFO tag:@"SetToken" msg:[NSString stringWithFormat:@"My Token is :%@", token]];
    TIMTokenParam *param = [[TIMTokenParam alloc] init];
#ifdef TestVersion
    param.busiId = 12831;
#else
    param.busiId = 12832;
#endif
    [param setToken:deviceToken];
    //    [[TIMManager sharedInstance] setToken:param];
    [[TIMManager sharedInstance] setToken:param succ:^{
        NSLog(@"-----> 上传 token 成功 ");
    } fail:^(int code, NSString *msg) {
        NSLog(@"-----> 上传 token 失败 ");
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support app 在前台 10以上
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    /*
     type 1 商品 2.订单详情
     aps =     {
     alert = "ME\U65f6\U4ee3\U6c28\U57fa\U9178\U6d01\U9762\U6155\U65af\Uff08\U90ae\U8d3910\U5143\Uff09";
     badge = 2;
     };
     content =     {
     id = 4;
     type = 2;
     };
     */
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"jpushNotificationCenter willPresentNotification %@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    [self dealJPushActionWithDic:userInfo];
}

// iOS 10 Support app 在后台 10以上
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"jpushNotificationCenter didReceiveNotificationResponse%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    [self dealJPushActionWithDic:userInfo];
}

// 不管app是在前台运行还是在后台运行，系统收到推送时都会调用该方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"didReceiveRemoteNotification fetchCompletionHandler%@",userInfo);
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self dealJPushActionWithDic:userInfo];
}

// 如果app在前台运行，系统收到推送时会调用该方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required, For systems with less than or equal to iOS 6
    NSLog(@"didReceiveRemoteNotification %@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    [self dealJPushActionWithDic:userInfo];
}

//iOS10以下使用这个方法接收通知
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    // userInfo为远程推送的内容
//    NSLog(@"didReceiveRemoteNotification-----------------%@",userInfo);
////    [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
//}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"willPresentNotification %@",userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"didReceiveNotificationResponse %@",userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
    if (![self.window.rootViewController isKindOfClass:[METabBarVC class]]) return;
    // 取到tabbarcontroller
    METabBarVC *tabBarController = (METabBarVC*)self.window.rootViewController;
    tabBarController.selectedIndex = 4;
}

#pragma mark 本地 IM未读数

- (void)applicationWillResignActive:(UIApplication *)application {
    if([MEUserInfoModel isLogin] ){
        [self getImUnread];
        application.applicationIconBadgeNumber =   self.unMessageCount;
    }else{
        application.applicationIconBadgeNumber =   0;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if([MEUserInfoModel isLogin]){
        [self getImUnread];
        application.applicationIconBadgeNumber =   self.unMessageCount;
        __block UIBackgroundTaskIdentifier bgTaskID;
        bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
            //不管有没有完成，结束 background_task 任务
            [application endBackgroundTask: bgTaskID];
            bgTaskID = UIBackgroundTaskInvalid;
        }];
        [self configOnAppEnterBackground];
    }else{
        application.applicationIconBadgeNumber =   0;
    }
}

- (void)configOnAppEnterBackground
{
    NSUInteger unReadCount = self.unMessageCount;
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:(int)unReadCount];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        
    } fail:^(int code, NSString * err) {
        
    }];
}

- (void)getImUnread{
    if([MEUserInfoModel isLogin]){
        NSInteger unread = 0;
        TIMManager *manager = [TIMManager sharedInstance];
        NSArray *convs = [manager getConversationList];
        for (TIMConversation *conv in convs) {
            if(convs == nil){
                continue;
            }
            
            if([conv getType] == TIM_SYSTEM){
                continue;
            }
            
            TIMMessage *msg = [conv getLastMsg];
            if(msg == nil){
                continue;
            }
            
            if(kMeUnNilStr([conv getReceiver]).length == 0){
                continue;
            }
            if([kMeUnNilStr([conv getReceiver]) isEqualToString:kMeUnNilStr(kCurrentUser.tls_data.tls_id)]){
                continue;
            }
            if([conv getUnReadMessageNum] == 0){
                continue;
            }
            unread +=[conv getUnReadMessageNum];
        }
        self.unMessageCount = unread;
        kNoticeReloadkUnMessage
    }else{
        self.unMessageCount = 0;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    kNoticeUnNoticeMessage
    [MECommonTool getUIPasteboardContent];
    if ([MEUserInfoModel isLogin]) {
        [[TIMManager sharedInstance] doForeground:^() {
            
        } fail:^(int code, NSString * err) {
            
        }];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消下载
    [mgr cancelAll];
    // 2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
}


#pragma mark - JPushAction

- (void)dealJPushActionWithDic:(NSDictionary *)userInfo{
    NSLog(@"%@",userInfo);
    kNoticeUnNoticeMessage
    NSDictionary *dict =  kMeUnDic(userInfo)[@"aps"];
    if([dict count]){
        NSString *messageStr = dict[@"alert"];
        NSDictionary *contentDic =  kMeUnDic(userInfo)[@"content"];
        MEJupshContentModel *model =  [MEJupshContentModel mj_objectWithKeyValues:contentDic];
        //        id TypeId = contentDic[@"id"];
        //        NSString *type = contentDic[@"type"];
        //        NSInteger msg_id = [contentDic[@"msg_id"] integerValue];
        NSString *strType = kMeUnNilStr(model.type);
        if([strType isEqualToString:@"1"] || [strType isEqualToString:@"2"]|| [strType isEqualToString:@"3"]|| [strType isEqualToString:@"7"]|| [strType isEqualToString:@"9"]|| [strType isEqualToString:@"10"]|| [strType isEqualToString:@"11"]|| [strType isEqualToString:@"12"]|| [strType isEqualToString:@"16"]){
            //1跳商品  2跳订单详情 3更新 4B店铺访问 5C店铺访问 7预约管理 8投票
            //跳url 9
            //跳动态 10
            //跳文章 11
            //跳营销活动 12
            //16兑换码商品审核不通过
            HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"提示" andMessage:messageStr];
            alertView.isSupportRotating = YES;
            [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            }];
            [alertView addButtonWithTitle:@"立即前往" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
                if (![self.window.rootViewController isKindOfClass:[METabBarVC class]]) return;
                [MEPublicNetWorkTool getUserReadedNoticeWithNoticeId:model.msg_id SuccessBlock:^(ZLRequestResponse *responseObject) {
                    kNoticeUnNoticeMessage
                } failure:nil];
                // 取到tabbarcontroller
                METabBarVC *tabBarController = ( METabBarVC*)self.window.rootViewController;
                // 取到navigationcontroller
                MENavigationVC *nav = (MENavigationVC *)tabBarController.selectedViewController;
                UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
                if([strType isEqualToString:@"1"]){
                    METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:[kMeUnNilStr(model.idField) integerValue]];
                    [baseVC.navigationController pushViewController:dvc animated:YES];
                }else if ([strType isEqualToString:@"2"]){
                    MEMyOrderDetailVC *dvc = [[MEMyOrderDetailVC alloc]initWithOrderGoodsSn:kMeUnNilStr(model.idField)];
                    [baseVC.navigationController pushViewController:dvc animated:YES];
                }else if([strType isEqualToString:@"3"]){
                    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",kMEAppId];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }else if ([strType isEqualToString:@"7"]){
                    MEAppointmentDetailVC *dvc = [[MEAppointmentDetailVC alloc]initWithReserve_sn:kMeUnNilStr(model.idField) userType:MEClientBTypeStyle];
                    [baseVC.navigationController pushViewController:dvc animated:YES];
                }else if([strType isEqualToString:@"9"]){
                    NSString *urlStr = kMeUnNilStr(model.idField);
                    NSLog(@"%@",urlStr);
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }else if([strType isEqualToString:@"10"]){
                    [baseVC.navigationController popToRootViewControllerAnimated:YES];
                    tabBarController.selectedIndex = 2;
                }else if([strType isEqualToString:@"11"]){
                    NSString *urlStr = kMeUnNilStr(model.idField);
                    MEArticelModel *model = [MEArticelModel new];
                    model.article_id = [urlStr integerValue];
                    MEArticleDetailVC *vc = [[MEArticleDetailVC alloc]initWithModel:model];
                    [baseVC.navigationController pushViewController:vc animated:YES];
                }else if([strType isEqualToString:@"12"]){
                    [baseVC.navigationController popToRootViewControllerAnimated:YES];
                    tabBarController.selectedIndex = 2;
                }else{
                    
                }
            }];
            [alertView show];
        }
    }
}



@end
