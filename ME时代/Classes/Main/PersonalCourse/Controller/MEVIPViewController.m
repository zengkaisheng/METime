//
//  MEVIPViewController.m
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEVIPViewController.h"
#import "MEOpenVIPView.h"
#import "MECourseVIPModel.h"

#import "MEPayStatusVC.h"
#import "MEMyVIPVC.h"
#import "MEPersionalCourseDetailVC.h"

#import "TDWebViewCell.h"
#import "MEMyCourseVIPModel.h"
#import "MECourseDetailVC.h"
#import "MEApplePayModel.h"

#import <StoreKit/StoreKit.h>

//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

#define courseProductNumber1 @"MEShiDaiCourse100001"

@interface MEVIPViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    NSString *_order_sn;
    NSString *_order_amount;
    BOOL _isPayError;//防止跳2次错误页面
}

@property (nonatomic, strong) MEOpenVIPView *vipView;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) MECourseVIPModel *model;

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) TDWebViewCell *webCell;

@property (nonatomic, strong) MEMyCourseVIPDetailModel *vipModel;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation MEVIPViewController

- (void)dealloc{
    kNSNotificationCenterDealloc
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通VIP";
    if (self.vipModel.is_vip == 1) {
        self.title = @"续费VIP";
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.vipView];
    
//    [self requestVIPDetailWithNetWork];
    [self reloadUI];
    kMeWEAKSELF
    self.vipView.finishBlock = ^{
        kMeSTRONGSELF
        NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
        if ([status isEqualToString:@"customer"]) {//C端
            strongSelf.hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
            //bundleid+xxx 就是你添加内购条目设置的产品ID
            if([SKPaymentQueue canMakePayments]){
                //是否允许内购
                [strongSelf requestProductData:courseProductNumber1];
            }else{
                [strongSelf.hud hideAnimated:YES];
                NSLog(@"不允许程序内付费");
            }
        }else if ([status isEqualToString:@"business"]) {
            [strongSelf createVIPOrder];
        }
    };
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WechatSuccess:) name:WX_PAY_RESULT object:nil];
}

- (instancetype)initWithVIPModel:(MEMyCourseVIPDetailModel *)model {
    if (self = [super init]) {
        self.vipModel = model;
    }
    return self;
}

- (void)reloadUI {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 146;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(self.vipModel.vip_rule)] baseURL:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        self.tableView.hidden = YES;
        
        self.vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEOpenVIPView getViewHeightWithRuleHeight:height]);
        self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, [MEOpenVIPView getViewHeightWithRuleHeight:height]);
//        [self.vipView setUIWithModel:self.model];
        [self.vipView setUIWithVIPModel:self.vipModel];
    });
}
#pragma mark 内购相关
//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}
#pragma mark - SKProductsRequestDelegate
//接收到产品的返回信息，然后用返回的商品信息进行发起购买请求
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        //如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
        if([pro.productIdentifier isEqualToString:courseProductNumber1]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),
                          @"id":[NSString stringWithFormat:@"%ld",self.vipModel.idField],
                          @"order_type":@"4"
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonCoursesCreateVIPOrder);
    kMeWEAKSELF
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_order_sn = responseObject.data[@"order_sn"];
        strongSelf->_order_amount = responseObject.data[@"order_amount"];
    } failure:^(id error) {
        
    }];
}
#pragma mark - SKRequestDelegate
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
    if (self.hud) {
        [self.hud hideAnimated:YES];
    }
    [MECommonTool showMessage:@"无法连接到 iTunes Store" view:kMeCurrentWindow];
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
    [self.hud hideAnimated:YES];
}

#pragma mark - SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            default:
                break;
        }
    }
}

//交易结束,当交易结束后还要去appstore上验证支付信息是否都正确,只有所有都正确后,我们就可以给用户方法我们的虚拟物品了。
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    //交易验证
    /*
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    //发送POST请求，对购买凭据进行验证
    //测试验证地址：https://sandbox.itunes.apple.com/verifyReceipt
    //正式验证地址：https://buy.itunes.apple.com/verifyReceipt
    NSURL *url = [NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    urlRequest.HTTPMethod = @"POST";
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    _receipt = encodeStr;
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = payloadData;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    
    if (result == nil) {
        NSLog(@"验证失败");
        return;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"请求成功后的数据:%@",dic);
     */
    //这里可以通过判断 state == 0 验证凭据成功，然后进入自己服务器二次验证，,也可以直接进行服务器逻辑的判断。
    //本地服务器验证成功之后别忘了 [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self verifyPurchaseWithPaymentTransaction];
    
    NSString *productId = transaction.payment.productIdentifier;
    NSString *applicationUsername = transaction.payment.applicationUsername;
    
    NSLog(@"applicationUsername++++%@",applicationUsername);
    NSLog(@"payment.productIdentifier++++%@",productId);
    
//    if (dic != nil) {
//        userId = applicationUsername;
        //服务器二次验证
//        [self vertifyApplePayRequestWith:transaction];
//    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    //创建请求到苹果官方进行购买验证
    NSURL *url = [NSURL URLWithString:AppStore];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod = @"POST";
    //创建连接并发送同步请求
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"dic~~~~~~:%@",dic);
    if([dic[@"status"] intValue] == 0){
        NSLog(@"购买成功！");
        NSDictionary *dicReceipt = dic[@"receipt"];
        NSDictionary *dicInApp = [dicReceipt[@"in_app"] lastObject];
        MEApplePayModel *payModel = [MEApplePayModel mj_objectWithKeyValues:dicInApp];
        payModel.order_price_true = @"388";
        payModel.order_sn = kMeUnNilStr(_order_sn);
        payModel.token = kMeUnNilStr(kCurrentUser.token);
        NSString *productIdentifier = dicInApp[@"product_id"];//读取产品标识
//        [MECommonTool showMessage:@"购买个人课程年卡成功" view:kMeCurrentWindow];
        
        if ([productIdentifier isEqualToString:courseProductNumber1]) {
//            购买VIP年卡
            kMeWEAKSELF
            NSDictionary *dic = [payModel mj_keyValues];
//  @{@"order_sn":kMeUnNilStr(_order_sn),@"token":kMeUnNilStr(kCurrentUser.token)};
            NSString *url = kGetApiWithUrl(MEIPcommonOnlineApplePayNotify);
            [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
                    
                    if (strongSelf.vipModel.vip_type == 1) {
                        MEPersionalCourseDetailVC *vc = (MEPersionalCourseDetailVC *)[MECommonTool getClassWtihClassName:[MEPersionalCourseDetailVC class] targetVC:strongSelf];
                        [vc reloadDatas];
                        if(vc){
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }else{
                            kMeCallBlock(strongSelf.finishBlock);
                            NSArray *vcs = strongSelf.navigationController.viewControllers;
                            UIViewController *vc = [vcs objectAtIndex:vcs.count-3];
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }else if (strongSelf.vipModel.vip_type == 2) {
                        MECourseDetailVC *vc = (MECourseDetailVC *)[MECommonTool getClassWtihClassName:[MECourseDetailVC class] targetVC:strongSelf];
                        [vc reloadData];
                        if(vc){
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }else{
                            kMeCallBlock(strongSelf.finishBlock);
                            NSArray *vcs = strongSelf.navigationController.viewControllers;
                            UIViewController *vc = [vcs objectAtIndex:vcs.count-3];
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }];
                [strongSelf.navigationController pushViewController:svc animated:YES];
            } failure:^(id error) {
                NSLog(@"error:%@",error);
            }];
        }
    }else if([dic[@"status"] intValue] == 21007){
        [self verifyPurchaseWithPaymentTransactionSANDBOX];
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}

-(void)verifyPurchaseWithPaymentTransactionSANDBOX{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod = @"POST";
    //创建连接并发送同步请求
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if([dic[@"status"] intValue] == 0){
        NSDictionary *dicReceipt = dic[@"receipt"];
        NSDictionary *dicInApp = [dicReceipt[@"in_app"] lastObject];
        MEApplePayModel *payModel = [MEApplePayModel mj_objectWithKeyValues:dicInApp];
        payModel.order_price_true = @"388";
        payModel.order_sn = kMeUnNilStr(_order_sn);
        payModel.token = kMeUnNilStr(kCurrentUser.token);
        
        NSString *productIdentifier = dicInApp[@"product_id"];//读取产品标识
//        [MECommonTool showMessage:@"购买个人课程年卡成功" view:kMeCurrentWindow];
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
        
        if ([productIdentifier isEqualToString:courseProductNumber1]) {
//            购买VIP年卡
            kMeWEAKSELF
            NSDictionary *dic = [payModel mj_keyValues];
//  @{@"order_sn":kMeUnNilStr(_order_sn),@"token":kMeUnNilStr(kCurrentUser.token)};
            NSString *url = kGetApiWithUrl(MEIPcommonOnlineApplePayNotify);
            [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
                 kMeSTRONGSELF
                MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
                   
                    if (strongSelf.vipModel.vip_type == 1) {
                        MEPersionalCourseDetailVC *vc = (MEPersionalCourseDetailVC *)[MECommonTool getClassWtihClassName:[MEPersionalCourseDetailVC class] targetVC:strongSelf];
                        [vc reloadDatas];
                        if(vc){
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }else{
                            kMeCallBlock(strongSelf.finishBlock);
                            NSArray *vcs = strongSelf.navigationController.viewControllers;
                            UIViewController *vc = [vcs objectAtIndex:vcs.count-3];
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }else if (strongSelf.vipModel.vip_type == 2) {
                        MECourseDetailVC *vc = (MECourseDetailVC *)[MECommonTool getClassWtihClassName:[MECourseDetailVC class] targetVC:strongSelf];
                        [vc reloadData];
                        if(vc){
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }else{
                            kMeCallBlock(strongSelf.finishBlock);
                            NSArray *vcs = strongSelf.navigationController.viewControllers;
                            UIViewController *vc = [vcs objectAtIndex:vcs.count-3];
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }];
                [strongSelf.navigationController pushViewController:svc animated:YES];
            } failure:^(id error) {
                NSLog(@"error:%@",error);
            }];
        }
    }else if([dic[@"status"] intValue] == 21007){
        
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}

#pragma mark -- Networking
//VIP会员课程套餐
- (void)requestVIPDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCourseVIPDetailWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MECourseVIPModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//支付VIP
- (void)createVIPOrder {
    kMeWEAKSELF
    NSString *type = @"4";
    if (self.vipModel.vip_type == 2) {
        type = @"5";
    }
    [MEPublicNetWorkTool postCreateVIPOrderWithCourseId:[NSString stringWithFormat:@"%ld",self.vipModel.idField] orderType:type successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_order_sn = responseObject.data[@"order_sn"];
        strongSelf->_order_amount = responseObject.data[@"order_amount"];
        [MEPublicNetWorkTool postPayOnlineOrderWithOrderSn:strongSelf->_order_sn successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            PAYPRE
            strongSelf->_isPayError = NO;
            MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
            
            BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_order_amount];
            if(!isSucess){
                [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
            }
        } failure:^(id object) {
            
        }];
    } failure:^(id object) {
        
    }];
}
#pragma mark - Pay
- (void)WechatSuccess:(NSNotification *)noti{
    [self payResultWithNoti:[noti object] result:WXPAY_SUCCESSED];
}

- (void)payResultWithNoti:(NSString *)noti result:(NSString *)result{
    PAYJUDGE
    kMeWEAKSELF
    if ([noti isEqualToString:result]) {
        if(_isPayError){
            [self.navigationController popViewControllerAnimated:NO];
        }
        MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
            kMeSTRONGSELF
            if (strongSelf.vipModel.vip_type == 1) {
                MEPersionalCourseDetailVC *vc = (MEPersionalCourseDetailVC *)[MECommonTool getClassWtihClassName:[MEPersionalCourseDetailVC class] targetVC:strongSelf];
                [vc reloadDatas];
                if(vc){
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }else{
                    kMeCallBlock(strongSelf.finishBlock);
                    [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                }
            }else if (strongSelf.vipModel.vip_type == 2) {
                MECourseDetailVC *vc = (MECourseDetailVC *)[MECommonTool getClassWtihClassName:[MECourseDetailVC class] targetVC:strongSelf];
                [vc reloadData];
                if(vc){
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }else{
                    kMeCallBlock(strongSelf.finishBlock);
                    [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                }
            }
        }];
        [self.navigationController pushViewController:svc animated:YES];
        NSLog(@"支付成功");
        _isPayError = NO;
    }else{
        if(!_isPayError){
            kMeWEAKSELF
            MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithFailRePayBlock:^{
                kMeSTRONGSELF
                [MEPublicNetWorkTool postPayOnlineOrderWithOrderSn:strongSelf->_order_sn successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                    
                    BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_order_amount];
                    if(!isSucess){
                        [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                    }
                } failure:^(id object) {
                    
                }];
            } CheckOrderBlock:^{
                kMeSTRONGSELF
                MEMyVIPVC *vc = [[MEMyVIPVC alloc]init];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }];
            [self.navigationController pushViewController:svc animated:YES];
        }
        NSLog(@"支付失败");
        _isPayError = YES;
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.webCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_webCell){
        return 0;
    }
    return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
}

#pragma mark -- setter&&getter
- (UIScrollView *)scrollerView{
    if(!_scrollerView){
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
        _scrollerView.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, [MEOpenVIPView getViewHeightWithRuleHeight:0]);
        _scrollerView.bounces = YES;
        _scrollerView.showsVerticalScrollIndicator =NO;
        _scrollerView.delegate = self;
        _scrollerView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollerView;
}

- (MEOpenVIPView *)vipView {
    if (!_vipView) {
        _vipView = [[[NSBundle mainBundle]loadNibNamed:@"MEOpenVIPView" owner:nil options:nil] lastObject];
        _vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEOpenVIPView getViewHeightWithRuleHeight:0]);
    }
    return _vipView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(73, 0, SCREEN_WIDTH-146, 100) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

@end
