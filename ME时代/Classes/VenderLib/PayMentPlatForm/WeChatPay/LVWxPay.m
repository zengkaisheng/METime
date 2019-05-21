//
//  LVWxPay.m
//  WeChatDemo
//
//  Created by hmc on 15/9/9.
//  Copyright (c) 2015年 yjx. All rights reserved.
//

#import "LVWxPay.h"
#import "BankTransferAccountsVC.h"

@implementation LVWxPay

+(void)WXPayWithbody:(NSString *)productName andtrade_no:(NSString *)trade_no andPrice:(NSString *)price notify_url:(NSString*)notify_url
{
    if (![WXApi isWXAppInstalled]) {//检查用户是否安装微信
        //...处理
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未安装微信客户端，暂不提供网页支付，请使用支付宝支付" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //什么都不做
        }]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*trade_type,*partner;
    //应用APPID
    appid =  UMWXAppId;
    
    //微信支付商户号
    mch_id = kWXPAY_MCH_ID;
    
    //产生随机字符串，这里最好使用和安卓端一致的生成逻辑
    nonce_str =[LVWxPay generateTradeNO];
    
    //商品描述
    if (productName) {
        
    }else{
        productName = @"服务";
    }
    body = productName;
    
    //随机产生订单号
    out_trade_no = trade_no;
    
    //交易价格1表示0.01元，10表示0.1元
    NSLog(@"price integerValue]=%@",[NSString stringWithFormat:@"%ld",(long)[price integerValue]]);
    total_fee = [NSString stringWithFormat:@"%@",price];
    // total_fee = @"1"; //支付测试数据
    //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
    spbill_create_ip =[getIPhoneIP getIPAddress:YES];
    
    //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
    notify_url = notify_url;
    
    //类型，iOS集成这个是固定的值
    trade_type = @"APP";
    
    //商户密钥
    partner = kWXPAY_PARTNER_ID;
    
    //获取sign签名 2E3238067FC3F9D27318F76FAA32D56A
    DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid mch_id:mch_id nonce_str:nonce_str partner_id:partner body:body out_trade_no:out_trade_no total_fee:total_fee spbill_create_ip:spbill_create_ip notify_url:notify_url trade_type:trade_type];
    sign = [data getSignForMD5];
    
    //设置参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:appid forKey:@"appid"];//公众账号ID
    [dic setValue:mch_id forKey:@"mch_id"];//商户号
    [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
    [dic setValue:sign forKey:@"sign"];//签名
    [dic setValue:body forKey:@"body"];//商品描述
    [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
    [dic setValue:total_fee forKey:@"total_fee"];//金额
    [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
    [dic setValue:notify_url forKey:@"notify_url"];//通知地址
    [dic setValue:trade_type forKey:@"trade_type"];//交易类型
    
    //    NSString *string = [dic XMLString];
    NSLog(@"dic=%@",dic);
    [LVWxPay http:dic];
}
/**微信支付调用方法
 *
 * body         商品描述
 * out_trade_no 订单号
 * total_fee    总费用
 **/
+(void)WXPayWithbody:(NSString *)productName andtrade_no:(NSString *)trade_no andPrice:(NSString *)price
{
    if (![WXApi isWXAppInstalled]) {//检查用户是否安装微信
        //...处理
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未安装微信客户端，暂不提供网页支付，请使用支付宝支付" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //什么都不做
        }]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*notify_url,*trade_type,*partner;
    //应用APPID
    appid =  UMWXAppId;
    
    //微信支付商户号
    mch_id = kWXPAY_MCH_ID;
    
    //产生随机字符串，这里最好使用和安卓端一致的生成逻辑
    nonce_str =[LVWxPay generateTradeNO];
    
    //商品描述
    if (productName) {
        
    }else{
    productName = @"服务";
    }
    body = productName;

    //随机产生订单号
    out_trade_no = trade_no;
    
    //交易价格1表示0.01元，10表示0.1元
    NSLog(@"price integerValue]=%@",[NSString stringWithFormat:@"%ld",(long)[price integerValue]]);
    total_fee = [NSString stringWithFormat:@"%@",price];
   // total_fee = @"1"; //支付测试数据
    //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
    spbill_create_ip =[getIPhoneIP getIPAddress:YES];

    //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
    notify_url = kWXPAY_NOTIFY_URL;
    
    //类型，iOS集成这个是固定的值
    trade_type = @"APP";
    
    //商户密钥
    partner = kWXPAY_PARTNER_ID;

    //获取sign签名 2E3238067FC3F9D27318F76FAA32D56A
    DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid mch_id:mch_id nonce_str:nonce_str partner_id:partner body:body out_trade_no:out_trade_no total_fee:total_fee spbill_create_ip:spbill_create_ip notify_url:notify_url trade_type:trade_type];
    sign = [data getSignForMD5];
    
    //设置参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:appid forKey:@"appid"];//公众账号ID
    [dic setValue:mch_id forKey:@"mch_id"];//商户号
    [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
    [dic setValue:sign forKey:@"sign"];//签名
    [dic setValue:body forKey:@"body"];//商品描述
    [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
    [dic setValue:total_fee forKey:@"total_fee"];//金额
    [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
    [dic setValue:notify_url forKey:@"notify_url"];//通知地址
    [dic setValue:trade_type forKey:@"trade_type"];//交易类型

    //    NSString *string = [dic XMLString];
    NSLog(@"dic=%@",dic);
    [LVWxPay http:dic];
}

+ (BOOL)wxPayWithPayModel:(MEPayModel *)model VC:(UIViewController *)vc price:(NSString *)price{
    if (![WXApi isWXAppInstalled]) {//检查用户是否安装微信
        if([kCurrentUser.mobile isEqualToString:AppstorePhone]){
            if(vc){
                BankTransferAccountsVC *dvc = [[BankTransferAccountsVC alloc]initWithstrMoney:kMeUnNilStr(price)];
                [vc.navigationController pushViewController:dvc animated:YES];
                return YES;
            }
        }
        //...处理
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未安装微信客户端，请先安装微信支付" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //什么都不做
        }]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
        return true;
    }
    
    //发起微信支付，设置参数
    PayReq *request = [[PayReq alloc] init];
    
    //商户号
    request.partnerId = kMeUnNilStr(model.partnerid);
    
    //随机字符串，这个随机字符串可要注意了，是第一次生成的随机字符串,不要再次生成了
    request.nonceStr= kMeUnNilStr(model.noncestr);
    
    //预支付id
    request.prepayId= kMeUnNilStr(model.prepayid);
    
    //扩展字段
    request.package = kMeUnNilStr(model.packageField);
    
    //将当前事件转化成时间戳
//    NSDate *datenow = [NSDate date];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    UInt32 timeStamp =[timeSp intValue];
    request.timeStamp= model.timestamp;
    //
//    DataMD5 *md5 = [[DataMD5 alloc] init];
//    request.sign = [md5 createMD5SingForPay:UMWXAppId partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
//    NSLog(@"request=%@",request);
    request.sign = model.sign;
    //调用微信
    return [WXApi sendReq:request];
}

//解XML
//+ (void)http:(NSString *)xml
+(void)http:(NSMutableDictionary *)paramsDic
{
    NSString *xml = [paramsDic XMLString];
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   // AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setValue:kWXPAY_SP_URL forHTTPHeaderField:@"SOAPAction"];
    
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xml;
    }];
    
  [manager POST:kWXPAY_SP_URL parameters:xml progress:^(NSProgress * _Nonnull uploadProgress) {
      
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xml progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
      
      //将微信返回的xml数据解析转义成字典
      NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
      NSLog(@"微信返回的数据:%@",dic);
      //判断返回的许可
      if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
          
          //发起微信支付，设置参数
          PayReq *request = [[PayReq alloc] init];
          
          //商户号
          request.partnerId = kWXPAY_MCH_ID;
          
          //随机字符串，这个随机字符串可要注意了，是第一次生成的随机字符串,不要再次生成了
          request.nonceStr= [paramsDic objectForKey:@"nonce_str"];
          
          //预支付id
          request.prepayId= [dic objectForKey:@"prepay_id"];
          
          //扩展字段
          request.package = @"Sign=WXPay";
          
          //将当前事件转化成时间戳
          NSDate *datenow = [NSDate date];
          NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
          UInt32 timeStamp =[timeSp intValue];
          
          request.timeStamp= timeStamp;
          //
          DataMD5 *md5 = [[DataMD5 alloc] init];
          request.sign = [md5 createMD5SingForPay:UMWXAppId partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
          NSLog(@"request=%@",request);
          //调用微信
          BOOL isS =  [WXApi sendReq:request];
          NSLog(@"调起微信 == %d",isS);
          //            SendAuthReq * sendReq = [[SendAuthReq alloc]init];
          //            sendReq.scope =
          //            [WXApi sendAuthReq:<#(SendAuthReq *)#> viewController:<#(UIViewController *)#> delegate:<#(id<WXApiDelegate>)#>]
      }else{
          NSLog(@"参数不正确，请检查参数");
      }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"error=%@",error);
  }];
 
   
}
//md5加密
+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
//产生随机字符串
+ (NSString *)generateTradeNO
{
    static NSInteger kNumbers = 32;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (NSInteger i = 0; i < kNumbers; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
