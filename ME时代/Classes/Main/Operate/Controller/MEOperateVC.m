//
//  MEOperateVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOperateVC.h"
#import "MEOperateDataModel.h"
#import "MEOnlineToolsCell.h"
#import "MEOperationContentCell.h"
#import "MEOperationClerkRankModel.h"
#import "MEOperationObjectRankModel.h"

#import "MECustomerFilesVC.h"
#import "MECustomerServiceVC.h"
#import "MECustomerAppointmentVC.h"
#import "MECustomerConsumeVC.h"
#import "MEOperationTotalListVC.h"
#import "MERankListVC.h"

@interface MEOperateVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) MEOperateDataModel *model;
@property (nonatomic, strong) NSMutableArray *clerkRanks;
@property (nonatomic, strong) NSMutableArray *objectRanks;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MEOperateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"运营";
//    if (self.isShowTop) {
        self.title = @"运营工具";
//    self.isShowTop = YES;
//    }
    self.index = 1;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    
    MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideAnimated:YES];
    });
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    }
    self.model = [MEOperateDataModel mj_objectWithKeyValues:data];
    [self getClerkRankingDatasAndGetObjectRankDatas:YES];
}

- (void)reloadOperationDatas {
    if (self.refresh.arrData.count > 0) {
        [self.refresh.arrData removeAllObjects];
    }
    
    [self.refresh.arrData addObject:@{@"title":@"本月业绩统计",@"type":@"1",@"content":@[self.model.this_month]}];
    [self.refresh.arrData addObject:@{@"title":@"累计业绩统计",@"type":@"2",@"content":@[self.model.total]}];
    [self.refresh.arrData addObject:@{@"title":@"顾客预约",@"type":@"3",@"content":@[self.model.appointment]}];
    [self.refresh.arrData addObject:@{@"title":@"员工排名",@"type":@"4",@"index":@(self.index-1),@"content":[self.clerkRanks copy]}];
    [self.refresh.arrData addObject:@{@"title":@"服务项目排名",@"type":@"5",@"content":[self.objectRanks copy]}];
    [self.tableView reloadData];
}

#pragma mark -- Networking
//员工排名
- (void)getClerkRankingDatasAndGetObjectRankDatas:(BOOL)isGet {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetClerkRankingDatasWithType:self.index successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            NSDictionary *data = responseObject.data;
            if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                strongSelf.clerkRanks = [MEOperationClerkRankModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            }
        }
        if (isGet) {
            [strongSelf getObjectRankingDatas];
        }else {
            [strongSelf reloadOperationDatas];
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.model = nil;
    }];
}
//服务项目排名
- (void)getObjectRankingDatas {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetObjectRankingDatasWithDateType:self.index successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            NSDictionary *data = responseObject.data;
            if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                strongSelf.objectRanks = [MEOperationObjectRankModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            }
        }
        [strongSelf reloadOperationDatas];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.model = nil;
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.isShowTop) {
        return self.refresh.arrData.count+1;
//    }
//    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isShowTop) {
        if (indexPath.row == 0) {
            MEOnlineToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineToolsCell class]) forIndexPath:indexPath];
            [cell setUIWithHiddenRunData:YES];
            kMeWEAKSELF
            cell.selectedBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                switch (index) {
                    case 1:
                        break;
                    case 2:
                    {
                        MECustomerFilesVC *filesVC = [[MECustomerFilesVC alloc] init];
                        [strongSelf.navigationController pushViewController:filesVC animated:YES];
                    }
                        break;
                    case 3:
                    {
                        MECustomerServiceVC *serviceVC = [[MECustomerServiceVC alloc] init];
                        [strongSelf.navigationController pushViewController:serviceVC animated:YES];
                    }
                        break;
                    case 4:
                    {
                        MECustomerAppointmentVC *appointmentVC = [[MECustomerAppointmentVC alloc] init];
                        [strongSelf.navigationController pushViewController:appointmentVC animated:YES];
                    }
                        break;
                    case 5:
                    {
                        MECustomerConsumeVC *vc = [[MECustomerConsumeVC alloc] init];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            };
            return cell;
        }
//    }
    NSInteger row = indexPath.row;
//    if (self.isShowTop) {
        row = indexPath.row - 1;
//    }
    MEOperationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOperationContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.refresh.arrData[row];
    [cell setUIWithInfo:info];
    kMeWEAKSELF
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        switch (index) {
            case 0:
//                NSLog(@"今日顾客总数");
            {
                MEOperationTotalListVC *vc = [[MEOperationTotalListVC alloc] init];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
//                NSLog(@"今日手工费总数");
            {
                MEOperationTotalListVC *vc = [[MEOperationTotalListVC alloc] init];
                vc.ischargeList = YES;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
//                NSLog(@"业绩");
            {
                strongSelf.index = 1;
                [strongSelf getClerkRankingDatasAndGetObjectRankDatas:NO];
            }
                break;
            case 3:
//                NSLog(@"消耗");
            {
                strongSelf.index = 2;
                [strongSelf getClerkRankingDatasAndGetObjectRankDatas:NO];
            }
                break;
            case 4:
//                NSLog(@"项目数");
            {
                strongSelf.index = 3;
                [strongSelf getClerkRankingDatasAndGetObjectRankDatas:NO];
            }
                break;
            case 5:
//                NSLog(@"客次数");
            {
                strongSelf.index = 4;
                [strongSelf getClerkRankingDatasAndGetObjectRankDatas:NO];
            }
                break;
            case 6:
//                NSLog(@"员工排名");
            {
                MERankListVC *rankListVC = [[MERankListVC alloc] init];
                [strongSelf.navigationController pushViewController:rankListVC animated:YES];
            }
                break;
            case 7:
//                NSLog(@"服务项目排名");
            {
                MERankListVC *rankListVC = [[MERankListVC alloc] init];
                rankListVC.isObjectList = YES;
                [strongSelf.navigationController pushViewController:rankListVC animated:YES];
            }
                break;
            default:
                break;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isShowTop) {
        if (indexPath.row == 0) {
            return kMEOnlineToolsCellHeight-78;
        }
//    }
//    NSInteger row = indexPath.row;
//    if (self.isShowTop) {
//        row = indexPath.row - 1;
//    }
//    NSDictionary *info = self.refresh.arrData[row];
//    NSArray *content = info[@"content"];
//    if (content.count <= 0) {
//        return 0;
//    }
    return 198;
}


#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-(self.isShowTop?0:kMeTabBarHeight)) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineToolsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineToolsCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOperationContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOperationContentCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonStoreNewOperationData)];
        _refresh.delegate = self;
        _refresh.isDataInside = NO;
//        _refresh.showMaskView = YES;
        _refresh.showFailView = NO;
    }
    return _refresh;
}

- (NSMutableArray *)clerkRanks {
    if (!_clerkRanks) {
        _clerkRanks = [[NSMutableArray alloc] init];
    }
    return _clerkRanks;
}

- (NSMutableArray *)objectRanks {
    if (!_objectRanks) {
        _objectRanks = [[NSMutableArray alloc] init];
    }
    return _objectRanks;
}

@end
