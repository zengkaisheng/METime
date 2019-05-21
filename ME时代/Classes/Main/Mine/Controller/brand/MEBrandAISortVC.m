//
//  MEBrandAISortVC.m
//  ME时代
//
//  Created by hank on 2019/3/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandAISortVC.h"
#import "MEBrandAiCell.h"
#import "MEBrandManngerVC.h"
#import "MEBrandAbilityManngerVC.h"
#import "MEBrandAISortModel.h"

@interface MEBrandAISortVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEBrandAISortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEBrandAISortModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEBrandAiCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBrandAiCell class]) forIndexPath:indexPath];
    MEBrandAISortModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model sortNum:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEBrandAiCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBrandAISortModel *model = self.refresh.arrData[indexPath.row];
    MEBrandAbilityManngerVC *vc = [[MEBrandAbilityManngerVC alloc]initWithModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandManngerVCHeaderHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBrandAiCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBrandAiCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommongAiRank)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有店铺";
        }];
    }
    return _refresh;
}


@end
