//
//  MELianTongCommissionVC.m
//  ME时代
//
//  Created by gao lei on 2019/9/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MELianTongCommissionVC.h"
#import "MECouponOrderCell.h"
#import "MECouponOrderHeaderView.h"
#import "MECouponDetailModel.h"
#import "MEWithdrawalVC.h"
#import "MEOrderModel.h"
#import "MEGetCaseMainSVC.h"

@interface MELianTongCommissionVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    MECouponDetailModel *_modeldatil;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) MECouponOrderHeaderView         *headerView;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation MELianTongCommissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联通兑换明细";
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)rightBtnAction {
    MEGetCaseMainSVC *vc = [[MEGetCaseMainSVC alloc] initWithType:MEGetCaseAllStyle isLianTong:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestNet];
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)requestNet{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetLianTongBrokerageDetailWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if(strongSelf){
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                strongSelf->_modeldatil = [MECouponDetailModel mj_objectWithKeyValues:responseObject.data];
                [strongSelf->_headerView setLianTongUIWithModdel:strongSelf->_modeldatil];
            }
        }
    } failure:^(id object) {
    }];
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEOrderModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECouponOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECouponOrderCell class]) forIndexPath:indexPath];
    MEOrderModel *model = self.refresh.arrData[indexPath.row];
    MEOrderGoodModel *goodModel = kMeUnArr(model.children).firstObject;
    [cell setLianTongUIWithModel:goodModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMECouponOrderCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 58, 37)];
    titleLbl.text = @"联通";
    titleLbl.textColor = kMEPink;
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLbl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 36, 58, 1)];
    line.backgroundColor = kMEPink;
    [headerView addSubview:line];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECouponOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECouponOrderCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kMEededed;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonOrderGetStoreLianTongOrder)];
        _refresh.delegate = self;
        _refresh.showMaskView = YES;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.top = failView.top+37;
            failView.backgroundColor = kMEededed;
            failView.lblOfNodata.text = @"没有订单";
        }];
    }
    return _refresh;
}

- (MECouponOrderHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MECouponOrderHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, kMECouponOrderHeaderViewHeight);
        kMeWEAKSELF
        _headerView.block = ^{
            kMeSTRONGSELF
            MEWithdrawalVC *vc = [[MEWithdrawalVC alloc]initWithCouponMoney];
            vc.isLianTong = YES;
            vc.applySucessBlock = ^{
                kMeSTRONGSELF
                [strongSelf.refresh reload];
            };
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"提现记录" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.frame = CGRectMake(0, 0, 65, 44);
        _rightBtn.titleLabel.font = kMeFont(15);
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
