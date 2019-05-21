//
//  MeMyActityMineVC.m
//  ME时代
//
//  Created by hank on 2019/1/6.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MeMyActityMineVC.h"
#import "MeMyActityMineCell.h"
#import "MEMineActiveModel.h"
#import "MEMineMyActityDetailVC.h"

@interface MeMyActityMineVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MeMyActityMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的活动";
    self.view.backgroundColor = kMEeeeeee;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(kCurrentUser.uid)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEMineActiveModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMineActiveModel *model = self.refresh.arrData[indexPath.row];
    MeMyActityMineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeMyActityMineCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMeMyActityMineCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MEMineActiveModel *model = self.refresh.arrData[indexPath.row];
//    MEMineMyActityDetailVC *vc = [[MEMineMyActityDetailVC alloc]initWithModel:model];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MeMyActityMineCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MeMyActityMineCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEeeeeee;
        _tableView.tableFooterView = view;
        _tableView.backgroundColor = kMEeeeeee;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPadminGetAppGetShare)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = kMEeeeeee;
            failView.lblOfNodata.text = @"没有活动";
        }];
    }
    return _refresh;
}

@end
