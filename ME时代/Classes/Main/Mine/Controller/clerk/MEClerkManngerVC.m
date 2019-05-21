//
//  MEClerkManngerVC.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEClerkManngerVC.h"
#import "MEClerkCell.h"
#import "MEClerkSearchVC.h"
#import "MENavigationVC.h"
#import "MEClerkSearchDataVC.h"
#import "MEAddClerksVC.h"
#import "MEClerkStatisticsVC.h"
#import "MEClerkModel.h"
#import "YBPopupMenu.h"
#import "MEClerksSortVC.h"
#import "MEClerkCouponMangerVC.h"

@interface MEClerkManngerVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate,YBPopupMenuDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MEClerkManngerVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSomeThing];
}

- (void)initSomeThing{
    self.title = @"店员管理";
    _consTopMargin.constant = kMeNavBarHeight;
    [_tableVIew registerNib:[UINib nibWithNibName:NSStringFromClass([MEClerkCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEClerkCell class])];
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableVIew.showsVerticalScrollIndicator = NO;
    _tableVIew.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
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
    MEClerkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEClerkCell class]) forIndexPath:indexPath];
    [cell setUIWIthModel:model];
    kMeWEAKSELF
    cell.moreBlock = ^{
        MECustomActionSheet *sheet = [[MECustomActionSheet alloc]initWithTitles:@[@"删除",@"查看店员佣金统计"]];
        sheet.blockBtnTapHandle = ^(NSInteger index){
            if(index){
                kMeSTRONGSELF
                MEClerkStatisticsVC *vc = [[MEClerkStatisticsVC alloc]initWithType:MEClientBTypeStyle memberId:model.member_id];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }else{
                MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除该员工?"];
                [aler addButtonWithTitle:@"确定" block:^{
                    [MEPublicNetWorkTool postClerkToMemberWithmemberId:kMeUnNilStr(model.member_id) successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        [strongSelf.refresh reload];
                    } failure:^(id object) {
                        
                    }];
                }];
                [aler addButtonWithTitle:@"取消"];
                [aler show];
            }
        };
        [sheet show];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEClerkCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEClerkModel *model = self.refresh.arrData[indexPath.row];
    MECustomActionSheet *sheet = [[MECustomActionSheet alloc]initWithTitles:@[@"删除",@"查看店员佣金统计"]];
    kMeWEAKSELF
    sheet.blockBtnTapHandle = ^(NSInteger index){
        if(index){
            kMeSTRONGSELF
            MEClerkStatisticsVC *vc = [[MEClerkStatisticsVC alloc]initWithType:MEClientBTypeStyle memberId:model.member_id];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }else{
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除该员工?"];
            [aler addButtonWithTitle:@"确定" block:^{
                [MEPublicNetWorkTool postClerkToMemberWithmemberId:kMeUnNilStr(model.member_id) successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    [strongSelf.refresh reload];
                } failure:^(id object) {
                    
                }];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
        }
    };
    [sheet show];
}

- (void)toAddClerk:(UIButton *)btn{
    kMeWEAKSELF
    [YBPopupMenu showRelyOnView:btn titles:@[@"添加店员",@"店员排名",@"店员优惠券分佣"] icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.borderWidth = 1;
        popupMenu.borderColor = kMEblack;
        kMeSTRONGSELF
        popupMenu.delegate = strongSelf;
    }];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if(index==0){
        MEAddClerksVC *vc = [[MEAddClerksVC alloc]init];
        kMeWEAKSELF
        vc.finishUpdatClerkBlock = ^{
            kMeSTRONGSELF
            [strongSelf.refresh reload];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        MEClerksSortVC *vc = [[MEClerksSortVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MEClerkCouponMangerVC *vc = [[MEClerkCouponMangerVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (IBAction)toSearchClerk:(UIButton *)sender {
//    MEClerkSearchVC *searchViewController = [MEClerkSearchVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索店员" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//        MEClerkSearchDataVC *dataVC = [[MEClerkSearchDataVC alloc]initWithKey:searchText];
//        [searchViewController.navigationController pushViewController:dataVC animated:YES];
//    }];
//    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
//    [self presentViewController:nav  animated:NO completion:nil];
//}


- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableVIew url:kGetApiWithUrl(MEIPcommonMyClerk)];
        _refresh.delegate = self;
        _refresh.isGet = YES;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有店员";
        }];
    }
    return _refresh;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-20, 0, 30, 25);
        [_btnRight setImage:[UIImage imageNamed:@"iglk"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(toAddClerk:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}


@end
