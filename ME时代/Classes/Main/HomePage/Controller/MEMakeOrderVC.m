//
//  MEMakeOrderVC.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMakeOrderVC.h"
#import "MEMakeOrderCell.h"
#import "MEMakeOrderSelectAddressView.h"
#import "MEMakeOrderHeaderCell.h"
#import "MESelectAddressVC.h"
#import "MEGoodDetailModel.h"
#import "MEAddressModel.h"
#import "MEMakeOrderAttrModel.h"
#import "MEPayStatusVC.h"
#import "MEMyOrderDetailVC.h"

//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MEGroupProductDetailVC.h"
#import "MEGroupOrderDetailVC.h"

#import "MEMineExchangeDetailVC.h"

#import "MEPreferentialCell.h"

@interface MEMakeOrderVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _hasAdress;
    NSArray *_arrType;
    BOOL _isInteral;
    MEGoodDetailModel *_goodModel;
    MEAddressModel *_addressModel;
    NSString *_strMeaasge;
    NSString *_order_sn;
    BOOL _isPayError;//防止跳2次错误页面
    NSArray *_arrData;
    NSString *_origainlPostage;
    NSString *_girlNumber;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MEMakeOrderSelectAddressView *sAddressView;
@property (weak, nonatomic) IBOutlet UILabel *lblAllPrice;
@property (strong, nonatomic) UIView *notAddressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;

@end

@implementation MEMakeOrderVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

#pragma mark - LifeCycle

- (instancetype)initWithIsinteral:(BOOL)isInteral goodModel:(MEGoodDetailModel *)goodModel{
    if (self = [super init]){
        _isInteral = isInteral;
        _goodModel = [MEGoodDetailModel mj_objectWithKeyValues:goodModel.mj_keyValues];
        _isPayError= NO;
        _arrData = [NSArray array];
        _origainlPostage = goodModel.postage;
        self.isProctComd = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生成订单";
    _topMargin.constant = kMeNavBarHeight;
    kMeWEAKSELF
    if ([self->_goodModel.skus containsString:@"到店领取"]) {
        [MEPublicNetWorkTool postStoreAddressWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            [strongSelf getUserDefaultAddress];
            
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else {
        [self getUserDefaultAddress];
    }
//    [self initSomeThing];
    // Do any additional setup after loading the view from its nib.
}
//获取用户默认收货地址
- (void)getUserDefaultAddress {
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddressDefaultAddressWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        MEAddressModel *model = [MEAddressModel mj_objectWithKeyValues:responseObject.data];
        kMeSTRONGSELF
        if(model){
            strongSelf->_hasAdress = YES;
            strongSelf->_addressModel = [MEAddressModel mj_objectWithKeyValues:responseObject.data];
            [strongSelf initSomeThing];
        }else{
            [strongSelf initSomeThing];
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf initSomeThing];
    }];
}
//获取用户选择收货地址的邮费
- (void)getUserOrderFreightWithAddressId:(NSString *)addressId postage:(NSString *)postage productId:(NSString *)productId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postOrderFreightWithAddressId:addressId postage:postage productId:productId SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_goodModel.postage = responseObject.data;
        [strongSelf changePostage];
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.tableView reloadData];
    }];
}

- (void)changePostage {
    if (_isInteral) {
        CGFloat allBean = [kMeUnNilStr(_goodModel.psmodel.integral_lines) floatValue] * _goodModel.buynum;
        _lblAllPrice.text = [NSString stringWithFormat:@"%.2f美豆",allBean];
    }else {
        CGFloat allPrice = 0;
        if (self.isReceivePrize) {
            allPrice = [kMeUnNilStr(_goodModel.postage) floatValue] + [kMeUnNilStr(_goodModel.psmodel.draw_price) floatValue] * _goodModel.buynum;
        }else {
            if (self.bargainId > 0) {
                allPrice = [kMeUnNilStr(_goodModel.psmodel.goods_price) floatValue] * _goodModel.buynum - [kMeUnNilStr(self.reducePrice) floatValue] + [kMeUnNilStr(_goodModel.postage) floatValue];
            }else {
                if(self.isProctComd){
                    allPrice = [kMeUnNilStr(_goodModel.money) floatValue];
                }else{
                    if(_goodModel.is_seckill==1){
                        allPrice = [kMeUnNilStr(_goodModel.psmodel.seckill_price) floatValue] * _goodModel.buynum  + [kMeUnNilStr(_goodModel.postage) floatValue];
                    }else{
                        if (_goodModel.isGroup) {
                            allPrice = [kMeUnNilStr(_goodModel.group_price) floatValue] * _goodModel.buynum + [kMeUnNilStr(_goodModel.postage) floatValue];
                        }else {
                            allPrice = [kMeUnNilStr(_goodModel.psmodel.goods_price) floatValue] * _goodModel.buynum + [kMeUnNilStr(_goodModel.postage) floatValue];
                        }
                    }
                }
            }
        }
        _lblAllPrice.text = [NSString stringWithFormat:@"%.2f",allPrice];
    }
}

- (void)initSomeThing {
    if(_isInteral){
        _arrType = @[@(MEMakrOrderCellDistribution),@(MEMakrOrderCellExhange),@(MEMakrOrderCellMessage)];
        CGFloat allBean = [kMeUnNilStr(_goodModel.psmodel.integral_lines) floatValue] * _goodModel.buynum;
        _lblAllPrice.text = [NSString stringWithFormat:@"%.2f美豆",allBean];
        _arrData = @[[NSString stringWithFormat:@"¥%@",kMeUnNilStr(_goodModel.postage)],[NSString stringWithFormat:@"%.2f美豆",allBean],@""];
    }else{
        CGFloat allPrice = 0;
        if (self.isReceivePrize) {
            _arrType = @[@(MEMakrOrderCellMessage),@(MEMakrOrderCellPostage)];
            allPrice = [kMeUnNilStr(_goodModel.postage) floatValue] + [kMeUnNilStr(_goodModel.psmodel.draw_price) floatValue] * _goodModel.buynum;
            _arrData = @[@""];
        }else {
            if (self.bargainId > 0) {
                _arrType = @[@(MEMakrOrderCellMessage),@(MEMakrOrderCellPreferential),@(MEMakrOrderCellPostage)];
                allPrice = [kMeUnNilStr(_goodModel.psmodel.goods_price) floatValue] * _goodModel.buynum - [kMeUnNilStr(self.reducePrice) floatValue] + [kMeUnNilStr(_goodModel.postage) floatValue];
                _arrData = @[@""];
            }else {
                if(self.isProctComd){
                    allPrice = [kMeUnNilStr(_goodModel.money) floatValue];
                }else{
                    if(_goodModel.is_seckill==1){
                        allPrice = [kMeUnNilStr(_goodModel.psmodel.seckill_price) floatValue] * _goodModel.buynum  + [kMeUnNilStr(_goodModel.postage) floatValue];
                    }else{
                        if (_goodModel.isGroup) {
                            allPrice = [kMeUnNilStr(_goodModel.group_price) floatValue] * _goodModel.buynum + [kMeUnNilStr(_goodModel.postage) floatValue];
                        }else {
                            allPrice = [kMeUnNilStr(_goodModel.psmodel.goods_price) floatValue] * _goodModel.buynum + [kMeUnNilStr(_goodModel.postage) floatValue];
                        }
                    }
                }
                if (_goodModel.product_type == 17) {
                    _arrType = @[@(MEMakrOrderCellMessage),@(MEMakrOrderCellPostage),@(MEMakrOrderCellPostage)];
                }else {
                    _arrType = @[@(MEMakrOrderCellMessage),@(MEMakrOrderCellPostage)];
                }
//                if (_goodModel.isGroup) {
//                    _arrType = @[@(MEMakrOrderCellMessage),@(MEMakrOrderCellPostage)];
//                }
                if ([self->_goodModel.skus containsString:@"到店领取"]) {
                    NSString *msg = [NSString stringWithFormat:@"%@ %@",kMeUnNilStr(kCurrentUser.name),kMeUnNilStr(kCurrentUser.mobile)];
                    _arrData = @[msg];
                }else {
                    _arrData = @[@""];
                }
            }
        }
        _lblAllPrice.text = [NSString stringWithFormat:@"%.2f",allPrice];
    }
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMakeOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMakeOrderCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMakeOrderHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMakeOrderHeaderCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPreferentialCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPreferentialCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    if(_hasAdress){
        self.sAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEMakeOrderSelectAddressView getViewHeightWithModel:_addressModel]);
        [self.sAddressView setUIWithModel:_addressModel];
        _tableView.tableHeaderView = self.sAddressView;
    }else{
        _tableView.tableHeaderView = self.notAddressView;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WechatSuccess:) name:WX_PAY_RESULT object:nil];
    [self getUserOrderFreightWithAddressId:[NSString stringWithFormat:@"%ld",(long)_addressModel.address_id] postage:_origainlPostage productId:[NSString stringWithFormat:@"%ld",(long)_goodModel.product_id]];
}

#pragma mark - UITableViewDelegate
#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrType.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath.row){
        MEMakeOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMakeOrderHeaderCell class]) forIndexPath:indexPath];
        [cell setUIWithModle:_goodModel isComb:self.isProctComd isInteral:_isInteral];
        return cell;
    }else{
        if (self.isReceivePrize) {
            if (indexPath.row == 2) {
                MEPreferentialCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPreferentialCell class]) forIndexPath:indexPath];
                [cell setTitle:@"邮费" amount:[NSString stringWithFormat:@"%@",kMeUnNilStr(_goodModel.postage)]];
                return cell;
            }
        }
        if (self.bargainId > 0) {
            if (indexPath.row == 2) {
                MEPreferentialCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPreferentialCell class]) forIndexPath:indexPath];
                [cell setAmount:[NSString stringWithFormat:@"%.2f",[kMeUnNilStr(self.reducePrice) floatValue]]];
                return cell;
            }else if (indexPath.row == 3) {
                MEPreferentialCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPreferentialCell class]) forIndexPath:indexPath];
                [cell setTitle:@"邮费" amount:[NSString stringWithFormat:@"%@",kMeUnNilStr(_goodModel.postage)]];
                return cell;
            }
        }
        if (indexPath.row == 2) {
            MEPreferentialCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPreferentialCell class]) forIndexPath:indexPath];
            [cell setTitle:@"邮费" amount:[NSString stringWithFormat:@"%@",kMeUnNilStr(_goodModel.postage)]];
            return cell;
        }
        if (_goodModel.product_type == 17 && indexPath.row == 3) {
            MEMakeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMakeOrderCell class]) forIndexPath:indexPath];
            [cell setGirlNumberUIWithTitle:@"女神卡号"];
            kMeWEAKSELF
            cell.messageBlock = ^(NSString *str) {
                NSLog(@"%@",str);
                kMeSTRONGSELF
                strongSelf->_girlNumber = str;
            };
            cell.returnBlock = ^{
                kMeSTRONGSELF
                [strongSelf.view endEditing:YES];
            };
            return cell;
        }
        // -1 是第一个给详情cell
        MEMakrOrderCellStyle type = [_arrType[indexPath.row-1] integerValue];
        MEMakeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMakeOrderCell class]) forIndexPath:indexPath];
        NSString *data = _arrData[indexPath.row-1];
        [cell setUIWithType:type model:data];
        if(type == MEMakrOrderCellMessage){
            kMeWEAKSELF
            cell.messageBlock = ^(NSString *str) {
                NSLog(@"%@",str);
                kMeSTRONGSELF
                strongSelf->_strMeaasge = str;
            };
            cell.returnBlock = ^{
                kMeSTRONGSELF
                [strongSelf.view endEditing:YES];
            };
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row?kMEMakeOrderCellHeight:kMEMakeOrderHeaderCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
            if(strongSelf->_isInteral){
                MEMineExchangeDetailVC *vc = (MEMineExchangeDetailVC *)[MECommonTool getClassWtihClassName:[MEMineExchangeDetailVC class] targetVC:strongSelf];
                if(vc){
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }else{
                    [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                }
            }else{
                if (strongSelf->_goodModel.isGroup) {
                    MEGroupProductDetailVC *vc = (MEGroupProductDetailVC *)[MECommonTool getClassWtihClassName:[MEGroupProductDetailVC class] targetVC:strongSelf];
                    if(vc){
                        [strongSelf.navigationController popToViewController:vc animated:YES];
                    }else{
                        [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kGroupOrderReload object:nil userInfo:@{@"order_sn":strongSelf->_order_sn}];
                    });
                }else {
                    METhridProductDetailsVC *vc = (METhridProductDetailsVC *)[MECommonTool getClassWtihClassName:[METhridProductDetailsVC class] targetVC:strongSelf];
                    if(vc){
                        [strongSelf.navigationController popToViewController:vc animated:YES];
                    }else{
                        [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                    }
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
                [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(self->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                    CGFloat f = [strongSelf->_goodModel.money floatValue] * (strongSelf->_goodModel.buynum) + [kMeUnNilStr(strongSelf->_goodModel.postage) floatValue];
                    BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:@(f).description];
                    if(!isSucess){
                        [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                    }
                } failure:^(id object) {

                }];
            } CheckOrderBlock:^{
                kMeSTRONGSELF
                if (strongSelf->_goodModel.isGroup) {
                    MEGroupOrderDetailVC *vc = [[MEGroupOrderDetailVC alloc] initWithOrderSn:kMeUnNilStr(strongSelf->_order_sn)];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }else {
                    MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:MEAllNeedPayOrder orderGoodsSn:kMeUnNilStr(strongSelf->_order_sn)];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
            [self.navigationController pushViewController:svc animated:YES];
        }
        NSLog(@"支付失败");
        _isPayError = YES;
    }
}
 
#pragma mark - Private
- (void)selectAddress{
    if ([self->_goodModel.skus containsString:@"到店领取"]) {
        return;
    }
    MESelectAddressVC *vc = [[MESelectAddressVC alloc]init];
    kMeWEAKSELF
    vc.selectModelBlock = ^(MEAddressModel *addressModel) {
        kMeSTRONGSELF
        strongSelf->_addressModel = addressModel;
        strongSelf->_hasAdress = YES;
        strongSelf.sAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEMakeOrderSelectAddressView getViewHeightWithModel:strongSelf->_addressModel]);
        [strongSelf.sAddressView setUIWithModel:strongSelf->_addressModel];
        strongSelf->_tableView.tableHeaderView = strongSelf.sAddressView;
        [strongSelf getUserOrderFreightWithAddressId:[NSString stringWithFormat:@"%ld",(long)addressModel.address_id] postage:strongSelf->_origainlPostage productId:[NSString stringWithFormat:@"%ld",(long)strongSelf->_goodModel.product_id]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectAddress:(UITapGestureRecognizer *)ges{
    [self selectAddress];
}

- (IBAction)toPay:(UIButton *)sender {
    if(!_hasAdress){
        [MEShowViewTool showMessage:@"请先选择地址" view:self.view];
        return;
    }
    
    MEMakeOrderAttrModel *model = [[MEMakeOrderAttrModel alloc]initWithGoodDetailModel:_goodModel];
    model.remark = kMeUnNilStr(_strMeaasge);
    model.user_address = @(_addressModel.address_id).description;
    if (model.share_id.length <= 0) {
        model.share_id = @"0";
    }
    
    if (self.bargainId > 0) {//砍价
        model.bargin_id = [NSString stringWithFormat:@"%ld",(long)self.bargainId];
        model.order_type = @"13";
        kMeWEAKSELF
        [MEPublicNetWorkTool postCreateBargainOrderWithAttrModel:model successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_order_sn = responseObject.data[@"order_sn"];
            NSString *postageStr = responseObject.data[@"order_amount"];
            CGFloat postage = [postageStr floatValue];
            if(postage<=0){
                MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
                    kNoticeReloadBargainOrder
                    METhridProductDetailsVC *vc = (METhridProductDetailsVC *)[MECommonTool getClassWtihClassName:[METhridProductDetailsVC class] targetVC:strongSelf];
                    if(vc){
                        [strongSelf.navigationController popToViewController:vc animated:YES];
                    }else{
                        [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                    }
                }];
                [strongSelf.navigationController pushViewController:svc animated:YES];
            }else{
                [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(strongSelf->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    PAYPRE
                    strongSelf->_isPayError= NO;
                    MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                    CGFloat f = [strongSelf->_goodModel.money floatValue] * (strongSelf->_goodModel.buynum) + [kMeUnNilStr(strongSelf->_goodModel.postage) floatValue];
                    BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:@(f).description];
                    if(!isSucess){
                        [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                    }else {
                        kNoticeReloadBargainOrder
                    }
                } failure:^(id object) {
                    
                }];
            }
        } failure:^(id object) {
            //下单
        }];
    }else {
        if (self.isReceivePrize) {//抽奖
            model.activity_id = self.activity_id;
            model.order_type = @"14";
            kMeWEAKSELF
            [MEPublicNetWorkTool postCreatePrizeOrderWithAttrModel:model successBlock:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                strongSelf->_order_sn = responseObject.data[@"order_sn"];
                NSString *postageStr = responseObject.data[@"order_amount"];
                CGFloat postage = [postageStr floatValue];
                if(postage<=0){
                    MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
                        kNoticeReloadPrizeOrder
                        METhridProductDetailsVC *vc = (METhridProductDetailsVC *)[MECommonTool getClassWtihClassName:[METhridProductDetailsVC class] targetVC:strongSelf];
                        if(vc){
                            [strongSelf.navigationController popToViewController:vc animated:YES];
                        }else{
                            [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                        }
                    }];
                    [strongSelf.navigationController pushViewController:svc animated:YES];
                }else{
                    [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(strongSelf->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        PAYPRE
                        strongSelf->_isPayError= NO;
                        MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                        CGFloat f = [strongSelf->_goodModel.money floatValue] * (strongSelf->_goodModel.buynum) + [kMeUnNilStr(strongSelf->_goodModel.postage) floatValue];
                        BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:@(f).description];
                        if(!isSucess){
                            [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                        }else {
                            kNoticeReloadPrizeOrder
                        }
                    } failure:^(id object) {
                        
                    }];
                }
            } failure:^(id object) {
                //下单
            }];
        }else {
            if(_isInteral){//积分兑换
                //积分
                model.order_type = @"4";
                //有运费需要支付
                kMeWEAKSELF
                [MEPublicNetWorkTool postCreateServiceOrderWithAttrModel:model successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    strongSelf->_order_sn = responseObject.data[@"order_sn"];
                    NSString *postageStr = responseObject.data[@"order_amount"];
                    CGFloat postage = [postageStr floatValue];
                    if(postage<=0){
                        strongSelf->_isPayError= NO;
                        MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
                            if(strongSelf->_isInteral){
                                MEMineExchangeDetailVC *vc = (MEMineExchangeDetailVC *)[MECommonTool getClassWtihClassName:[MEMineExchangeDetailVC class] targetVC:strongSelf];
                                if(vc){
                                    [strongSelf.navigationController popToViewController:vc animated:YES];
                                }else{
                                    [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                                }
                            }else{
                                METhridProductDetailsVC *vc = (METhridProductDetailsVC *)[MECommonTool getClassWtihClassName:[METhridProductDetailsVC class] targetVC:strongSelf];
                                if(vc){
                                    [strongSelf.navigationController popToViewController:vc animated:YES];
                                }else{
                                    [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                                }
                            }
                        }];
                        [strongSelf.navigationController pushViewController:svc animated:YES];
                    }else{
                        [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(strongSelf->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
                            kMeSTRONGSELF
                            PAYPRE
                            strongSelf->_isPayError= NO;
                            MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                            //CGFloat f = [strongSelf->_goodModel.money floatValue] * (strongSelf->_goodModel.buynum);
                            BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:@(postage).description];
                            if(!isSucess){
                                [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                            }
                        } failure:^(id object) {
                            
                        }];
                    }
                } failure:^(id object) {
                    //下单
                }];
            }else{
                kMeWEAKSELF
                if (_goodModel.isGroup > 0) {//拼团
                    model.order_type = @"7";
                    kMeWEAKSELF
                    [MEPublicNetWorkTool postCreateGroupOrderWithAttrModel:model successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        strongSelf->_order_sn = responseObject.data[@"order_sn"];
                        NSString *postageStr = responseObject.data[@"order_amount"];
                        CGFloat postage = [postageStr floatValue];
                        if(postage<=0){
                            MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
                                MEGroupProductDetailVC *vc = (MEGroupProductDetailVC *)[MECommonTool getClassWtihClassName:[MEGroupProductDetailVC class] targetVC:strongSelf];
                                if(vc){
                                    [strongSelf.navigationController popToViewController:vc animated:YES];
                                }else{
                                    [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                                }
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kGroupOrderReload object:nil userInfo:@{@"order_sn":strongSelf->_order_sn}];
                                });
                            }];
                            [strongSelf.navigationController pushViewController:svc animated:YES];
                        }else{
                            [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(strongSelf->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
                                kMeSTRONGSELF
                                PAYPRE
                                strongSelf->_isPayError= NO;
                                MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                                CGFloat f = [strongSelf->_goodModel.group_price floatValue] * (strongSelf->_goodModel.buynum) +[kMeUnNilStr(strongSelf->_goodModel.postage) floatValue];
                                BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:@(f).description];
                                if(!isSucess){
                                    [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                                }
                            } failure:^(id object) {
                                
                            }];
                        }
                    } failure:^(id object) {
                        //下单
                    }];
                }else {
                    model.order_type = _goodModel.is_seckill==1? @"9":@"1";
                    if(_goodModel.product_type == 15){
                        model.order_type = @"15";
                    }
                    if(_goodModel.product_type == 16){
                        model.order_type = @"16";
                    }
                    if(_goodModel.product_type == 17){
                        model.order_type = @"17";
                        if (_girlNumber.length<= 0) {
                            [MECommonTool showMessage:@"请填写女神卡号码" view:kMeCurrentWindow];
                            return;
                        }else {
                            if (_girlNumber.length < 11) {
                                [MECommonTool showMessage:@"女神卡号格式不正确" view:kMeCurrentWindow];
                                return;
                            }else {
                                model.girl_number = _girlNumber;
                            }
                        }
                    }
                    if ([self->_goodModel.skus containsString:@"到店领取"]) {
                        model.is_store_get = 1;
                    }
                    
                    model.uid = kMeUnNilStr(self.uid);
                    [MEPublicNetWorkTool postCreateOrderWithAttrModel:model successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        strongSelf->_order_sn = responseObject.data[@"order_sn"];
                        [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(strongSelf->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
                            kMeSTRONGSELF
                            PAYPRE
                            strongSelf->_isPayError= NO;
                            MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                            CGFloat f = [strongSelf->_goodModel.money floatValue] * (strongSelf->_goodModel.buynum) +[kMeUnNilStr(strongSelf->_goodModel.postage) floatValue];
                            BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:@(f).description];
                            if(!isSucess){
                                [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                            }
                        } failure:^(id object) {
                            
                        }];
                    } failure:^(id object) {
                        
                    }];
                }
            }
        }
    }
}

#pragma mark - Getter
- (MEMakeOrderSelectAddressView *)sAddressView{
    if(!_sAddressView){
        _sAddressView = [[[NSBundle mainBundle]loadNibNamed:@"MEMakeOrderSelectAddressView" owner:nil options:nil] lastObject];
        _sAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEMakeOrderSelectAddressViewHeight);
        kMeWEAKSELF
        _sAddressView.selectAddressBlock = ^{
            kMeSTRONGSELF
            [strongSelf selectAddress];
        };
    }
    return _sAddressView;
}
- (UIView *)notAddressView{
    if(!_notAddressView){
        _notAddressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEMakeOrderSelectAddressViewHeight)];
        
        UIImageView *img = [[UIImageView alloc]initWithImage:kMeGetAssetImage(@"inco-yytmtmda")];
        [_notAddressView addSubview:img];
        kMeWEAKSELF
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            kMeSTRONGSELF
            make.right.equalTo(strongSelf->_notAddressView).offset(-15);
            make.width.equalTo(@(7));
            make.height.equalTo(@(13));
            make.centerY.equalTo(strongSelf->_notAddressView);
        }];
        UILabel *lbl = [[UILabel alloc]init];
        [_notAddressView addSubview:lbl];
        lbl.text = @"请填写您的地址信息";
        lbl.font = kMeFont(15);
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            kMeSTRONGSELF
            make.right.equalTo(img).offset(-15);
            make.left.equalTo(strongSelf->_notAddressView).offset(15);
            make.centerY.equalTo(strongSelf->_notAddressView);
        }];
        _notAddressView.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress:)];
        [_notAddressView addGestureRecognizer:ges];
    }
    return _notAddressView;
}

#pragma mark - Setter

@end
