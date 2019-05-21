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

@interface MEOrderCell ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrType;
    MEOrderModel *_model;
    MEOrderStyle _type;
    //yes 未自提
    BOOL _isSelf;
}

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNum;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTableViewHeight;


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
    _type = type;
    _consTableViewHeight.constant =  (kMEMyChildOrderContentCellHeight * kMeUnArr(model.children).count);
    _model = model;
    _btnCancelOrder.hidden = type!=MEAllNeedPayOrder;
    //|| type == MEAllNeedReceivedOrder ||type == MEAllFinishOrder
    if(type == MEAllNeedPayOrder  ){
        _btnPay.hidden = NO;
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
    _isSelf = YES;
    _consTableViewHeight.constant =  (kMEMyChildOrderContentCellHeight * kMeUnArr(model.children).count);
    _model = model;
    _btnCancelOrder.hidden = YES;
    _btnPay.hidden = YES;
    _lblOrderNum.text = kMeUnNilStr(model.order_sn);
    [self.tableView reloadData];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kMeUnArr(_model.children).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMyChildOrderContentCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyChildOrderContentCell class]) forIndexPath:indexPath];
    MEOrderGoodModel *model = kMeUnArr(_model.children)[indexPath.row];
    if(_isSelf){
        [cell setSelfUIWithModel:model extractStatus:_model.get_status];
    }else{
        [cell setUIWithModel:model];
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
    MEMyOrderVC *orderVC = (MEMyOrderVC *)[MECommonTool getVCWithClassWtihClassName:[MEMyOrderVC class] targetResponderView:self];
    if(orderVC){
        if(_type==MEAllNeedPayOrder){
            MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:[_model.order_status integerValue] orderGoodsSn:kMeUnNilStr(_model.order_sn)];
            [orderVC.navigationController pushViewController:vc animated:YES];
        }else if (_type == MEAllNeedReceivedOrder){
//            MELogisticsVC*vc  = [[MELogisticsVC alloc]initWithOrderGoodsSn:kMeUnNilStr(_model.order_sn)];
//            [orderVC.navigationController pushViewController:vc animated:YES];
        }else if (_type == MEAllFinishOrder){
//            MELogisticsVC*vc  = [[MELogisticsVC alloc]initWithOrderGoodsSn:kMeUnNilStr(_model.order_sn)];
//            [orderVC.navigationController pushViewController:vc animated:YES];
        }else{
            
        }
    }
}

- (IBAction)cancelOrderAction:(UIButton *)sender {
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
    if(type==MEAllNeedPayOrder ){
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

@end
