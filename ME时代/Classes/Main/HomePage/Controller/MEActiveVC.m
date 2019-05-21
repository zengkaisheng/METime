//
//  MEActiveVC.m
//  ME时代
//
//  Created by hank on 2018/10/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEActiveVC.h"
#import "TDWebViewCell.h"
//#import "MESkuBuyView.h"
#import "MEGoodDetailModel.h"
#import "MEGoodModel.h"
#import "MEMakeOrderVC.h"
#import "MELoginVC.h"
#import "MEMakeOrderAttrModel.h"
#import "MEPayStatusVC.h"
#import "MEMyOrderDetailVC.h"



@interface MEActiveVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_order_sn;
    BOOL _isPayError;//防止跳2次错误页面
}
@property (nonatomic, strong) UITableView           *tableView;
@property (strong, nonatomic) TDWebViewCell                  *webCell;
//@property (nonatomic, strong) MESkuBuyView *purchaseView;
@property (nonatomic, strong) MEGoodDetailModel *model;
@property (nonatomic, strong) UIButton *btnAppoint;
@end

@implementation MEActiveVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [self initWithSomeThing];
    kTDWebViewCellDidFinishLoadNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WechatSuccess:) name:WX_PAY_RESULT object:nil];
    // Do any additional setup after loading the view.
}

kTDWebViewCellDidFinishLoadNotificationMethod

- (void)initWithSomeThing{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGoodsComboDetailWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MEGoodDetailModel *model = [MEGoodDetailModel mj_objectWithKeyValues:responseObject.data];
        model.buynum = 1;
        [strongSelf setUIWIthModel:model];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)setUIWIthModel:(MEGoodDetailModel *)model{
    _model = model;
    
    NSMutableArray *arrSpc = [NSMutableArray array];
    
    [kMeUnArr(model.spec) enumerateObjectsUsingBlock:^(MEGoodDetailSpecModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {\
        MEGoodSpecModel *model = kMeUnArr(obj.spec_value)[0];
        [arrSpc addObject:@(model.idField).description];
    }];
    NSString *str = [arrSpc componentsJoinedByString:@","];
    _model.spec_ids = str;
    
    [self.view addSubview:self.tableView];
    NSLog(@"%@",kCurrentUser.mobile);
    if(![kCurrentUser.mobile isEqualToString:AppstorePhone]){
        [self.view addSubview:self.btnAppoint];
        [self.btnAppoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(50));
            make.width.equalTo(@(self.view.width));
            make.top.equalTo(@(self.view.bottom-50));
        }];
    }else{
        self.tableView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight);
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(_model.content)] baseURL:nil];
    [MBProgressHUD showMessage:@"获取详情中" toView:self.view];
}

#pragma mark - Acion

- (void)appointAction:(UIButton *)btn{
    if([MEUserInfoModel isLogin]){
//        [self creatOrder];
        MEMakeOrderVC *vc = [[MEMakeOrderVC alloc]initWithIsinteral:NO goodModel:_model];
        vc.isProctComd = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
//            [strongSelf creatOrder];
            MEMakeOrderVC *vc = [[MEMakeOrderVC alloc]initWithIsinteral:NO goodModel:strongSelf->_model];
            vc.isProctComd = YES;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } failHandler:nil];
    }
}

//- (void)creatOrder{
//    MEMakeOrderAttrModel *model = [[MEMakeOrderAttrModel alloc]initWithGoodDetailModel:_model];
//    kMeWEAKSELF
//    [MEPublicNetWorkTool postCreateCombOrderWithAttrModel:model successBlock:^(ZLRequestResponse *responseObject) {
//        kMeSTRONGSELF
//        strongSelf->_order_sn = responseObject.data[@"order_sn"];
//        [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(strongSelf->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
//            kMeSTRONGSELF
//            PAYPRE
//            strongSelf->_isPayError= NO;
//            MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
//            CGFloat f = [strongSelf->_model.money floatValue] * (strongSelf->_model.buynum);
//            BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:@(f).description];
//            if(!isSucess){
//                [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
//            }
//        } failure:^(id object) {
//
//        }];
//    } failure:^(id object) {
//
//    }];
//}

//#pragma mark - Pay
//
//- (void)WechatSuccess:(NSNotification *)noti{
//    [self payResultWithNoti:[noti object] result:WXPAY_SUCCESSED];
//}

- (void)payResultWithNoti:(NSString *)noti result:(NSString *)result{

//    PAYJUDGE
//    kMeWEAKSELF
//    if ([noti isEqualToString:result]) {
//        if(_isPayError){
//            [self.navigationController popViewControllerAnimated:NO];
//        }
//        MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
//            kMeSTRONGSELF
//            [strongSelf.navigationController popToViewController:self animated:YES];
//        }];
//        [self.navigationController pushViewController:svc animated:YES];
//        NSLog(@"支付成功");
//        _isPayError = NO;
//    }else{
//        if(!_isPayError){
//            kMeWEAKSELF
//            MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithFailRePayBlock:^{
//                [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(self->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
//                    kMeSTRONGSELF
//                    MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
//                    CGFloat f = [strongSelf->_model.money floatValue] * (strongSelf->_model.buynum);
//                    BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:@(f).description];
//                    if(!isSucess){
//                        [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
//                    }
//                } failure:^(id object) {
//
//                }];
//            } CheckOrderBlock:^{
//                kMeSTRONGSELF
//                MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:MEAllNeedPayOrder orderGoodsSn:kMeUnNilStr(strongSelf->_order_sn)];
//                [strongSelf.navigationController pushViewController:vc animated:YES];
//            }];
//            [self.navigationController pushViewController:svc animated:YES];
//        }
//        NSLog(@"支付失败");
//        _isPayError = YES;
//    }
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return self.webCell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.section);
    
}

#pragma mark - Set

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-k50WH) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIButton *)btnAppoint{
    if(!_btnAppoint){
        _btnAppoint = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAppoint.frame = CGRectMake(0, self.view.height - k50WH, SCREEN_WIDTH, k50WH);
        [_btnAppoint setTitle:@"立即订购" forState:UIControlStateNormal];
        [_btnAppoint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnAppoint.backgroundColor = kMEPink;
        [_btnAppoint addTarget:self action:@selector(appointAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAppoint;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

//- (MESkuBuyView *)purchaseView{
//    if(!_purchaseView){
//        _purchaseView = [[MESkuBuyView alloc]initPurchaseViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) serviceModel:_model WithSuperView:self.view];
//    }
//    return _purchaseView;
//}


@end
