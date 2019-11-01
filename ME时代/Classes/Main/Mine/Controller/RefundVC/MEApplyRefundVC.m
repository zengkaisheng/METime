//
//  MEApplyRefundVC.m
//  志愿星
//
//  Created by gao lei on 2019/5/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEApplyRefundVC.h"
#import "MEOrderCell.h"
#import "MEMyOrderDetailVC.h"
#import "MEOrderModel.h"

#import "MEMyOrderDetailCell.h"
#import "MEOrderDetailContentCell.h"
#import "MEMakeOrderCell.h"
#import "MEOrderDetailModel.h"

@interface MEApplyRefundVC ()<UITableViewDelegate, UITableViewDataSource>
{
    MEOrderStyle _orderType;
    NSString *_orderGoodsSn;
    MEOrderDetailModel *_detaliModel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MERefundModel *model;
@property (nonatomic, copy) NSString *remindStr;
@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation MEApplyRefundVC

- (instancetype)initWithType:(MEOrderStyle)type orderGoodsSn:(NSString *)orderGoodsSn{
    if(self = [super init]){
        _orderType = type;
        _orderGoodsSn = orderGoodsSn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请退款";
    self.remindStr = @"";
//    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.bottomBtn];
    kMeWEAKSELF
    [MEPublicNetWorkTool getOrderDetailWithGoodSn:_orderGoodsSn successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_detaliModel = [MEOrderDetailModel mj_objectWithKeyValues:responseObject.data];
        strongSelf->_orderType = [strongSelf->_detaliModel.order_status integerValue];
        [strongSelf.view addSubview:strongSelf.tableView];
        [strongSelf.view addSubview:strongSelf.bottomBtn];
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)submitAction {
    if (!self.remindStr || self.remindStr.length <= 0) {
        MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"请填写退款原因"];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postApplyRefundWithOrder_sn:_detaliModel.order_sn order_goods_sn:nil desc:self.remindStr successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject isKindOfClass:[ZLRequestResponse class]]) {
            ZLRequestResponse *resp = (ZLRequestResponse *)responseObject;
            MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(resp.message)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } failure:^(id object) {
    }];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return kMeUnArr(_detaliModel.children).count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MEOrderDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderDetailContentCell class]) forIndexPath:indexPath];
        MEOrderGoodModel *orderModel = kMeUnArr(_detaliModel.children)[indexPath.row];
        cell.isApplyRefund = YES;
        [cell setUIWithChildModel:orderModel];
        return cell;
    }else if (indexPath.section == 1) {
        MEMakeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMakeOrderCell class]) forIndexPath:indexPath];
        [cell setUI];
        kMeWEAKSELF;
        cell.messageBlock = ^(NSString *str) {
            kMeSTRONGSELF
            strongSelf.remindStr = str;
        };
        cell.returnBlock = ^{
            kMeSTRONGSELF
            [strongSelf.view endEditing:YES];
            
        };
        return cell;
    } else {
        MEMyOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyOrderDetailCell class]) forIndexPath:indexPath];
        ;
        [cell setUIWithAmount:_detaliModel.order_amount];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 127;
    }else if (indexPath.section == 1) {
        return 70;
    }else {
        return 42;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat height;
    if (section == 0) {
        height = 2;
    }else {
        height = 10;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    headerView.backgroundColor = kMEfbfbfb;
    return headerView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight - 49) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOrderDetailContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOrderDetailContentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMakeOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMakeOrderCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyOrderDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyOrderDetailCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMEfbfbfb;
    }
    return _tableView;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        [_bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:kMEPink];
        [_bottomBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:18]];
        [_bottomBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end
