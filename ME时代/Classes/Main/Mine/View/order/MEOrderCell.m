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
//#import "MELogisticsVC.h"
#import "MEMySelfExtractionOrderVC.h"

#import "MEApplyRefundVC.h"
#import "MERefundModel.h"

@interface MEOrderCell ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrType;
    MEOrderModel *_model;
    MERefundModel *_refundModel;
    MEOrderStyle _type;
    //yes 未自提
    BOOL _isSelf;
}

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNum;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTableViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *refundImgV;
@property (weak, nonatomic) IBOutlet UILabel *refundLbl;


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

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == MEAllRefundOrder) {
        return kMeUnArr(_refundModel.order_goods).count;
    }
    return kMeUnArr(_model.children).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMyChildOrderContentCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyChildOrderContentCell class]) forIndexPath:indexPath];
    if (_type == MEAllRefundOrder) {
        MERefundGoodModel *goodModel = kMeUnArr(_refundModel.order_goods)[indexPath.row];
        [cell setUIWithRefundModel:goodModel];
    }else {
        MEOrderGoodModel *model = kMeUnArr(_model.children)[indexPath.row];
        if(_isSelf){
            [cell setSelfUIWithModel:model extractStatus:_model.get_status];
        }else{
            [cell setUIWithModel:model];
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
        MEMyOrderVC *orderVC = (MEMyOrderVC *)[MECommonTool getVCWithClassWtihClassName:[MEMyOrderVC class] targetResponderView:self];
        MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:[_model.order_status integerValue] orderGoodsSn:kMeUnNilStr(_model.order_sn)];
        [orderVC.navigationController pushViewController:vc animated:YES];
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

- (IBAction)cancelOrderAction:(UIButton *)sender {
    if (_type == MEAllRefundOrder) {
        NSLog(@"点击了删除订单");
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

@end
