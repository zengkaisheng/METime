//
//  MeHomeNewGuideVC.m
//  ME时代
//
//  Created by hank on 2019/5/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MeHomeNewGuideVC.h"
#import "MeHomeNewGuideCell.h"
#import "ZLWebVC.h"
#import "MeHomeNewGuideModel.h"

@interface MeHomeNewGuideVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MeHomeNewGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新手指南";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MeHomeNewGuideModel mj_objectArrayWithKeyValuesArray:data]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeHomeNewGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeHomeNewGuideCell class]) forIndexPath:indexPath];
    MeHomeNewGuideModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWitModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MeHomeNewGuideCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //guideid
    MeHomeNewGuideModel *model = self.refresh.arrData[indexPath.row];
    ZLWebVC *vc = [[ZLWebVC alloc]initWithUrl:kMeUnNilStr(model.url)];
    vc.isNeedH5Title = NO;
    vc.title = kMeUnNilStr(model.title);
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MeHomeNewGuideCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MeHomeNewGuideCell class])];
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
        NSString *apiSTr = kGetApiWithUrl(MEIPguidegetList);
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:apiSTr];
        _refresh.delegate = self;
//        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有数据";
        }];
    }
    return _refresh;
}
@end
