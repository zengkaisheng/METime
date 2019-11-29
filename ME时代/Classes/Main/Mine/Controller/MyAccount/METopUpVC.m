//
//  METopUpVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "METopUpVC.h"

#import "MEApplePayModel.h"
#import "METopUpSuccessVC.h"
#import <StoreKit/StoreKit.h>

#define courseTopUpNumber1 @"MEShiDaiCourse110001"
#define courseTopUpNumber2 @"MEShiDaiCourse110002"
#define courseTopUpNumber3 @"MEShiDaiCourse110003"
#define courseTopUpNumber4 @"MEShiDaiCourse110004"
#define courseTopUpNumber5 @"MEShiDaiCourse110005"
#define courseTopUpNumber6 @"MEShiDaiCourse110006"


@interface METopUpVC ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    NSString *_order_sn;
    NSString *_order_amount;
    BOOL _isPayError;//防止跳2次错误页面
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTop;
@property (weak, nonatomic) IBOutlet UIView *topUpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomimageVConsTop;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) BOOL isFinish;

@end

@implementation METopUpVC

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"充值";
    _order_amount = @"";
    self.isFinish = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _consTop.constant = kMeNavBarHeight+50;
    if (IS_IPHONE_4S || IS_iPhone5S) {
        _bottomimageVConsTop.constant = 40;
    }else {
        _bottomimageVConsTop.constant = 79;
    }
    
    CGFloat spec = 20;
    CGFloat itemW = (SCREEN_WIDTH-37*2-spec*2)/3;
    NSArray *btns = @[@"12元\n售价:12:00元",@"30元\n售价:30:00元",@"50元\n售价:50:00元",@"108元\n售价:108:00元",@"148元\n售价:148:00元",@"198元\n售价:198:00元",];
    
    for (int i = 0; i < btns.count; i++) {
        UIButton *btn = [self createButtomWithTitle:btns[i] frame:CGRectMake((itemW+spec)*(i%3), 3+(41+23)*(i/3), itemW, 41) tag:100+i];
        [_topUpView addSubview:btn];
    }
}

- (void)TopUpChooseAction:(UIButton *)sender {
    if (!self.isFinish) {
        [MECommonTool showMessage:@"充值还未结束，请稍后" view:kMeCurrentWindow];
        return;
    }
    UIButton *btn = (UIButton *)sender;
    for (UIButton *btn in _topUpView.subviews) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor whiteColor];
    }
    sender.selected = YES;
    sender.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
    
    switch (btn.tag-100) {
        case 0:
            _order_amount = @"12";
            break;
        case 1:
            _order_amount = @"30";
            break;
        case 2:
            _order_amount = @"50";
            break;
        case 3:
            _order_amount = @"108";
            break;
        case 4:
            _order_amount = @"148";
            break;
        case 5:
            _order_amount = @"198";
            break;
        default:
            break;
    }
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
        if([pro.productIdentifier isEqualToString:courseTopUpNumber1] || [pro.productIdentifier isEqualToString:courseTopUpNumber2] || [pro.productIdentifier isEqualToString:courseTopUpNumber3] || [pro.productIdentifier isEqualToString:courseTopUpNumber4] || [pro.productIdentifier isEqualToString:courseTopUpNumber5] || [pro.productIdentifier isEqualToString:courseTopUpNumber6] ){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),
                          @"order_amount":kMeUnNilStr(_order_amount)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonMoneyMemberRecharge);
    kMeWEAKSELF
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSNumber *longNumber = [NSNumber numberWithLong:[responseObject.data[@"order_sn"] longValue]];
        strongSelf->_order_sn = [longNumber stringValue];
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
    self.isFinish = YES;
    [MECommonTool showMessage:@"无法连接到 iTunes Store" view:kMeCurrentWindow];
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
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
                [self.hud hideAnimated:YES];
                self.isFinish = YES;
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
//    self.hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    //交易验证
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
        payModel.order_sn = [NSString stringWithFormat:@"%@",kMeUnNilStr(_order_sn)];
        payModel.token = kMeUnNilStr(kCurrentUser.token);
        NSString *productIdentifier = dicInApp[@"product_id"];//读取产品标识
        
//        if ([productIdentifier isEqualToString:courseTopUpNumber1] ||
//            [productIdentifier isEqualToString:courseTopUpNumber2] ||
//            [productIdentifier isEqualToString:courseTopUpNumber3] ||
//            [productIdentifier isEqualToString:courseTopUpNumber4] ||
//            [productIdentifier isEqualToString:courseTopUpNumber5] ||
//            [productIdentifier isEqualToString:courseTopUpNumber6]) {
        
            payModel.order_price_true = _order_amount;
        
            kMeWEAKSELF
//            NSDictionary *dic = [payModel mj_keyValues];
            NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),
                                  @"total_fee":kMeUnNilStr(_order_amount),
                                  @"out_trade_no":[NSString stringWithFormat:@"%@1111",kMeUnNilStr(_order_sn)],
                                  @"transaction_id":kMeUnNilStr(payModel.transaction_id)
                                  };

            NSString *url = kGetApiWithUrl(MEIPcommonMoneyAppleSuccess);
            [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                strongSelf.isFinish = YES;
                [strongSelf.hud hideAnimated:YES];
                METopUpSuccessVC *svc = [[METopUpSuccessVC alloc] initWithMoney:kMeUnNilStr(strongSelf->_order_amount) sucessConfireBlock:^{
                    kMeCallBlock(strongSelf.finishBlock);
                    NSArray *vcs = strongSelf.navigationController.viewControllers;
                    UIViewController *vc = [vcs objectAtIndex:vcs.count-3];
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }];
                [strongSelf.navigationController pushViewController:svc animated:YES];
            } failure:^(id error) {
                NSLog(@"error:%@",error);
            }];
//        }
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
    NSLog(@"dic===%@",dic);
    if([dic[@"status"] intValue] == 0){
        NSDictionary *dicReceipt = dic[@"receipt"];
        NSDictionary *dicInApp = [dicReceipt[@"in_app"] lastObject];
        MEApplePayModel *payModel = [MEApplePayModel mj_objectWithKeyValues:dicInApp];
        payModel.order_sn = [NSString stringWithFormat:@"%@",kMeUnNilStr(_order_sn)];
        payModel.token = kMeUnNilStr(kCurrentUser.token);
        
        NSString *productIdentifier = dicInApp[@"product_id"];//读取产品标识
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
//        if ([productIdentifier isEqualToString:courseTopUpNumber1] ||
//            [productIdentifier isEqualToString:courseTopUpNumber2] ||
//            [productIdentifier isEqualToString:courseTopUpNumber3] ||
//            [productIdentifier isEqualToString:courseTopUpNumber4] ||
//            [productIdentifier isEqualToString:courseTopUpNumber5] ||
//            [productIdentifier isEqualToString:courseTopUpNumber6]) {
        
            payModel.order_price_true = _order_amount;
            
            kMeWEAKSELF
//            NSDictionary *dic = [payModel mj_keyValues];
            
            NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),
                                  @"total_fee":kMeUnNilStr(_order_amount),
                                  @"out_trade_no":[NSString stringWithFormat:@"%@1111",kMeUnNilStr(_order_sn)],
                                  @"transaction_id":kMeUnNilStr(payModel.transaction_id)
                                  };
            
            NSString *url = kGetApiWithUrl(MEIPcommonMoneyAppleSuccess);
        
            [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                strongSelf.isFinish = YES;
                [strongSelf.hud hideAnimated:YES];
                METopUpSuccessVC *svc = [[METopUpSuccessVC alloc] initWithMoney:kMeUnNilStr(strongSelf->_order_amount) sucessConfireBlock:^{
                    kMeCallBlock(strongSelf.finishBlock);
                    NSArray *vcs = strongSelf.navigationController.viewControllers;
                    UIViewController *vc = [vcs objectAtIndex:vcs.count-3];
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }];
                [strongSelf.navigationController pushViewController:svc animated:YES];
            } failure:^(id error) {
                NSLog(@"error:%@",error);
            }];
//        }
    }else if([dic[@"status"] intValue] == 21007){
        
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}

//支付VIP
- (void)createVIPOrder {
    kMeWEAKSELF

    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),
                          @"order_amount":kMeUnNilStr(_order_amount)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonMoneyMemberRecharge);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_isPayError = NO;
        strongSelf->_order_sn = responseObject.data[@"order_sn"];
        
        MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
        
        BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_order_amount];
        if(!isSucess){
            [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
        }
    } failure:^(id error) {
        
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
        METopUpSuccessVC *svc = [[METopUpSuccessVC alloc] initWithMoney:kMeUnNilStr(_order_amount) sucessConfireBlock:^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.finishBlock);
            NSArray *vcs = strongSelf.navigationController.viewControllers;
            UIViewController *vc = [vcs objectAtIndex:vcs.count-3];
            [strongSelf.navigationController popToViewController:vc animated:YES];
        }];
        [self.navigationController pushViewController:svc animated:YES];
        NSLog(@"支付成功");
        _isPayError = NO;
    }else{
        if(!_isPayError){
            [MECommonTool showMessage:@"充值失败" view:kMeCurrentWindow];
        }
        NSLog(@"支付失败");
        _isPayError = YES;
    }
}

- (UIButton *)createButtomWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag {
    NSArray *array = [title componentsSeparatedByString:@"\n"];
    UIFont *firstfont = [UIFont systemFontOfSize:17];
    UIFont *lastfont = [UIFont systemFontOfSize:11];
    if (IS_IPHONE_4S || IS_iPhone5S) {
        firstfont = [UIFont systemFontOfSize:15];
        lastfont = [UIFont systemFontOfSize:9];
    }
    //未选中时
    NSMutableAttributedString *norAttribTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",kMeUnNilStr(array.firstObject)] attributes:@{NSFontAttributeName:firstfont, NSForegroundColorAttributeName:kMEPink}];
    
    NSAttributedString *bottomStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",kMeUnNilStr(array.lastObject)] attributes:@{NSFontAttributeName:lastfont,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#30D9A5"]}];
    
    [norAttribTitle appendAttributedString:bottomStr];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:2];
    paraStyle.alignment = NSTextAlignmentCenter;
    [norAttribTitle addAttributes:@{NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, norAttribTitle.length)];
    //选中时
    NSMutableAttributedString *selAttribTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",kMeUnNilStr(array.firstObject)] attributes:@{NSFontAttributeName:firstfont, NSForegroundColorAttributeName:[UIColor whiteColor]}];

    NSAttributedString *selBottomStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",kMeUnNilStr(array.lastObject)] attributes:@{NSFontAttributeName:lastfont,NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [selAttribTitle appendAttributedString:selBottomStr];
    [selAttribTitle addAttributes:@{NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, selAttribTitle.length)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [btn setAttributedTitle:norAttribTitle forState:UIControlStateNormal];
    [btn setAttributedTitle:selAttribTitle forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.layer.cornerRadius = 4;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = kMEPink.CGColor;
    btn.tag = tag;
    [btn addTarget:self action:@selector(TopUpChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (IBAction)topUpAction:(id)sender {
    if (kMeUnNilStr(_order_amount).length <= 0) {
        [MECommonTool showMessage:@"请先选择要充值的金额" view:kMeCurrentWindow];
        return;
    }
    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
    if ([status isEqualToString:@"customer"]) {//C端
        self.hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
        self.hud.detailsLabel.text = @"充值进行中...";
        // 隐藏时候从父控件中移除
        self.hud.removeFromSuperViewOnHide = YES;
        //bundleid+xxx 就是你添加内购条目设置的产品ID
        if([SKPaymentQueue canMakePayments]){
            self.isFinish = NO;
            //是否允许内购
            if ([_order_amount isEqualToString:@"12"]) {
                [self requestProductData:courseTopUpNumber1];
            }else if ([_order_amount isEqualToString:@"30"]) {
                [self requestProductData:courseTopUpNumber2];
            }else if ([_order_amount isEqualToString:@"50"]) {
                [self requestProductData:courseTopUpNumber3];
            }else if ([_order_amount isEqualToString:@"108"]) {
                [self requestProductData:courseTopUpNumber4];
            }else if ([_order_amount isEqualToString:@"148"]) {
                [self requestProductData:courseTopUpNumber5];
            }else if ([_order_amount isEqualToString:@"198"]) {
                [self requestProductData:courseTopUpNumber6];
            }
        }else{
            [self.hud hideAnimated:YES];
            NSLog(@"不允许程序内付费");
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }else if ([status isEqualToString:@"business"]) {
        [self createVIPOrder];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WechatSuccess:) name:WX_PAY_RESULT object:nil];
}
- (IBAction)checkTopUpProtocolAction:(id)sender {
    [self requestTopUpProtocolWithNetWork];
}

#pragma mark -- Networking
//资金明细
- (void)requestTopUpProtocolWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetTopUpProtocolWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            NSString *topUpProtocol = kMeUnNilStr(responseObject.data[@"top_up_protocol"]);
            MEBaseVC *vc = [[MEBaseVC alloc] init];
            vc.title = @"充值协议";
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
            CGFloat width = [UIScreen mainScreen].bounds.size.width-15;
            NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
            [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(topUpProtocol)] baseURL:nil];
            [vc.view addSubview:webView];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(id object) {
        
    }];
}

@end
