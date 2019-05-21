//
//  ZJWxPay.h
//  WeChatDemo
//
//  Created by hmc on 15/9/9.
//  Copyright (c) 2015年 yjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "getIPhoneIP.h"
#import "DataMD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "XMLDictionary.h"
//#import "AFNetworking.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface LVWxPay : NSObject
/**
 * 微信支付方法
 * body         商品描述
 * out_trade_no 订单号
 * total_fee    总费用
 **/
+(void)WXPayWithbody:(NSString *)productName andtrade_no:(NSString *)trade_no andPrice:(NSString *)price;
+(void)WXPayWithbody:(NSString *)productName andtrade_no:(NSString *)trade_no andPrice:(NSString *)price notify_url:(NSString*)notify_url;
//解XML
//+ (void)http:(NSString *)xml;
+(void)http:(NSMutableDictionary *)paramsDic;

//md5加密
+ (NSString *) md5:(NSString *)str;
//产生随机字符串
+ (NSString *)generateTradeNO;

+ (BOOL)wxPayWithPayModel:(MEPayModel *)model VC:(UIViewController *)vc price:(NSString *)price;
@end
