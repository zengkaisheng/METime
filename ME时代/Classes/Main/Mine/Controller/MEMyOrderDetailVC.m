//
//  MEMyOrderDetailVC.m
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyOrderDetailVC.h"
#import "MEMyOrderDetailCell.h"
#import "MEOrderDetailView.h"
#import "MEOrderDetailContentCell.h"
#import "MEOrderDetailModel.h"
#import "MEOrderModel.h"
#import "MEPayStatusVC.h"
#import "MEMyOrderVC.h"
#import "METopUpTipsView.h"

@interface MEMyOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>{
    MEOrderStyle _orderType;
    NSString *_orderGoodsSn;
    MEOrderDetailModel *_detaliModel;
    BOOL _isPayError;//防止跳2次错误页面
    BOOL _isSelf;//是否自提订单
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) NSArray *arrDataStr;
@property (nonatomic, strong) MEOrderDetailView *headerView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomSelfExtractView;
@property (nonatomic, strong) UIButton *payBtn;

@end

@implementation MEMyOrderDetailVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (instancetype)initWithOrderGoodsSn:(NSString *)orderGoodsSn{
    if(self = [super init]){
        _isSelf = NO;
        _orderGoodsSn = orderGoodsSn;
    }
    return self;
}

- (instancetype)initWithType:(MEOrderStyle)type orderGoodsSn:(NSString *)orderGoodsSn{
    if(self = [super init]){
        _isSelf = NO;
        _orderType = type;
        _orderGoodsSn = orderGoodsSn;
    }
    return self;
}

- (instancetype)initSelfWithType:(MEOrderStyle)type orderGoodsSn:(NSString *)orderGoodsSn{
    if(self = [super init]){
        _isSelf = YES;
        _orderType = type;
        _orderGoodsSn = orderGoodsSn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self getOrderDetailWithNetworking];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WechatSuccess:) name:WX_PAY_RESULT object:nil];
}

- (void)getOrderDetailWithNetworking {
    kMeWEAKSELF
    [MEPublicNetWorkTool getOrderDetailWithGoodSn:_orderGoodsSn successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_detaliModel = [MEOrderDetailModel mj_objectWithKeyValues:responseObject.data];
        strongSelf->_detaliModel.isTopUp = strongSelf.isTopUp;
        strongSelf->_orderType = [strongSelf->_detaliModel.order_status integerValue];
        if(kMeUnNilStr(strongSelf->_detaliModel.remark).length){
            if (strongSelf->_detaliModel.order_type == 17) {
                NSArray *firstArray = @[@(MESettlmemtGoodsPrice),@(MESettlmemtFreight),@(MESettlmemtRealPay),@(MESettlmemtRemark)];
                strongSelf.arrDataStr = @[[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.order_amount)],[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.all_freight)],kMeUnNilStr(strongSelf->_detaliModel.actual_money),kMeUnNilStr(strongSelf->_detaliModel.remark)];
                if (strongSelf.isTopUp) {
                    MEOrderGoodModel *orderModel = kMeUnArr(strongSelf->_detaliModel.children)[0];
                    firstArray = @[@(MESettlmemtGoodsPrice),@(MESettlmemtFreight),@(MESettlmemtRealPay),@(MESettlmemtPhoneBill),@(MESettlmemtRemark)];
                    strongSelf.arrDataStr = @[[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.order_amount)],[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.all_freight)],kMeUnNilStr(strongSelf->_detaliModel.actual_money),kMeUnNilStr(orderModel.get_phone_bill),kMeUnNilStr(strongSelf->_detaliModel.remark)];
                }
                strongSelf.arrData = @[firstArray,@[[NSString stringWithFormat:@"订单编号：%@",kMeUnNilStr(strongSelf->_detaliModel.order_sn)],[NSString stringWithFormat:@"创建时间：%@",kMeUnNilStr(strongSelf->_detaliModel.created_at)],[NSString stringWithFormat:@"交易时间：%@",kMeUnNilStr(strongSelf->_detaliModel.pay_time)],[NSString stringWithFormat:@"女神卡：%@",kMeUnNilStr(strongSelf->_detaliModel.girl_number)],[NSString stringWithFormat:@"体验中心姓名：%@",kMeUnNilStr(strongSelf->_detaliModel.store_name)],[NSString stringWithFormat:@"体验中心手机：%@",kMeUnNilStr(strongSelf->_detaliModel.cellphone)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_detaliModel.tips)]]];
            }else {
                strongSelf.arrData =  @[@(MESettlmemtFreight),@(MESettlmemtRealPay),@(MESettlmemtExpressCompany),@(MESettlmemtExpressNum),@(MESettlmemtRemark)];
                strongSelf.arrDataStr = @[[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.all_freight)],[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.order_amount)],kMeUnNilStr(strongSelf->_detaliModel.express.express_company),kMeUnNilStr(strongSelf->_detaliModel.express.express_num),kMeUnNilStr(strongSelf->_detaliModel.remark)];
            }
        }else{
            if (strongSelf->_detaliModel.order_type == 17) {
                NSArray *firstArray = @[@(MESettlmemtGoodsPrice),@(MESettlmemtFreight),@(MESettlmemtRealPay)];
                strongSelf.arrDataStr = @[[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.order_amount)],[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.all_freight)],kMeUnNilStr(strongSelf->_detaliModel.actual_money)];
                if (strongSelf.isTopUp) {
                    MEOrderGoodModel *orderModel = kMeUnArr(strongSelf->_detaliModel.children)[0];
                    firstArray = @[@(MESettlmemtGoodsPrice),@(MESettlmemtFreight),@(MESettlmemtRealPay),@(MESettlmemtPhoneBill)];
                    strongSelf.arrDataStr = @[[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.order_amount)],[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.all_freight)],kMeUnNilStr(strongSelf->_detaliModel.actual_money),kMeUnNilStr(orderModel.get_phone_bill)];
                }
                strongSelf.arrData = @[firstArray,@[[NSString stringWithFormat:@"订单编号：%@",kMeUnNilStr(strongSelf->_detaliModel.order_sn)],[NSString stringWithFormat:@"创建时间：%@",kMeUnNilStr(strongSelf->_detaliModel.created_at)],[NSString stringWithFormat:@"交易时间：%@",kMeUnNilStr(strongSelf->_detaliModel.pay_time)],[NSString stringWithFormat:@"女神卡：%@",kMeUnNilStr(strongSelf->_detaliModel.girl_number)],[NSString stringWithFormat:@"体验中心姓名：%@",kMeUnNilStr(strongSelf->_detaliModel.store_name)],[NSString stringWithFormat:@"体验中心手机：%@",kMeUnNilStr(strongSelf->_detaliModel.cellphone)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_detaliModel.tips)]]];
            }else {
                strongSelf.arrData =  @[@(MESettlmemtFreight),@(MESettlmemtRealPay),@(MESettlmemtExpressCompany),@(MESettlmemtExpressNum)];
                strongSelf.arrDataStr = @[[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.all_freight)],[NSString stringWithFormat:@"¥%@",kMeUnNilStr(strongSelf->_detaliModel.order_amount)],kMeUnNilStr(strongSelf->_detaliModel.express.express_company),kMeUnNilStr(strongSelf->_detaliModel.express.express_num)];
            }
        }
        strongSelf.tableView.tableHeaderView = strongSelf.headerView;
        if (strongSelf.isTopUp) {
            if (strongSelf->_detaliModel.top_up_status == 2) {
                strongSelf.tableView.tableFooterView = strongSelf.bottomView;
                [strongSelf.payBtn setTitle:@"立即充值" forState:UIControlStateNormal];
            }
        }else {
            if(strongSelf->_orderType == MEAllNeedPayOrder && strongSelf->_isSelf==NO){
                strongSelf.tableView.tableFooterView = strongSelf.bottomView;
            }
            if(strongSelf->_isSelf==YES &&
               strongSelf->_detaliModel.store_get &&
               strongSelf->_detaliModel.store_get.get_status==MEOSelfNotExtractionrderStyle)
            {
                strongSelf.tableView.tableFooterView = strongSelf.bottomSelfExtractView;
            }
        }
        [strongSelf.view addSubview:strongSelf.tableView];
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
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
        kNoticeReloadOrder
        NSLog(@"支付成功");
        _isPayError = NO;
        MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
            kMeSTRONGSELF
            MEMyOrderVC *orderVC = (MEMyOrderVC *)[MECommonTool getClassWtihClassName:[MEMyOrderVC class] targetVC:self];
            if(orderVC){
                [strongSelf.navigationController popToViewController:orderVC animated:YES];
            }
        }];
        [self.navigationController pushViewController:svc animated:YES];

    }else{
        if(!_isPayError){
            MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithFailRePayBlock:^{
                kMeWEAKSELF
                [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(self->_orderGoodsSn) successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                    BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_detaliModel.order_amount];
                    if(!isSucess){
                        [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                    }
                } failure:^(id object) {
                    
                }];
            } CheckOrderBlock:^{
                kMeSTRONGSELF
                [strongSelf.navigationController popToViewController:self animated:YES];
                //                kMeSTRONGSELF
                //                MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:MEAllNeedPayOrder orderGoodsSn:kMeUnNilStr(strongSelf->_order_sn)];
                //                [strongSelf.navigationController pushViewController:vc animated:YES];
            }];
            [self.navigationController pushViewController:svc animated:YES];
        }
        NSLog(@"支付失败");
        _isPayError = YES;
    }
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_detaliModel.order_type == 17) {
        return 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section){
        if (_detaliModel.order_type == 17) {
            NSArray *array = _arrData[section-1];
            return array.count;
        }
        return _arrData.count;
    }else{
        return kMeUnArr(_detaliModel.children).count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section){
        MEMyOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyOrderDetailCell class]) forIndexPath:indexPath];
        ;
        if (_detaliModel.order_type == 17) {
            NSArray *array = _arrData[indexPath.section-1];
            if (indexPath.section == 1) {
                [cell setUIWithModel:_arrDataStr[indexPath.row] Type:[array[indexPath.row] integerValue] orderType:_orderType];
            }else {
                [cell setLianTongUIWithContent:[NSString stringWithFormat:@"%@",kMeUnNilStr(array[indexPath.row])]];
            }
        }else {
            [cell setUIWithModel:_arrDataStr[indexPath.row] Type:[_arrData[indexPath.row] integerValue] orderType:_orderType];
        }
        return cell;
    }else{
        MEOrderDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderDetailContentCell class]) forIndexPath:indexPath];
        MEOrderGoodModel *orderModel = kMeUnArr(_detaliModel.children)[indexPath.row];
        [cell setUIWithChildModel:orderModel];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        if (_detaliModel.order_type == 17) {
            if (indexPath.section == 1) {
                return kMEMyOrderDetailCellHeight;
            }
            if (indexPath.section == 2) {
                if (indexPath.row == 2) {
                    if (kMeUnNilStr(_detaliModel.pay_time).length <= 0) {
                        return 0;
                    }
                }
//                else if (indexPath.row == 4||indexPath.row==5||indexPath.row==6){
//                    if (self.isTopUp) {
//                        return 0;
//                    }
//                }
            }
            return 35;
        }
        return kMEMyOrderDetailCellHeight;
    }
    return kMEOrderDetailContentCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section?kMEMyOrderDetailCellHeight:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section){
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEMyOrderDetailCellHeight)];
        UILabel *lblTitle = [[UILabel alloc]init];
        lblTitle.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, kMEMyOrderDetailCellHeight);
        [sectionView addSubview:lblTitle];
        lblTitle.text = @"结算";
        
        if (_detaliModel.order_type == 17) {
            if (section == 2) {
                sectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEMyOrderDetailCellHeight+10);
                lblTitle.text = @"订单明细";
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
                line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
                [sectionView addSubview:line];
                
                lblTitle.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, kMEMyOrderDetailCellHeight);
            }
        }
        lblTitle.font = [UIFont systemFontOfSize:16];
        lblTitle.textColor = kMEHexColor(@"333333");
//        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(sectionView.mas_left).offset(15);
//            make.right.equalTo(sectionView.mas_right).offset(15);
//            make.top.equalTo(sectionView);
//            make.bottom.equalTo(sectionView);
//        }];
        return sectionView;
    }else{
        return [UIView new];
    }
}

- (void)toExtract:(UIButton *)btn{
    MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定提取?"];
    [aler addButtonWithTitle:@"取消"];
    kMeWEAKSELF
    [aler addButtonWithTitle:@"确定" block:^{
        kMeSTRONGSELF
        [MEPublicNetWorkTool postcheckStoreGetOrderStatusWithGoodSn:kMeUnNilStr(strongSelf->_detaliModel.order_sn) successBlock:^(ZLRequestResponse *responseObject) {
            kNoticeReloadSelfExtractOrder
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(id object) {
            
        }];
    }];
    [aler show];
}

- (void)toPay:(UIButton *)btn{
    if (_detaliModel.isTopUp) {
        if (_detaliModel.top_up_status == 2) {
            MEOrderGoodModel *orderModel = kMeUnArr(_detaliModel.children)[0];
            [METopUpTipsView showTopUpTipsViewWithPhone:kMeUnNilStr(_detaliModel.girl_number) money:kMeUnNilStr(orderModel.get_phone_bill) successBlock:^{
                kMeWEAKSELF
                [MEPublicNetWorkTool postTopUpLianTongOrderWithOrderSn:kMeUnNilStr(self->_orderGoodsSn) SuccessBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    [strongSelf getOrderDetailWithNetworking];
                    
                } failure:^(id object) {
                    
                }];
            } cancelBlock:^{
            } superView:kMeCurrentWindow];
        }
    }else {
        kMeWEAKSELF
        [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(self->_orderGoodsSn) successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            PAYPRE
            strongSelf->_isPayError= NO;
            MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
            BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_detaliModel.order_amount];
            if(!isSucess){
                [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
            }
        } failure:^(id object) {
            
        }];
    }
}

#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyOrderDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyOrderDetailCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOrderDetailContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOrderDetailContentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEOrderDetailView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEOrderDetailView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEOrderDetailView getViewHeightWithType:_orderType Model:_detaliModel]);
        [_headerView setUIWithModel:_detaliModel orderType:_orderType];
    }
    return _headerView;
}

- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 45);
        [btn addTarget:self action:@selector(toPay:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = kMEPink;
        [btn setTitle:@"立即支付" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.cornerRadius = 5;
        btn.clipsToBounds = YES;
        self.payBtn = btn;
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_bottomView addSubview:btn];
    }
    return _bottomView;
}

- (UIView *)bottomSelfExtractView{
    if(!_bottomSelfExtractView){
        _bottomSelfExtractView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 45);
        [btn addTarget:self action:@selector(toExtract:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = kMEPink;
        [btn setTitle:@"立即提取" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_bottomSelfExtractView addSubview:btn];
    }
    return _bottomSelfExtractView;
}


@end
