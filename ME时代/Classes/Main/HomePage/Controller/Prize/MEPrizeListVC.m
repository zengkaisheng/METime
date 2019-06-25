//
//  MEPrizeListVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPrizeListVC.h"
#import "MESignInListCell.h"
#import "MEPrizeListModel.h"
#import "MEJoinPrizeVC.h"

@interface MEPrizeListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSArray *_todayData;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MEPrizeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf6f6f6;
    self.title = @"抽奖活动";
    _todayData = [[NSArray alloc] init];
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    kPrizeReloadOrderReload
}

- (void)dealloc {
    kNSNotificationCenterDealloc
}

- (void)reloadList {
    [self.refresh reload];
}

- (void)requestNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetPrizeTodayDataWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf->_todayData = [MEPrizeListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        }else{
            strongSelf->_todayData = [[NSArray alloc] init];
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestNetWork];
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEPrizeListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark -- UITableviewDelegate  && UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_todayData.count == 0 && self.refresh.arrData.count == 0) {
        self.refresh.showFailView = YES;
    }else {
        self.refresh.showFailView = NO;
    }
    if (section == 0) {
        return _todayData.count;
    }
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MESignInListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MESignInListCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MEPrizeListModel *model;
    if (indexPath.section == 0) {
        model = _todayData[indexPath.row];
        [cell setUIWithModel:model];
    }else {
        model = self.refresh.arrData[indexPath.row];
        [cell setUIWithModel:model];
    }
    kMeWEAKSELF
    cell.tapBlock = ^{
        kMeSTRONGSELF
        MEJoinPrizeVC *vc = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.idField]];
        vc.finishBlock = ^{
            [strongSelf.refresh reload];
        };
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MEPrizeListModel *model;
    if (indexPath.section == 0) {
        model = _todayData[indexPath.row];
    }else {
        model = self.refresh.arrData[indexPath.row];
    }
    MEJoinPrizeVC *vc = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",model.idField]];
    kMeWEAKSELF
    vc.finishBlock = ^{
        kMeSTRONGSELF
        [strongSelf.refresh reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMESignInListCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_todayData.count <= 0) {
            return 0;
        }
    }else if (section == 1) {
        if (self.refresh.arrData.count <= 0) {
            return 0;
        }
    }
    return 78;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 78)];
    headerV.backgroundColor = kMEf6f6f6;
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, 80, 19)];
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:20];
    if (section == 0) {
        titleLbl.text = @"今日福利";
    }else if (section == 1) {
        titleLbl.text = @"往期福利";
    }
    [headerV addSubview:titleLbl];
    
    return headerV;
}

#pragma setter && getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MESignInListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MESignInListCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kMEf6f6f6;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPCommonPrizeHistory)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showFailView = YES;
//        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.lblOfNodata.text = @"敬请期待";
        }];
    }
    return _refresh;
}

@end
