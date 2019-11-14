//
//  MELoveListContentVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MELoveListContentVC.h"
#import "MELoveListModel.h"
#import "MERecruitJoinUserListCell.h"

#import "MEVolunteerInfoVC.h"
#import "MEOrganizationDetailVC.h"

@interface MELoveListContentVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *dateType;

@end

@implementation MELoveListContentVC

- (instancetype)initWithType:(NSInteger)type dateType:(NSString *)dateType {
    if (self = [super init]) {
        self.type = type;
        self.dateType = dateType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark -- RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"type":@(self.type),
             @"date_type":kMeUnNilStr(self.dateType),
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MELoveListModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)reloadDatasWithType:(NSInteger)type {
    self.type = type;
    [self.refresh reload];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MERecruitJoinUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecruitJoinUserListCell class]) forIndexPath:indexPath];
    MELoveListModel *model = self.refresh.arrData[indexPath.row];
    [cell setLoveListUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MELoveListModel *model = self.refresh.arrData[indexPath.row];
    if (self.type == 1) {
        MEVolunteerInfoVC *vc = [[MEVolunteerInfoVC alloc] initWithVolunteerId:model.idField name:kMeUnNilStr(model.name)];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 2) {
        MEOrganizationDetailVC *vc = [[MEOrganizationDetailVC alloc] initWithOrganizationId:model.idField];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Set And Get
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERecruitJoinUserListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERecruitJoinUserListCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonSigninListOfLove)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无榜单信息";
        }];
    }
    return _refresh;
}

@end
