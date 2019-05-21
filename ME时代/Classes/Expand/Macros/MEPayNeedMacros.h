//
//  MEPayNeedMacros.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#ifndef MEPayNeedMacros_h
#define MEPayNeedMacros_h

/**************************** 微信支付 *****************************/
//通知的名字及参数
#define WX_PAY_RESULT          @"weixin_pay_result"
#define WXPAY_SUCCESSED        @"wechat_pay_isSuccessed"
#define WXPAY_FAILED           @"wechat_pay_isFailed"



//商户号，填写商户对应参数（客户给）
#define kWXPAY_MCH_ID          @"1514588311"
//商户API密钥，填写相应参数（客户给）
#define kWXPAY_PARTNER_ID      @"XzIPLSYFLSFdTBRxXFaGnaQXdRquLt0E"
//支付结果回调页面（后台会给你）



#ifdef TestVersion
//测试服务器的接口
#define kWXPAY_NOTIFY_URL       @""
#else
//总的接口前半部分API
#define kWXPAY_NOTIFY_URL      @""
#endif

//获取服务器端支付数据地址（商户自定义）
#define kWXPAY_SP_URL          @"https://api.mch.weixin.qq.com/pay/unifiedorder"

#endif /* MEPayNeedMacros_h */
