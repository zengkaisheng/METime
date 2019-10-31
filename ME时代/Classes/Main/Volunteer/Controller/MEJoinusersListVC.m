//
//  MEJoinusersListVC.m
//  ME时代
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEJoinusersListVC.h"
#import "MERecruitJoinUserListCell.h"
#import "MERecruitDetailModel.h"

@interface MEJoinusersListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, assign) NSInteger recruitId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MEJoinusersListVC

- (instancetype)initWithRecruitId:(NSInteger)recruitId {
    if (self = [super init]) {
        self.recruitId = recruitId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"已报名志愿者";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"id":@(self.recruitId)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MERecruitJoinUserModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MERecruitJoinUserModel *model = self.refresh.arrData[indexPath.row];
    MERecruitJoinUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecruitJoinUserListCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERecruitJoinUserListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERecruitJoinUserListCell class])];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonRecruitJoinUsersList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无报名人员";
        }];
    }
    return _refresh;
}

@end
