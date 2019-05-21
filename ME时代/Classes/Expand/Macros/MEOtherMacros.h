//
//  MEOtherMacros.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#ifndef MEOtherMacros_h
#define MEOtherMacros_h

#pragma mark - 第三方macros

#define  AppstorePhone @"18823365313"

//腾讯云IM
#define sdkAppid          1400180178
#define sdkAccountType    @"36862"

//友盟统计
#define  MobAppkey @"5b8f50fb8f4a9d76a70000b3"

//注册友盟分享微信//微信支付
#define  UMWXAppId @"wxf4247352608aec94"
#define  UMWXAppSecret @"3176b0da6bc0df175019308533e7ef44"

//百度
#define BAIDUAK @"jCMREiwKtZatsn4f19dSgKlndCFv2aDx"

////融云
//#ifdef TestVersion
//    #define RONGYUNAppKey @"m7ua80gbmjsam"
//    #define RONGYUNAppSecret @"BvxNWAGdqX"
//////客服id
////#define RONGYUNCUSTOMID @"KEFU153828643047594"
//#else
//    #define RONGYUNAppKey @"k51hidwqkc3hb"
//    #define RONGYUNAppSecret @"u2ofE9LnYNd"
////#define RONGYUNCUSTOMID @""
//#endif


// 0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用
#ifdef TestVersion
#define JpushType 0
#else
#define JpushType 1
#endif

//极光
#define JpushAppKey @"ea6dae8f5bf6015308432a99"
#define JpushMasterSecret @"5028fa44645cd9dd1f691b2c"


#endif /* MEOtherMacros_h */
