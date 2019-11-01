//
//  MEGroupOrderDetailVC.m
//  志愿星
//
//  Created by gao lei on 2019/7/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupOrderDetailVC.h"
#import "MEGroupOrderDetailModel.h"
#import "MEGroupOrderDetailHeaderView.h"
#import "MEOrderDetailContentCell.h"
#import "MEMyOrderDetailCell.h"

#import "MEGroupOrderDetailsVC.h"

@interface MEGroupOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, strong) MEGroupOrderDetailModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEGroupOrderDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation MEGroupOrderDetailVC

- (instancetype)initWithOrderSn:(NSString *)orderSn {
    if (self = [super init]) {
        self.order_sn = orderSn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    [self requestNetWorkWithGroupOrderDetail];
}

#pragma mark -- networking
- (void)requestNetWorkWithGroupOrderDetail{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGroupOrderDetailWithOrderSn:kMeUnNilStr(self.order_sn) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEGroupOrderDetailModel mj_objectWithKeyValues:responseObject.data];
            if ([strongSelf.model.order_status isEqualToString:@"10"]) {
                [strongSelf.arrData addObject:@[@{@"title":@"拼团进行中",@"content":[NSString stringWithFormat:@"%ld",strongSelf.model.need_num],@"type":@"0"}]];
            }
            [strongSelf.arrData addObject:@[@{@"title":@"邮费",@"content":kMeUnNilStr(strongSelf.model.order_goods.freight),@"type":@"1"},
                                            @{@"title":@"订单金额",@"content":kMeUnNilStr(strongSelf.model.order_goods.all_amount),@"type":@"1"},
                                            @{@"title":@"实付金额",@"content":kMeUnNilStr(strongSelf.model.actual_money),@"type":@"1"}]];
            
            [strongSelf.arrData addObject:@[@{@"title":@"订单编号：",@"content":kMeUnNilStr(strongSelf.model.order_sn),@"type":@"2"},
                                            @{@"title":@"创建时间：",@"content":kMeUnNilStr(strongSelf.model.created_at),@"type":@"2"},
                                            @{@"title":@"付款时间：",@"content":kMeUnNilStr(strongSelf.model.updated_at),@"type":@"2"}]];
            if (strongSelf.model.order_status.intValue == 10) {
                [strongSelf.view addSubview:strongSelf.bottomView];
            }
            [strongSelf.view addSubview:strongSelf.tableView];
            strongSelf.tableView.tableHeaderView = strongSelf.headerView;
            [strongSelf.headerView setUIWithModel:strongSelf.model];
            [strongSelf.tableView reloadData];
        }else {
            strongSelf.model = nil;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)shareBtnDidClick {
    MEGroupOrderDetailsVC *shareVC = [[MEGroupOrderDetailsVC alloc] initWithOrderSn:self.model.order_sn];
    [self.navigationController pushViewController:shareVC animated:YES];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrData.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    NSArray *subArray = self.arrData[section-1];
    return subArray.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MEOrderDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderDetailContentCell class]) forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
        [cell setUIWithGroupModel:self.model];
        return cell;
    }
    MEMyOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyOrderDetailCell class]) forIndexPath:indexPath];
    ;
    NSArray *subArray = self.arrData[indexPath.section-1];
    NSDictionary *info = subArray[indexPath.row];
    [cell setGroupUIWithInfo:info];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 165;
    }
    NSArray *subArray = self.arrData[indexPath.section-1];
    NSDictionary *info = subArray[indexPath.row];
    if ([info[@"type"] intValue] == 0 || [info[@"type"] intValue] == 1) {
        return 43;
    }
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 1) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        header.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
        return header;
    }
    return nil;
}

#pragma mark -- setter && getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-(self.model.order_status.intValue==10?48:0)) style:UITableViewStylePlain];
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

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
    }
    return _arrData;
}
- (MEGroupOrderDetailHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEGroupOrderDetailHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 148);
    }
    return _headerView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 48, SCREEN_WIDTH, 48)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 48)];
        [shareBtn setTitle:@"邀请好友拼团" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shareBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF88A4"]];
        [shareBtn addTarget:self action:@selector(shareBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:shareBtn];
    }
    return _bottomView;
}

@end
