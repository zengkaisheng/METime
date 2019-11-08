//
//  MESignInActivityVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESignInActivityVC.h"
#import "MESignInActivityCell.h"
#import "MESignInActivityModel.h"
#import "MESginUpActivityInfoModel.h"

#import "MESignOutVC.h"
#import "MESignInTimerVC.h"
#import "MESignUpDetailVC.h"

@interface MESignInActivityVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MESignInActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"已签到的活动";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark -- RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MESignInActivityModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark -- Networking
//验证活动编码
- (void)checkSignInCodeWithCode:(NSString *)code {
    kMeWEAKSELF
    
    [MEPublicNetWorkTool postCheckSignInCodeWithCode:code successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            MESginUpActivityInfoModel *model = [MESginUpActivityInfoModel mj_objectWithKeyValues:responseObject.data];
            if (model.is_sign_in == 1) {
                if (model.member_info.status == 2) {//已签退
                    MESignOutVC *vc = [[MESignOutVC alloc] initWithModel:model];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }else {
                    MESignInTimerVC *vc = [[MESignInTimerVC alloc] initWithModel:model];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
            }else {
                MESignUpDetailVC *vc = [[MESignUpDetailVC alloc] initWithModel:model];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    } failure:^(id object) {
    }];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MESignInActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MESignInActivityCell class]) forIndexPath:indexPath];
    MESignInActivityModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 127;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MESignInActivityModel *model = self.refresh.arrData[indexPath.row];
    [self checkSignInCodeWithCode:kMeUnNilStr(model.signin_code)];
}


#pragma mark - Set And Get
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MESignInActivityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MESignInActivityCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonSigninSignInActivity)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无已签到的活动";
        }];
    }
    return _refresh;
}

@end
