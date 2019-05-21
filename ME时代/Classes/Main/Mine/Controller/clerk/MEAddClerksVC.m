//
//  MEAddClerksVC.m
//  ME时代
//
//  Created by hank on 2018/12/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAddClerksVC.h"
#import "MEAddClerkCell.h"
#import "ZLRefreshTool.h"
#import "MEClerkModel.h"
#import "MEClerkSearchVC.h"
#import "MENavigationVC.h"
#import "MEClerkSearchDataVC.h"

@interface MEAddClerksVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@end

@implementation MEAddClerksVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSomeThing];
}

- (void)initSomeThing{
    self.title = @"添加店员";
    _consTopMargin.constant = kMeNavBarHeight;
    [_tableVIew registerNib:[UINib nibWithNibName:NSStringFromClass([MEAddClerkCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAddClerkCell class])];
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableVIew.showsVerticalScrollIndicator = NO;
    _tableVIew.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    [self.refresh addRefreshView];
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEClerkModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEClerkModel *model = self.refresh.arrData[indexPath.row];
    MEAddClerkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAddClerkCell class]) forIndexPath:indexPath];
    [cell setUIWIthModel:model];
    kMeWEAKSELF
    cell.updateBlock = ^{
        MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定升级为该员工?"];
        [aler addButtonWithTitle:@"确定" block:^{
            [MEPublicNetWorkTool posMemberToClerkWithmemberId:kMeUnNilStr(model.member_id) successBlock:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                kMeCallBlock(strongSelf->_finishUpdatClerkBlock);
                [strongSelf.refresh reload];
            } failure:^(id object) {
                
            }];
        }];
        [aler addButtonWithTitle:@"取消"];
        [aler show];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEAddClerkCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)toSearchClerk:(UIButton *)sender {
    MEClerkSearchVC *searchViewController = [MEClerkSearchVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索会员" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        MEClerkSearchDataVC *dataVC = [[MEClerkSearchDataVC alloc]initWithKey:searchText];
        kMeWEAKSELF
        dataVC.finishUpdatClerkBlock = ^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf->_finishUpdatClerkBlock);
            [strongSelf.refresh reload];
        };
        [searchViewController.navigationController pushViewController:dataVC animated:YES];
    }];
    [searchViewController setSearchHistoriesCachePath:kMEClerkSearchVCSearchHistoriesCachePath];
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableVIew url:kGetApiWithUrl(MEIPcommonMemberList)];
        _refresh.isGet = YES;
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有会员";
        }];
    }
    return _refresh;
}




@end
