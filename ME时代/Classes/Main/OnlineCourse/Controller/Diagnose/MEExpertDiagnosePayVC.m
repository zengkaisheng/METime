//
//  MEExpertDiagnosePayVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEExpertDiagnosePayVC.h"
#import "MEExpertDiagnoseListCell.h"
#import "MEDiagnoseProductModel.h"
#import "MEExportDiagnoseRemarkCell.h"

#import "MEPayStatusVC.h"
#import "MEDiagnoseOrderListVC.h"

@interface MEExpertDiagnosePayVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_order_sn;
    NSString *_order_amount;
    BOOL _isPayError;//防止跳2次错误页面
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEDiagnoseProductModel *model;
@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *remark;

@end

@implementation MEExpertDiagnosePayVC

- (instancetype)initWithModel:(MEDiagnoseProductModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"定制方案";
    self.phone = @"";
    self.remark = @"";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payBtn];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        MEExportDiagnoseRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEExportDiagnoseRemarkCell class]) forIndexPath:indexPath];
        kMeWEAKSELF
        cell.phoneBlock = ^(NSString *str) {
            kMeSTRONGSELF
            if(str.length > 11){
                str = [str substringWithRange:NSMakeRange(0, 11)];
                [strongSelf.view endEditing:YES];
            }
            strongSelf.phone = str;
        };
        cell.remarkBlock = ^(NSString *str) {
            kMeSTRONGSELF
            strongSelf.remark = str;
        };
        return cell;
    }
    MEExpertDiagnoseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEExpertDiagnoseListCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:self.model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return kMEExportDiagnoseRemarkCellHeight;
    }
    return [MEExpertDiagnoseListCell getCellHeightWithContent:kMeUnNilStr(self.model.desc)];
}

#pragma mark -- Action
- (void)payAction {
    if (self.phone.length <= 0) {
        [MEShowViewTool showMessage:@"请输入手机号" view:self.view];
        return;
    }
    if(![MECommonTool isValidPhoneNum:self.phone]){
        [MEShowViewTool showMessage:@"手机格式不对" view:self.view];
        return;
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postCreateDiagnoiseOrderWithProductId:[NSString stringWithFormat:@"%@",@(self.model.idField)] orderType:@"3" phone:self.phone remark:self.remark successBlock:^(ZLRequestResponse *responseObject) {
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
            [strongSelf.navigationController popViewControllerAnimated:YES];
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
                MEDiagnoseOrderListVC *vc = [[MEDiagnoseOrderListVC alloc]init];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }];
            [self.navigationController pushViewController:svc animated:YES];
        }
        NSLog(@"支付失败");
        _isPayError = YES;
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-10 - 72) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEExpertDiagnoseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEExpertDiagnoseListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEExportDiagnoseRemarkCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEExportDiagnoseRemarkCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:@"支付" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_payBtn setBackgroundColor:kMEPink];
        _payBtn.frame = CGRectMake(15, SCREEN_HEIGHT - 52, SCREEN_WIDTH-30, 40);
        _payBtn.layer.cornerRadius = 20.0;
        [_payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

@end
