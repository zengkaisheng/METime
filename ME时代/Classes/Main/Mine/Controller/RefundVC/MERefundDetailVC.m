//
//  MERefundDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/5/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERefundDetailVC.h"
#import "MERefundDetailModel.h"
#import "MERefundDetailHeaderView.h"
#import "MEOrderDetailContentCell.h"
#import "MEMyOrderDetailCell.h"

@interface MERefundDetailVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_orderRefundSn;
    MERefundDetailModel *_detailModel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MERefundDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation MERefundDetailVC

- (instancetype)initWithOrderRefundSn:(NSString *)orderRefundSn{
    if(self = [super init]){
        _orderRefundSn = orderRefundSn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退款详情";
    [self loadData];
}

- (void)loadData {
    kMeWEAKSELF
    [MEPublicNetWorkTool postRefundOrderDetailWithRefund_sn:_orderRefundSn successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_detailModel = [MERefundDetailModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf.arrData addObject:[NSString stringWithFormat:@"退款原因：%@",kMeUnNilStr(strongSelf->_detailModel.desc)]];
        [strongSelf.arrData addObject:[NSString stringWithFormat:@"退款金额：￥%.2f",[kMeUnNilStr(strongSelf->_detailModel.refund_money) floatValue]]];
        [strongSelf.arrData addObject:[NSString stringWithFormat:@"申请件数： %ld",kMeUnArr(strongSelf->_detailModel.order_goods).count]];
        [strongSelf.arrData addObject:[NSString stringWithFormat:@"申请时间：%@",kMeUnNilStr(strongSelf->_detailModel.created_at)]];
        [strongSelf.arrData addObject:[NSString stringWithFormat:@"退款编号：%@",kMeUnNilStr(strongSelf->_detailModel.refund_sn)]];
        [strongSelf.view addSubview:strongSelf.tableView];
        strongSelf.tableView.tableHeaderView = strongSelf.headerView;
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
    }];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return kMeUnArr(_detailModel.order_goods).count;
    }
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MEOrderDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderDetailContentCell class]) forIndexPath:indexPath];
        cell.backgroundColor = kMEeeeeee;
        MEOrderGoodModel *orderModel = kMeUnArr(_detailModel.order_goods)[indexPath.row];
        cell.isRefundDetail = YES;
        [cell setUIWithChildModel:orderModel];
        return cell;
    }
    MEMyOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyOrderDetailCell class]) forIndexPath:indexPath];
    ;
    [cell setUIWithRefundDetail:self.arrData[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 98;
    }
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        topView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 14)];
        titleLbl.text = @"退款信息";
        titleLbl.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [topView addSubview:titleLbl];
        return topView;
    }
    return nil;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight - 49) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOrderDetailContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOrderDetailContentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyOrderDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyOrderDetailCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MERefundDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MERefundDetailHeaderView" owner:nil options:nil] lastObject];
        [_headerView setUIWithModel:_detailModel];
        if (_detailModel.refund_status == 1 || _detailModel.refund_status == 3) {
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 168);
        }else {
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 202);
        }
    }
    return _headerView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
    }
    return _arrData;
}

@end

