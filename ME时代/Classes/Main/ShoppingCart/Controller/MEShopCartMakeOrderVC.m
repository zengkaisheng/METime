//
//  MEShopCartMakeOrderVC.m
//  ME时代
//
//  Created by hank on 2018/9/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShopCartMakeOrderVC.h"
#import "MEMakeOrderCell.h"
#import "MEMakeOrderSelectAddressView.h"
#import "MEMakeOrderHeaderCell.h"
#import "MESelectAddressVC.h"
#import "MEGoodDetailModel.h"
#import "MEAddressModel.h"
#import "MEMakeOrderAttrModel.h"
#import "MEShoppingCartModel.h"
#import "MEShoppingCartMakeOrderAttrModel.h"
#import "MEPayStatusVC.h"
#import "MEProductShoppingCartVC.h"
#import "MEGiftVC.h"
@interface MEShopCartMakeOrderVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _hasAdress;
    NSArray *_arrType;
    BOOL _isInteral;
    MEAddressModel *_addressModel;
    NSString *_strMeaasge;
    NSArray *_arrCartModel;
    NSString *_order_sn;
    BOOL _isPayError;//防止跳2次错误页面
    //购物车有秒杀产品
    BOOL _isHasRush;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MEMakeOrderSelectAddressView *sAddressView;
@property (weak, nonatomic) IBOutlet UILabel *lblAllPrice;
@property (strong, nonatomic) UIView *notAddressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@end

@implementation MEShopCartMakeOrderVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (instancetype)initWithIsinteral:(BOOL)isInteral WithArrChartGood:(NSArray *)arrCartModel{
    if (self = [super init]){
        _isInteral = isInteral;
        _arrCartModel = arrCartModel;
        _isPayError= NO;
        _isHasRush = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生成订单";
    _topMargin.constant = kMeNavBarHeight;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)initSomeThing {
    if(self.isGift){
        _strMeaasge = self.giftMessage;
    }
    __block CGFloat p = 0;
    kMeWEAKSELF
    [_arrCartModel enumerateObjectsUsingBlock:^(MEShoppingCartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        kMeSTRONGSELF
       p += [obj.money floatValue] * obj.goods_num;
        if(obj.product_type == 9){
            strongSelf->_isHasRush = YES;
        }
    }];
    _lblAllPrice.text = [NSString stringWithFormat:@"%.2f",p];
//    CGFloat allPrice = [kMeUnNilStr(_goodModel.psmodel.goods_price) floatValue] * _goodModel.buynum;
//    _lblAllPrice.text = [NSString stringWithFormat:@"%.2f",allPrice];
    if(_isInteral){
        _arrType = @[@(MEMakrOrderCellMessage),@(MEMakrOrderCellExhange)];
    }else{
        _arrType = @[@(MEMakrOrderCellMessage)];
    }
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMakeOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMakeOrderCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMakeOrderHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMakeOrderHeaderCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    if(_hasAdress){
        self.sAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEMakeOrderSelectAddressView getViewHeightWithModel:_addressModel]);
        [self.sAddressView setUIWithModel:_addressModel];
        _tableView.tableHeaderView = self.sAddressView;
    }else{
        _tableView.tableHeaderView = self.notAddressView;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WechatSuccess:) name:WX_PAY_RESULT object:nil];
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
            if(self.isGift){
                MEGiftVC *vc = (MEGiftVC *)[MECommonTool getClassWtihClassName:[MEGiftVC class] targetVC:self];
                if(vc){
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }
            }else{
                MEProductShoppingCartVC *vc = (MEProductShoppingCartVC *)[MECommonTool getClassWtihClassName:[MEProductShoppingCartVC class] targetVC:self];
                if(vc){
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
        kMeCallBlock(_PayFinishBlock);
        [self.navigationController pushViewController:svc animated:YES];
        NSLog(@"支付成功");
        _isPayError = NO;
    }else{
        if(!_isPayError){
            MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithFailRePayBlock:^{
                [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(self->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    PAYPRE
                    MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                    BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_lblAllPrice.text];
                    if(!isSucess){
                        [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                    }
                } failure:^(id object) {
                    
                }];
            } CheckOrderBlock:^{
//                kMeSTRONGSELF
//                MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:MEAllNeedPayOrder orderGoodsSn:kMeUnNilStr(strongSelf->_order_sn)];
//                [strongSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            [self.navigationController pushViewController:svc animated:YES];
        }
        NSLog(@"支付失败");
        kMeCallBlock(_PayFinishBlock);
        _isPayError = YES;
    }
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section){
        return _arrType.count;
    }else{
        return _arrCartModel.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath.section){
        MEMakeOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMakeOrderHeaderCell class]) forIndexPath:indexPath];
        MEShoppingCartModel *model = _arrCartModel[indexPath.row];
        [cell setShopCartUIWithModle:model];
//        [cell setUIWithModle:_goodModel];
        return cell;
    }else{
        MEMakrOrderCellStyle type = [_arrType[indexPath.row] integerValue];
        MEMakeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMakeOrderCell class]) forIndexPath:indexPath];
        if(type == MEMakrOrderCellMessage){
            [cell setUIWithType:type model:kMeUnNilStr(_strMeaasge)];
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
        }else{
            [cell setUIWithType:type model:@""];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section?kMEMakeOrderCellHeight:kMEMakeOrderHeaderCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Public

#pragma mark - Private

- (void)selectAddress{
    MESelectAddressVC *vc = [[MESelectAddressVC alloc]init];
    kMeWEAKSELF
    vc.selectModelBlock = ^(MEAddressModel *addressModel) {
        kMeSTRONGSELF
        strongSelf->_addressModel = addressModel;
        strongSelf->_hasAdress = YES;
        strongSelf.sAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEMakeOrderSelectAddressView getViewHeightWithModel:strongSelf->_addressModel]);
        [strongSelf.sAddressView setUIWithModel:strongSelf->_addressModel];
        strongSelf->_tableView.tableHeaderView = strongSelf.sAddressView;
        [self.navigationController popViewControllerAnimated:YES];
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
    MEShoppingCartMakeOrderAttrModel *model = [[MEShoppingCartMakeOrderAttrModel alloc]init];
    kMeWEAKSELF
    NSMutableArray *arrShopCartId = [NSMutableArray array];
    [_arrCartModel enumerateObjectsUsingBlock:^(MEShoppingCartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrShopCartId addObject:@(obj.product_cart_id).description];
    }];
    NSString *str = [arrShopCartId componentsJoinedByString:@","];
    model.remark = kMeUnNilStr(_strMeaasge);
    model.user_address = [NSString stringWithFormat:@"%@",@(_addressModel.address_id)];
    model.cart_id = str;
    if(_isHasRush){
        model.order_type = @"9";
    }
    [MEPublicNetWorkTool postCreateShopOrderWithAttrModel:model  successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_order_sn = responseObject.data[@"order_sn"];
        [MEPublicNetWorkTool postPayOrderWithOrder_sn:kMeUnNilStr(strongSelf->_order_sn) successBlock:^(ZLRequestResponse *responseObject) {
            PAYPRE
            strongSelf->_isPayError= NO;
            if(strongSelf.isGift){
                kNoticeReloadShopCart
            }
            MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
            BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_lblAllPrice.text];
            if(!isSucess){
                [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
            }
        } failure:^(id object) {
            
        }];
    } failure:^(id object) {

    }];
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
