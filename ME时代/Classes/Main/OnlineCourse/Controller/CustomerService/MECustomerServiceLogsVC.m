//
//  MECustomerServiceLogsVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerServiceLogsVC.h"
#import "MECustomerServiceContentCell.h"
#import "MECustomerServiceLogsModel.h"
#import "MEAddCustomerInfoModel.h"
#import "MEAddServiceVC.h"

@interface MECustomerServiceLogsVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
    NSInteger _filesId;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) MECustomerServiceLogsModel *logsModel;

@end

@implementation MECustomerServiceLogsVC

- (instancetype)initWithFilesId:(NSInteger)filesId{
    if (self = [super init]) {
        _filesId = filesId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"服务详情";
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    [self.view addSubview:self.footerView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"id":@(_filesId)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    }
    self.logsModel = [MECustomerServiceLogsModel mj_objectWithKeyValues:data];
    _type = self.logsModel.type;

    [self reloadServicesLogsDatas];
}

//服务数据组装
- (void)reloadServicesLogsDatas {
    if (self.refresh.arrData.count > 0) {
        [self.refresh.arrData removeAllObjects];
    }
    
    NSString *title = @"";
    
    MEAddCustomerInfoModel *projectModel = [self creatModelWithTitle:@"项目名称" andValue:kMeUnNilStr(self.logsModel.service_name)];
    
    MEAddCustomerInfoModel *totalModel = [self creatModelWithTitle:@"总次数" andValue:[NSString stringWithFormat:@"%@次",@(self.logsModel.total_num)]];
    if (_type == 1) {
        totalModel.title = @"总次数";
        title = @"次卡服务详情";
    }else if (_type == 2) {
        totalModel.title = @"开卡时间";
        totalModel.value = kMeUnNilStr(self.logsModel.open_card_time);
        title = @"时间卡服务详情";
    }else if (_type == 3) {
        totalModel.title = @"总服务次数";
        title = @"套盒产品服务详情";
    }
    MEAddCustomerInfoModel *residueModel = [self creatModelWithTitle:@"剩余次数" andValue:[NSString stringWithFormat:@"%@次",@(self.logsModel.residue_num)]];
    if (_type == 2) {
        residueModel.title = @"剩余时间";
        residueModel.value = kMeUnNilStr(self.logsModel.residue_time);
    }else {
        residueModel.title = @"剩余次数";
    }
    
    [self.refresh.arrData addObject:@{@"title":title,@"type":@"1",@"isHiddenHeaderV":@(YES),@"content":@[projectModel,totalModel,residueModel]}];
    
    NSMutableArray *logsArr = [[NSMutableArray alloc] init];
    for (MEServiceLogsDataModel *model in self.logsModel.logs.data) {
        NSArray *subArr = [self setupLogsSubListDatasWithModel:model];
        [logsArr addObject:subArr];
    }
    
    [self.refresh.arrData addObject:@{@"title":title,@"type":@"1",@"isLogs":@(YES),@"content":[logsArr mutableCopy]}];
    
    [self.tableView reloadData];
}

- (NSArray *)setupLogsSubListDatasWithModel:(MEServiceLogsDataModel *)model {
    MEAddCustomerInfoModel *comeModel = [self creatModelWithTitle:@"服务次数" andValue:[NSString stringWithFormat:@"%@次",@(model.come_in_count)]];
    
    MEAddCustomerInfoModel *timeModel = [self creatModelWithTitle:@"服务时间" andValue:kMeUnNilStr(model.service_time)];
    
    MEAddCustomerInfoModel *personModel = [self creatModelWithTitle:@"服务人员" andValue:kMeUnNilStr(model.member_name)];
    
    MEAddCustomerInfoModel *changeModel = [self creatModelWithTitle:@"改善情况" andValue:kMeUnNilStr(model.change)];
    
    MEAddCustomerInfoModel *checkModel = [self creatModelWithTitle:@"顾客确认" andValue:kMeUnNilStr(model.customer_check)];
    
    MEAddCustomerInfoModel *remarkModel = [self creatModelWithTitle:@"备注" andValue:kMeUnNilStr(model.remark)];
    
    return @[comeModel,timeModel,personModel,changeModel,checkModel,remarkModel];
}

- (MEAddCustomerInfoModel *)creatModelWithTitle:(NSString *)title andValue:(NSString *)value{
    MEAddCustomerInfoModel *model = [[MEAddCustomerInfoModel alloc]init];
    model.title = title;
    model.value = value;
    model.isTextField = NO;
    model.isHideArrow = YES;
    return model;
}

#pragma mark -- Action
- (void)bottomBtnAction {
    NSDictionary *info = self.refresh.arrData.firstObject;
    MEAddServiceVC *addVC = [[MEAddServiceVC alloc] initWithInfo:info filesId:self.logsModel.idField];
    kMeWEAKSELF
    addVC.finishBlock = ^(id object) {
       kMeSTRONGSELF
        [strongSelf.refresh reload];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerServiceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerServiceContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.refresh.arrData[indexPath.row];
    [cell setUIWithInfo:info];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.refresh.arrData[indexPath.row];
    return [MECustomerServiceContentCell getCellHeightWithInfo:info];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-70) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerServiceContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerServiceContentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCustomerServiceServiceLogs)];
        _refresh.delegate = self;
        _refresh.isDataInside = NO;
        _refresh.showMaskView = NO;
        _refresh.isServiceLogs = YES;
//        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
//            failView.backgroundColor = [UIColor whiteColor];
//            failView.lblOfNodata.text = @"暂无相关服务";
//        }];
    }
    return _refresh;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.bottomBtn];
    }
    return _footerView;
}

- (UIButton *)bottomBtn {
    if(!_bottomBtn){
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitle:@"添加服务记录" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_bottomBtn setBackgroundColor:kMEPink];
        _bottomBtn.frame = CGRectMake(40, 15, SCREEN_WIDTH-80, 40);
        _bottomBtn.layer.cornerRadius = 20.0;
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end
