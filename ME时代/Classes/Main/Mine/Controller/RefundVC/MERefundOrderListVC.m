//
//  MERefundOrderListVC.m
//  志愿星
//
//  Created by gao lei on 2019/5/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERefundOrderListVC.h"
#import "MEOrderCell.h"
#import "MEMyOrderDetailVC.h"
#import "MERefundModel.h"
#import "MERefundDetailVC.h"

@interface MERefundOrderListVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MERefundOrderListVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退款/售后";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    kOrderReload
}

- (NSDictionary *)requestParameter{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MERefundModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderCell class]) forIndexPath:indexPath];
    MERefundModel *model = self.refresh.arrData[indexPath.row];
    kMeWEAKSELF
    cell.touchBlock = ^{
        kMeSTRONGSELF
        MERefundDetailVC *vc = [[MERefundDetailVC alloc] initWithOrderRefundSn:model.refund_sn];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    [cell setUIWithRefundModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MERefundModel *model = self.refresh.arrData[indexPath.row];
    return [MEOrderCell getCellHeightWithRefundModel:model];
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOrderCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPCommonOrderRefundList)];
        _refresh.isDataInside = YES;
        _refresh.isGet = NO;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有订单";
        }];
    }
    return _refresh;
}

@end
