//
//  MECustomerFilesBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerFilesBaseVC.h"
#import "MECustomerFileListModel.h"
#import "MECustomerFilesListCell.h"
#import "MECustomerDetailVC.h"

@interface MECustomerFilesBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, assign) NSInteger classifyId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MECustomerFilesBaseVC

- (instancetype)initWithClassifyId:(NSInteger)classifyId {
    if (self = [super init]) {
        _classifyId = classifyId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"classify_id":@(self.classifyId)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECustomerFileListModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)reloadDatas {
    [self.refresh reload];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerFilesListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerFilesListCell class]) forIndexPath:indexPath];
    MECustomerFileListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMECustomerFilesListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerFileListModel *model = self.refresh.arrData[indexPath.row];
    MECustomerDetailVC *vc = [[MECustomerDetailVC alloc] initWithCustomerId:model.idField];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerFilesListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerFilesListCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCustomerFilesList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关信息";
        }];
    }
    return _refresh;
}

@end
