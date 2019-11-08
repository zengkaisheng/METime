//
//  MESignUpActivityContentVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESignUpActivityContentVC.h"
#import "MEActivityRecruitListCell.h"
#import "MERecruitDetailVC.h"
#import "MERecruitListModel.h"

@interface MESignUpActivityContentVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@end

@implementation MESignUpActivityContentVC


- (instancetype)initWithType:(NSInteger)type latitude:(NSString *)latitude longitude:(NSString *)longitude{
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
    
    // Do any additional setup after loading the view.
}

#pragma mark -- RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"check_status":@(self.type),
             @"latitude":kMeUnNilStr(self.latitude),
             @"longitude":kMeUnNilStr(self.longitude)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MERecruitListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEActivityRecruitListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEActivityRecruitListCell class]) forIndexPath:indexPath];
    MERecruitListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 266;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MERecruitListModel *model = self.refresh.arrData[indexPath.row];
    MERecruitDetailVC *vc = [[MERecruitDetailVC alloc] initWithRecruitId:model.idField latitude:kMeUnNilStr(model.latitude) longitude:kMeUnNilStr(model.longitude)];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Set And Get
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonRecruitMyJoinActivity)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无已报名的活动";
        }];
    }
    return _refresh;
}

@end
