//
//  MEFilterVC.m
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEFilterVC.h"
#import "MEFilterMainCell.h"
#import "MEFilterGoodVC.h"
#import "MEFilterMainModel.h"

@interface MEFilterVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEFilterMainModel *_allModel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;


@end

@implementation MEFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品分类";
    _allModel = [MEFilterMainModel new];
    _allModel.category_name = @"全部分类";
    _allModel.idField = 0;
    self.view.backgroundColor = kMEfbfbfb;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    return @{};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEFilterMainModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section){
        return self.refresh.arrData.count;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section){
        MEFilterMainModel *model = self.refresh.arrData[indexPath.row];
        MEFilterMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEFilterMainCell class])];
        [cell setUIWithModel:model];
        return cell;
    }else{
        MEFilterMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEFilterMainCell class])];
        [cell setUIWithModel:_allModel];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEFilterMainCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    view.backgroundColor = kMEfbfbfb;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section){
        MEFilterMainModel *model = self.refresh.arrData[indexPath.row];
        MEFilterGoodVC *vc = [[MEFilterGoodVC alloc]initWithcategory_id:[NSString stringWithFormat:@"%@",@(model.idField)] title:kMeUnNilStr(model.category_name)];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MEFilterGoodVC *vc = [[MEFilterGoodVC alloc]initWithcategory_id:[NSString stringWithFormat:@"%@",@(_allModel.idField)] title:kMeUnNilStr(_allModel.category_name)];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Setter And Getter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFilterMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEFilterMainCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMEfbfbfb;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPGoodsGetCategory)];
        _refresh.delegate = self;
        _refresh.showFailView = NO;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有分类";
        }];
    }
    return _refresh;
}



@end
