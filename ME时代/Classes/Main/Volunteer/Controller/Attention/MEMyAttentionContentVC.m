//
//  MEMyAttentionContentVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyAttentionContentVC.h"
#import "MEAttentionOrganizationCell.h"
#import "MEVolunteerInfoModel.h"
#import "MEAttentionOrganizationsModel.h"

#import "MEActivityRecruitListCell.h"
#import "MERecruitListModel.h"

#import "MEVolunteerInfoVC.h"
#import "MERecruitDetailVC.h"
#import "MEOrganizationDetailVC.h"

@interface MEMyAttentionContentVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@end

@implementation MEMyAttentionContentVC

- (instancetype)initWithType:(NSInteger)type latitude:(NSString *)latitude longitude:(NSString *)longitude {
    if (self = [super init]) {
        self.type = type;
        self.latitude = latitude;
        self.longitude = longitude;
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
             @"latitude":kMeUnNilStr(self.latitude),
             @"longitude":kMeUnNilStr(self.longitude)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if (self.type == 1) {
        [self.refresh.arrData addObjectsFromArray:[MERecruitListModel mj_objectArrayWithKeyValuesArray:data]];
    }else if (self.type == 2) {
        [self.refresh.arrData addObjectsFromArray:[MEVolunteerInfoModel mj_objectArrayWithKeyValuesArray:data]];
    }else if (self.type == 3) {
        [self.refresh.arrData addObjectsFromArray:[MEAttentionOrganizationsModel mj_objectArrayWithKeyValuesArray:data]];
    }
}
#pragma mark ---networking
- (void)cancelAttentionVolunteerWithIndex:(NSInteger)index {
    MEVolunteerInfoModel *model = self.refresh.arrData[index];
    kMeWEAKSELF
    [MEPublicNetWorkTool postAttentionVolunteerWithVolunteerId:model.member_id status:0 successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"取消关注成功" view:kMeCurrentWindow];
        [strongSelf.refresh.arrData removeObjectAtIndex:index];
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        [strongSelf.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(id object) {
    }];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        MEActivityRecruitListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEActivityRecruitListCell class]) forIndexPath:indexPath];
        MERecruitListModel *model = self.refresh.arrData[indexPath.row];
        [cell setUIWithModel:model];
        return cell;
    }
    MEAttentionOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAttentionOrganizationCell class]) forIndexPath:indexPath];
    if (self.type == 2) {
        MEVolunteerInfoModel *model = self.refresh.arrData[indexPath.row];
        [cell setVolunteerUIWithModel:model];
        kMeWEAKSELF
        cell.tapBlock = ^{
            kMeSTRONGSELF
            [strongSelf cancelAttentionVolunteerWithIndex:indexPath.row];
        };
    }else {
        MEAttentionOrganizationsModel *model = self.refresh.arrData[indexPath.row];
        [cell setOrganizationUIWithModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        return 266;
    }else if (self.type == 2) {
        return 86;
    }
    return 142;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        MERecruitListModel *model = self.refresh.arrData[indexPath.row];
        MERecruitDetailVC *vc = [[MERecruitDetailVC alloc] initWithRecruitId:model.idField latitude:kMeUnNilStr(model.latitude) longitude:kMeUnNilStr(model.longitude)];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 2) {
        MEVolunteerInfoModel *model = self.refresh.arrData[indexPath.row];
        MEVolunteerInfoVC *vc = [[MEVolunteerInfoVC alloc] initWithVolunteerId:model.member_id name:kMeUnNilStr(model.name)];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 3) {
        MEAttentionOrganizationsModel *model = self.refresh.arrData[indexPath.row];
        MEOrganizationDetailVC *vc = [[MEOrganizationDetailVC alloc] initWithOrganizationId:model.idField];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Set And Get
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAttentionOrganizationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAttentionOrganizationCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEActivityRecruitListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEActivityRecruitListCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonUserMyAttention)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无关注信息";
        }];
    }
    return _refresh;
}

@end
