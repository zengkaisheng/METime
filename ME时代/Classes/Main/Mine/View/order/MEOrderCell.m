//
//  MEOrderCell.m
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEOrderCell.h"
#import "MEOrderModel.h"
#import "MEMyChildOrderContentCell.h"
#import "MEMyOrderVC.h"
#import "MEMyOrderDetailVC.h"
#import "MELogisticsVC.h"
#import "MEMySelfExtractionOrderVC.h"

#import "MEApplyRefundVC.h"
#import "MERefundModel.h"
#import "MEGroupOrderModel.h"
#import "ZLWebViewVC.h"
#import "MEMyGroupOrderVC.h"
#import "MEGroupOrderDetailVC.h"

@interface MEOrderCell ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrType;
    MEOrderModel *_model;
    MERefundModel *_refundModel;
    MEGroupOrderModel *_groupModel;
    MEOrderStyle _type;
    //yes 未自提
    BOOL _isSelf;
    BOOL _isGroup;
}

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNum;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTableViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *refundImgV;
@property (weak, nonatomic) IBOutlet UILabel *refundLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnPayConsWidth;

@property (nonatomic, strong) UIButton *logisticsBtn;

@end

@implementation MEOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _arrType = MEOrderStyleTitle;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyChildOrderContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyChildOrderContentCell class])];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _tableView.rowHeight = kMEMyChildOrderContentCellHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.contentView addSubview:self.logisticsBtn];
    self.logisticsBtn.hidden = YES;
    // Initialization code
}

- (void)setUIWithModel:(MEOrderModel *)model Type:(MEOrderStyle)type{
    _isSelf = NO;
    _refundImgV.hidden = YES;
    _refundLbl.hidden = YES;
    _type = type;
    _consTableViewHeight.constant =  (kMEMyChildOrderContentCellHeight * kMeUnArr(model.children).count);
    _model = model;
    _btnCancelOrder.hidden = type!=MEAllNeedPayOrder;
    //|| type == MEAllNeedReceivedOrder ||type == MEAllFinishOrder
    if(type == MEAllNeedPayOrder || type == MEAllNeedDeliveryOrder){
        _btnPay.hidden = NO;
        if (type == MEAllNeedDeliveryOrder) {
            _btnPay.layer.borderColor = kME333333.CGColor;
            _btnPay.layer.borderWidth = 1;
            _btnPay.layer.cornerRadius = 4;
            _btnPay.layer.masksToBounds = YES;
            _btnPay.backgroundColor = [UIColor whiteColor];
            [_btnPay setTitle:@"申请退款" forState:UIControlStateNormal];
            [_btnPay setTitleColor:kME333333 forState:UIControlStateNormal];
            [_btnPay.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:14]];
        }else {
            _btnPay.layer.borderWidth = 0;
            _btnPay.backgroundColor = kMEPink;
            [_btnPay setTitle:@"立即支付" forState:UIControlStateNormal];
            [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_btnPay.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
    }else{
        _btnPay.hidden = YES;
    }
//    if(type == MEAllNeedPayOrder){
//        [_btnPay setTitle:@"立即支付" forState:UIControlStateNormal];
//    }
//    else{
//        [_btnPay setTitle:@"查看物流" forState:UIControlStateNormal];
//    }
    _lblOrderNum.text = kMeUnNilStr(model.order_sn);
    [self.tableView reloadData];
}

- (void)setSelfUIWithModel:(MEOrderModel *)model{
    _refundImgV.hidden = YES;
    _refundLbl.hidden = YES;
    _isSelf = YES;
    _consTableViewHeight.constant =  (kMEMyChildOrderContentCellHeight * kMeUnArr(model.children).count);
    _model = model;
    _btnCancelOrder.hidden = YES;
    _btnPay.hidden = YES;
    _lblOrderNum.text = kMeUnNilStr(model.order_sn);
    [self.tableView reloadData];
}

- (void)setUIWithRefundModel:(MERefundModel *)model {
    _isSelf = NO;
    _refundImgV.hidden = NO;
    _refundLbl.hidden = NO;
    switch (model.refund_status) {
        case 1:
        {
            _btnCancelOrder.hidden = YES;
            _refundLbl.text = @"退货/退款  退款中";
        }
            break;
        case 2:
        {
            _btnCancelOrder.hidden = YES;
            [_btnCancelOrder setTitle:@"删除订单" forState:UIControlStateNormal];
            _refundLbl.text = @"退货/退款  退款成功";
        }
            break;
        case 3:
        {
            _btnCancelOrder.hidden = YES;
            [_btnCancelOrder setTitle:@"删除订单" forState:UIControlStateNormal];
            _refundLbl.text = @"退货/退款  退款失败";
        }
            break;
        default:
            break;
    }
    _type = MEAllRefundOrder;
    _consTableViewHeight.constant =  (kMEMyChildOrderContentCellHeight * kMeUnArr(model.order_goods).count);
    _refundModel = model;
    _btnPay.layer.borderColor = kME333333.CGColor;
    _btnPay.layer.borderWidth = 1;
    _btnPay.layer.cornerRadius = 4;
    _btnPay.layer.masksToBounds = YES;
    _btnPay.backgroundColor = [UIColor whiteColor];
    [_btnPay setTitle:@"查看详情" forState:UIControlStateNormal];
    [_btnPay setTitleColor:kME333333 forState:UIControlStateNormal];
    [_btnPay.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:14]];
    
    _lblOrderNum.text = kMeUnNilStr(model.order_sn);
    [self.tableView reloadData];
}

- (void)setUIWithGroupModel:(MEGroupOrderModel *)model {
    _isGroup = YES;
    _refundImgV.hidden = YES;
    _refundLbl.hidden = YES;
    
    _consTableViewHeight.constant =  136;
    _groupModel = model;
    
    _btnCancelOrder.hidden = NO;
    [_btnCancelOrder setTitleColor:[UIColor colorWithHexString:@"#FF88A4"] forState:UIControlStateNormal];
    [_btnCancelOrder.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    _btnPay.layer.borderColor = kME333333.CGColor;
    _btnPay.layer.borderWidth = 1;
    _btnPay.layer.cornerRadius = 4;
    _btnPay.layer.masksToBounds = YES;
    _btnPay.backgroundColor = [UIColor whiteColor];
    [_btnPay setTitle:@"查看详情" forState:UIControlStateNormal];
    [_btnPay setTitleColor:kME333333 forState:UIControlStateNormal];
    [_btnPay.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:14]];
    _btnPayConsWidth.constant = 80;
    self.logisticsBtn.hidden = YES;
    
    switch ([model.order_status integerValue]) {
        case 3:
        {
            [_btnCancelOrder setTitle:@"待收货" forState:UIControlStateNormal];
            self.logisticsBtn.hidden = NO;
        }
            break;
        case 4:
        {
            [_btnCancelOrder setTitle:@"已完成" forState:UIControlStateNormal];
            self.logisticsBtn.hidden = NO;
        }
            break;
        case 7:
        {
            [_btnCancelOrder setTitle:@"退款中" forState:UIControlStateNormal];
            self.logisticsBtn.hidden = YES;
        }
            break;
        case 8:
        {
            [_btnCancelOrder setTitle:@"已退款" forState:UIControlStateNormal];
            self.logisticsBtn.hidden = YES;
        }
            break;
        case 10://进行中
        {
            [_btnCancelOrder setTitle:@"拼团中" forState:UIControlStateNormal];
            self.logisticsBtn.hidden = YES;
        }
            break;
        case 11://完成
        {
            [_btnCancelOrder setTitle:@"拼团成功" forState:UIControlStateNormal];
            self.logisticsBtn.hidden = NO;
        }
            break;
        case 12://失败
        {
            [_btnCancelOrder setTitle:@"拼团失败" forState:UIControlStateNormal];
            self.logisticsBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
    [_btnCancelOrder setTitle:kMeUnNilStr(model.order_status_name) forState:UIControlStateNormal];
    _lblOrderNum.text = kMeUnNilStr(model.order_sn);
    [self.tableView reloadData];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == MEAllRefundOrder) {
        return kMeUnArr(_refundModel.order_goods).count;
    }else {
        if (_isGroup) {
            return 1;
        }
    }
    return kMeUnArr(_model.children).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isGroup) {
        return 135;
    }
    return kMEMyChildOrderContentCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMyChildOrderContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyChildOrderContentCell class]) forIndexPath:indexPath];
    if (_type == MEAllRefundOrder) {
        MERefundGoodModel *goodModel = kMeUnArr(_refundModel.order_goods)[indexPath.row];
        [cell setUIWithRefundModel:goodModel];
    }else {
        if (_isGroup) {
            [cell setUIWithGroupModel:_groupModel];
        }else {
            MEOrderGoodModel *model = kMeUnArr(_model.children)[indexPath.row];
            if(_isSelf){
                [cell setSelfUIWithModel:model extractStatus:_model.get_status];
            }else{
                [cell setUIWithModel:model];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_isSelf){
        if(_touchBlock){
            kMeCallBlock(_touchBlock);
            return;
        }
        MEMySelfExtractionOrderVC *orderVC = (MEMySelfExtractionOrderVC *)[MECommonTool getVCWithClassWtihClassName:[MEMySelfExtractionOrderVC class] targetResponderView:self];
        MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initSelfWithType:[_model.order_status integerValue] orderGoodsSn:kMeUnNilStr(_model.order_sn)];
        [orderVC.navigationController pushViewController:vc animated:YES];
    }else{
        if (_isGroup) {
            MEMyGroupOrderVC *orderVC = (MEMyGroupOrderVC *)[MECommonTool getVCWithClassWtihClassName:[MEMyGroupOrderVC class] targetResponderView:self];
            MEGroupOrderDetailVC *vc = [[MEGroupOrderDetailVC alloc] initWithOrderSn:kMeUnNilStr(_groupModel.order_sn)];
            [orderVC.navigationController pushViewController:vc animated:YES];
        }else {
            MEMyOrderVC *orderVC = (MEMyOrderVC *)[MECommonTool getVCWithClassWtihClassName:[MEMyOrderVC class] targetResponderView:self];
            MEOrderGoodModel *model = kMeUnArr(_model.children)[indexPath.row];
            if (model.product_type == 7) {
                MEGroupOrderDetailVC *vc = [[MEGroupOrderDetailVC alloc] initWithOrderSn:kMeUnNilStr(_model.order_sn)];
                [orderVC.navigationController pushViewController:vc animated:YES];
            }else {
                MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:[_model.order_status integerValue] orderGoodsSn:kMeUnNilStr(_model.order_sn)];
                [orderVC.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
//查看物流
- (void)checkLogisticAction {
    if (_groupModel.express_detail.count > 0) {
        MEMyGroupOrderVC *orderVC = (MEMyGroupOrderVC *)[MECommonTool getVCWithClassWtihClassName:[MEMyGroupOrderVC class] targetResponderView:self];
        if (orderVC) {
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            webVC.title = @"物流信息";
            MEGroupOrderExpressModel *model = _groupModel.express_detail[0];
            [webVC loadURLString:kMeUnNilStr(model.express_url)];
            [orderVC.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (IBAction)payAction:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    if (_type == MEAllRefundOrder && [btn.titleLabel.text isEqualToString:@"查看详情"]) {
        if (self.touchBlock) {
            self.touchBlock();
        }
        return;
    }
    if (_isGroup) {
        MEMyGroupOrderVC *orderVC = (MEMyGroupOrderVC *)[MECommonTool getVCWithClassWtihClassName:[MEMyGroupOrderVC class] targetResponderView:self];
        if (orderVC) {
            MEGroupOrderDetailVC *vc = [[MEGroupOrderDetailVC alloc] initWithOrderSn:kMeUnNilStr(_groupModel.order_sn)];
            [orderVC.navigationController pushViewController:vc animated:YES];
        }
    }else {
        MEMyOrderVC *orderVC = (MEMyOrderVC *)[MECommonTool getVCWithClassWtihClassName:[MEMyOrderVC class] targetResponderView:self];
        if(orderVC){
            if(_type==MEAllNeedPayOrder){
                MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:[_model.order_status integerValue] orderGoodsSn:kMeUnNilStr(_model.order_sn)];
                [orderVC.navigationController pushViewController:vc animated:YES];
            }else if (_type == MEAllNeedDeliveryOrder){
                MEApplyRefundVC *applyVC = [[MEApplyRefundVC alloc] initWithType:[_model.order_status integerValue] orderGoodsSn:kMeUnNilStr(_model.order_sn)];
                [orderVC.navigationController pushViewController:applyVC animated:YES];
            }else if (_type == MEAllFinishOrder){
                //            MELogisticsVC*vc  = [[MELogisticsVC alloc]initWithOrderGoodsSn:kMeUnNilStr(_model.order_sn)];
                //            [orderVC.navigationController pushViewController:vc animated:YES];
            }else{
                
            }
        }
    }
}

- (IBAction)cancelOrderAction:(UIButton *)sender {
    if (_isGroup) {
        return;
    }
    if (_type == MEAllRefundOrder) {
//        NSLog(@"点击了删除订单");
        return;
    }
    MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定要取消该订单吗?"];
    [aler addButtonWithTitle:@"取消"];
    kMeWEAKSELF
    [aler addButtonWithTitle:@"确定" block:^{
        kMeSTRONGSELF
        [MEPublicNetWorkTool postDelOrderWithOrderSn:strongSelf->_model.order_sn successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            kMeCallBlock(strongSelf->_cancelOrderBlock);
            kNoticeReloadOrder
        } failure:nil];
    }];
    [aler show];
}

+ (CGFloat)getCellHeightWithModel:(MEOrderModel *)model Type:(MEOrderStyle)type{
    CGFloat height;
    //|| type==MEAllNeedReceivedOrder || type==MEAllFinishOrder
    if(type==MEAllNeedPayOrder || type == MEAllNeedDeliveryOrder){
         height = (kMEMyChildOrderContentCellHeight * kMeUnArr(model.children).count) +kMEOrderCellNeedPayBtnHeight;
    }else{
         height = (kMEMyChildOrderContentCellHeight * kMeUnArr(model.children).count) +kMEOrderCellNoPayedBtnHeight;
    }
    return height;
}

+ (CGFloat)getCellSelfHeightWithModel:(MEOrderModel *)model{
    CGFloat height;
    height = (kMEMyChildOrderContentCellHeight * kMeUnArr(model.children).count) +kMEOrderCellNoPayedBtnHeight;
    return height;
}

+ (CGFloat)getCellHeightWithRefundModel:(MERefundModel *)model {
    CGFloat height;
    height = (kMEMyChildOrderContentCellHeight * kMeUnArr(model.order_goods).count) + kMEOrderCellNeedPayBtnHeight;
    return height;
}

+ (CGFloat)getCellHeightWithGroupModel:(MEGroupOrderModel *)model {
    return 136+87;
}

- (UIButton *)logisticsBtn {
    if (!_logisticsBtn) {
        _logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logisticsBtn.frame = CGRectMake(SCREEN_WIDTH-15-80-10-80, 182, 80, 30);
        _logisticsBtn.layer.borderColor = kME333333.CGColor;
        _logisticsBtn.layer.borderWidth = 1;
        _logisticsBtn.layer.cornerRadius = 4;
        _logisticsBtn.layer.masksToBounds = YES;
        _logisticsBtn.backgroundColor = [UIColor whiteColor];
        [_logisticsBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_logisticsBtn setTitleColor:kME333333 forState:UIControlStateNormal];
        [_logisticsBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:14]];
        [_logisticsBtn addTarget:self action:@selector(checkLogisticAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logisticsBtn;
}

@end
