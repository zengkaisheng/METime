//
//  MECommunityServiceBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/10/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommunityServiceBaseVC.h"
#import "MECommunityServericeListModel.h"
#import "MECommunityServiceListCell.h"
#import "MECommunityServiceCell.h"
#import "MECommunityServiceDetailVC.h"

@interface MECommunityServiceBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, assign) NSInteger classifyId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, assign) CGFloat categoryHeight;

@end

@implementation MECommunityServiceBaseVC

- (instancetype)initWithClassifyId:(NSInteger)classifyId categoryHeight:(CGFloat)categoryHeight{
    if (self = [super init]) {
        _classifyId = classifyId;
        self.categoryHeight = categoryHeight;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = self.isHome;
    
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
    [self.refresh.arrData addObjectsFromArray:[MECommunityServericeListModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)reloadDatas {
    [self.refresh reload];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECommunityServericeListModel *model = self.refresh.arrData[indexPath.row];
    if (kMeUnArr(model.images).count > 1) {
        MECommunityServiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECommunityServiceListCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:model];
        return cell;
    }
    MECommunityServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECommunityServiceCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECommunityServericeListModel *model = self.refresh.arrData[indexPath.row];
    if (kMeUnArr(model.images).count > 1) {
        return kMECommunityServiceListCellHeight;
    }
    return kMECommunityServiceCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECommunityServericeListModel *model = self.refresh.arrData[indexPath.row];
    MECommunityServiceDetailVC *vc = [[MECommunityServiceDetailVC alloc] initWithServiceId:model.idField];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-self.categoryHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECommunityServiceListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECommunityServiceListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECommunityServiceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECommunityServiceCell class])];
        
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCommunityServericeGetList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关服务";
        }];
    }
    return _refresh;
}

@end
