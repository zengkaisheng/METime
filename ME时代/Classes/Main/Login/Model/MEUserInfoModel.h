//
//  MEUserInfoModel.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MEUserPathModel.h"

//通知用户退出
#define kUserLogout @"kUserLogout"
#define kNoticeUserLogout [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogout object:nil];
//通知用户登录
#define kUserLogin @"kUserLogin"
#define kNoticeUserLogin [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogin object:nil];


#define kCurrentUser [MEUserInfoModel shareUser]
static NSString *kTokenKey = @"kTokenKey";

@interface MEUserInfoModelTLSData :MEBaseModel

@property (nonatomic, copy) NSString *tls_id;//testmsd_user,msd_user_uid
@property (nonatomic, copy) NSString *user_tls_key;
@property (nonatomic, copy) NSString *admin_tls_key;

@end

@interface MEUserInfoModel : MEBaseModel

+ (MEUserInfoModel *)shareUser;
/**
 *  退出
 */
+ (void)logout;
/**
 *  归档
 */
- (void)save;
/**
 *  删除
 */
- (void)removeFromLocalData;
/**
 *  是否已经登录
 */
+ (BOOL)isLogin;

- (void)setterWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *token;
//@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *rongcloud_token;

//用户身份 4普通会员 3体验店 2营销中心 1售后中心 5店员
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, assign) MEClientTypeStyle client_type;

//淘宝的分享id
@property (nonatomic, copy) NSString *relation_id;
/**
 * admin_id : 舒
 * admin_team : 1
 * ratio_money : 0
 * use_money : 9.90
 * level : 营销中心
 * superior : 向森炎
 * nick_name : 思念的色彩
 * header_pic : https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJ08bvGOVPUziavvOhH87nFgjsicicZl24HibZiaR1m1QTsoJmRxzgA3NXQy2WLpMwy75iaiaFJ7ICW0C6gw/132
 * wait_order : 0
 * pay_order : 2
 * task_order : 0
 path =         {
 "created_at" = "2018-11-09 11:01:15";
 group = member;
 icon = "icon_fenxiaozhognxin.png";
 id = 1;
 name = "\U6211\U7684\U4e2d\U5fc3";
 path = "/pages/distribution/distribution";
 sort = 0;
 "updated_at" = "2018-11-09 11:01:17";
 };
 */

//个人中心的数据
//@property (nonatomic, copy) NSString *admin_id;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *header_pic;
@property (nonatomic, assign) NSInteger wait_order;
@property (nonatomic, assign) NSInteger pay_order;
@property (nonatomic, assign) NSInteger task_order;
@property (nonatomic, copy) MEUserPathModel *path;

@property (nonatomic, strong) MEUserInfoModelTLSData *tls_data;

//个人中心C端
//@property (nonatomic, assign) NSInteger admin_team;
//@property (nonatomic, assign) CGFloat ratio_money;
//@property (nonatomic, assign) CGFloat use_money;
//@property (nonatomic, copy) NSString *level;
//@property (nonatomic, copy) NSString *superior;


@end
