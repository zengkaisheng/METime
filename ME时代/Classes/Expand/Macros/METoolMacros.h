//
//  METoolMacros.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#ifndef METoolMacros_h
#define METoolMacros_h




#define PAYVC @"PAYVC"
#define PAYPRE \
NSUserDefaults *user = [NSUserDefaults standardUserDefaults];\
[user setObject:NSStringFromClass([strongSelf class]) forKey:PAYVC];\
[[NSUserDefaults standardUserDefaults] synchronize];\

//判断支付是不是同一个vc
#define PAYJUDGE \
NSUserDefaults *vc = [NSUserDefaults standardUserDefaults];\
NSString *vcName = [vc objectForKey:PAYVC];\
if(![vcName isEqualToString:NSStringFromClass([self class])]){\
return;\
}\


#define MEWebVIewImgAutoFit NSString *js = @"function imgAutoFit() { \
var imgs = document.getElementsByTagName('img'); \
for (var i = 0; i < imgs.length; ++i) {\
var img = imgs[i];   \
img.style.maxWidth = %f;   \
} \}";js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width-20];[webView stringByEvaluatingJavaScriptFromString:js];[webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];


#define MEModelIdToIdField +(NSDictionary *)mj_replacedKeyFromPropertyName{return @{@"idField" : @"id"};}
#define MEModelObjectClassInArrayWithDic(dic) +(NSDictionary *)mj_objectClassInArray{return (dic);}


#define kImgPlaceholder  [UIImage imageNamed:@"icon-ihhkwultu"]
#define kImgBannerPlaceholder  [UIImage imageNamed:@"icon-hkwultu"]


#define kApiError @"网络错误,接口异常"

#define kMEAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//app版本
#define kMEAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define kMEAppId @"1438596690"



// RGB颜色
#define kMeColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/** 弱强应用 */
#define kMeWEAKSELF typeof(self) __weak weakSelf = self;
#define kMeSTRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

/** 设备相关 */
NS_INLINE CGFloat device_version(){
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

//系统版本
//是否ios7以上系统
#define kIsIOS7 (device_version() >=7.0)
//是否ios8以上系统
#define kIsIOS8 (device_version() >=8.0)
//是否ios9以上系统
#define kIsIOS9 (device_version() >=9.0)
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)



#define  kMeStatusBarHeight      ((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 44.f : 20.f)
#define  kMeNavigationBarHeight  44.f
#define  kMeTabBarHeight        ((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? (49.f+34.f) : 49.f)
#define  kMeTabbarSafeBottomMargin        ((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 34.f : 0.f)
#define  kMeNavBarHeight  ((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 88.f : 64.f)


/** 屏幕宽 */
#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
#define kMeApplicationHeight (kIsIOS7?CGRectGetHeight([UIScreen mainScreen].bounds):CGRectGetHeight([[UIScreen mainScreen] applicationFrame]))
/** 一些缩写 */
#define kMeAppDelegateInstance [[UIApplication sharedApplication] delegate]
#define kMeApplication        [UIApplication sharedApplication]
#define kMeKeyWindow          [UIApplication sharedApplication].keyWindow
#define kMeUserDefaults       [NSUserDefaults standardUserDefaults]
#define kMeNotificationCenter [NSNotificationCenter defaultCenter]
#define kMeFont(num) [UIFont systemFontOfSize:num]
#define kAlterBtnTitle(title,msg,btnTitle) [[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil, nil] show]
#define kMeAlter(title,msg)  kAlterBtnTitle(title,msg,@"关闭")
#define kMeGetAssetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define kMeCurrentWindow [[UIApplication sharedApplication].windows firstObject]
#define kSDLoadImg(class,url) [class sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImgPlaceholder]

/** 定义block */
typedef void (^kMeBasicBlock)(void);
typedef void (^kMeBOOLBlock)(BOOL);
typedef void (^kMeIndexBlock)(NSInteger index);
typedef void (^kMeTextBlock)(NSString *str);
typedef void (^kMeObjBlock)(id object);
typedef void (^kMeFloatBlock)(CGFloat num);
typedef bool (^kMeReturnBlock)(void);
typedef void (^kMeDictionaryBlock)(NSDictionary *dic);
typedef void (^kMeArrBlock)(NSArray *);
typedef void (^kMeMutableArrBlock)(NSMutableArray *arr);
typedef void (^kMeViewBlock)(UIView *view);
typedef void (^kMeBtnBlock)(UIButton *btn);
typedef void (^kMeLblBlock)(UILabel *lable);
typedef void (^kMeDataBlock)(NSData *data);
typedef void (^kMeImgBlock)(UIImage *img);
typedef id (^ReturnObjectWithOtherObjectBlock)(id);
typedef void (^kMeIndexPathBlock)(NSIndexPath * indexpath);

typedef UIImage *(^ReturnImgWithImgBlock)(UIImage *);
#define kMeCallBlock(block, ...) if(block) block(__VA_ARGS__)
#define kCategoryViewHeight (44)
/** 屏幕比例 */
NS_INLINE CGFloat kMeFrameScaleX(){
    static CGFloat frameScaleX = 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        frameScaleX = SCREEN_WIDTH/375.0;
    });
    return frameScaleX;
}

NS_INLINE CGFloat kMeFrameScaleY(){
    static CGFloat frameScaleY = 1.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        frameScaleY = SCREEN_HEIGHT/667.0;
    });
    return frameScaleY;
}

#define kMeFitX(num)                 (kMeFrameScaleX() * (num))
#define kMeFitY(num)                 (kMeFrameScaleY() * (num))

/** 校验 */
//非空的NSNumber
#define kMeUnNilNumber(number) ([number isKindOfClass:[NSNumber class]]?number:@(0))
//字符串是否为空
#define kMeUnNilStr(str) ((str && ![str isEqual:[NSNull null]] && ![str isEqualToString:@"null"])?str:@"")
//判断字符串是否为空
#define kMeUnStrIsEmpty(str) ((str.length > 0 && ![str isKindOfClass:[NSNull class]]))
//非空的字符串 输出空格
#define kMeUnNilStrSpace(str) ((str && ![str isEqual:[NSNull null]] && ![str isEqualToString:@"(null)"])?str:@" ")
//整数转换成字符串
#define kMeStrWithInter(i) [NSString stringWithFormat:@"%@",@(i)]
//CGFloat转换成字符串
#define kMeStrWithFloat(f) [NSString stringWithFormat:@"%0.1f",f]
//数组是否为空
#define kMeUnArr(arr) ((arr && ![arr isEqual:[NSNull null]])?arr:nil)
//字典是否为空
#define kMeUnDic(dic) ((dic && ![dic isEqual:[NSNull null]])?dic:@{})
//是否是空对象
#define kMeUnObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
//验证字典有没有某个key 并且判断值的类型
#define kMeValidateDicWithKey(dic,key) ([dic objectForKey:key] && [dic objectForKey:key] != [NSNull null])
#define kMeValidateDicWithKey_Dic(dic,key) ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSDictionary class]])
#define kMeValidateDicWithKey_Arr(dic,key) ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSArray class]])
#define kMeValidateDicWithKey_Str(dic,key) ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSString class]])

#define MeMustImplementedDataInitMethod() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"不能用init初始化"] \
userInfo:nil]

#define  MeMustImplementedDataInit() - (instancetype)init{ \
MeMustImplementedDataInitMethod(); \
}


#define kMeMsgLocation [NSString stringWithFormat:@"请在系统设置开启定位服务\n(设置 > 隐私 > 定位服务 > 开启%@)",kMeUnNilStr(kMEAppName)]


/** 路径 */
//缓存路径-cach目录
NS_INLINE NSString *kMeFilePathAtCachWithName(NSString *fileNAme){
    static NSString *cachFilePath = nil;
    if (!cachFilePath) {
        cachFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    }
    return [cachFilePath stringByAppendingPathComponent:fileNAme];
}

//缓存路径-document目录
NS_INLINE NSString *kMeFilePathAtDocumentWithName(NSString *fileNAme){
    static NSString *documentFilePath = nil;
    if (!documentFilePath) {
        documentFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return [documentFilePath stringByAppendingPathComponent:fileNAme];
}

/** NSLog */
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif


//load qiniu image
#define MELoadQiniuImagesWithUrl(Url) [NSString stringWithFormat:@"http://images.meshidai.com/%@",Url]


#pragma mark -

//通知用户刷新购物车 NSNotificationCenter
#define kShopCart @"kShopCart"
#define kNoticeReloadShopCart [[NSNotificationCenter defaultCenter] postNotificationName:kShopCart object:nil];
#define kShopCartReload   [[NSNotificationCenter defaultCenter]addObserver:self.refresh selector:@selector(reload) name:kShopCart object:nil];

#define kNSNotificationCenterDealloc [[NSNotificationCenter defaultCenter] removeObserver:self];


//通知用户刷新订单
#define kAppoint @"kAppoint"
#define kNoticeReloadAppoint [[NSNotificationCenter defaultCenter] postNotificationName:kAppoint object:nil];
#define kAppointReload   [[NSNotificationCenter defaultCenter]addObserver:self.refresh selector:@selector(reload) name:kAppoint object:nil];


//通知用户刷新订单
#define kOrder @"kOrder"
#define kNoticeReloadOrder [[NSNotificationCenter defaultCenter] postNotificationName:kOrder object:nil];
#define kOrderReload   [[NSNotificationCenter defaultCenter]addObserver:self.refresh selector:@selector(reload) name:kOrder object:nil];

//通知刷新自提订单
#define kSelfExtractOrder @"kSelfExtractOrder"
#define kNoticeReloadSelfExtractOrder [[NSNotificationCenter defaultCenter] postNotificationName:kSelfExtractOrder object:nil];
#define kSelfExtractOrderReload   [[NSNotificationCenter defaultCenter]addObserver:self.refresh selector:@selector(reload) name:kSelfExtractOrder object:nil];


//通知用户刷新融云信息
#define kUnMessage @"kUnMessage"
#define kNoticeReloadkUnMessage [[NSNotificationCenter defaultCenter] postNotificationName:kUnMessage object:nil];
//#define kkUnMessageReload   [[NSNotificationCenter defaultCenter]addObserver:self.refresh selector:@selector(reload) name:kShopCart object:nil];
//通知用户刷新未读信息
#define kUnNoticeMessage @"kUnNoticeMessage"
#define kNoticeUnNoticeMessage [[NSNotificationCenter defaultCenter] postNotificationName:kUnNoticeMessage object:nil];

//判断是否完成首单Key
#define kcheckFirstBuy  @"checkFirstBuy"

//自提订单搜索历史记录
#define kMESelfExtraceSearchVCSearchHistoriesCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"kMESelfExtraceSearchVC.plist"]

//客户搜索历史记录
#define kMEMEAICustomerSearchVCHistoriesCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MEAICustomerSearchVC.plist"]

//优惠卷搜索历史记录
#define kMECouponSearchVCSearchHistoriesCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MECouponSearchVC.plist"]
//文章搜索历史记录
#define kMEArticelVCSearchHistoriesCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MEArticelVC.plist"]
//会员搜索历史记录
#define kMEClerkSearchVCSearchHistoriesCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MEClerkSearchVC.plist"]
#endif /* METoolMacros_h */
