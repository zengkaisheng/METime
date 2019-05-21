//
//  MEBrandManngerAllContentVC.m
//  ME时代
//
//  Created by hank on 2019/3/8.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandManngerAllContentVC.h"
#import "MEBrandManngerVC.h"
#import "MEBrandAllDataCell.h"
#import "MEBrandTriangleCell.h"
#import "MEBrandAreasplineCell.h"
#import "MEBrandPieCell.h"
#import "MEBrandManngerAllModel.h"

@interface MEBrandManngerAllContentVC ()<UITableViewDelegate, UITableViewDataSource,JXCategoryViewDelegate>{
    NSInteger _currentType;
    MEBrandManngerAllModel *_model;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIView *maskView;
@end

@implementation MEBrandManngerAllContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];

    _currentType = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headrefresh)];
    [self.tableView.mj_header beginRefreshing];
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, kCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = @[@"全部",@"昨天",@"7天",@"30天"];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = _currentType;
    _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    _maskView.hidden = YES;
    [self.view addSubview:_maskView];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    _currentType = index;
    kMeWEAKSELF
    [self.tableView.mj_header beginRefreshing];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _maskView.hidden = NO;
    [MEPublicNetWorkTool postgetStoreOverviewWithDate:@(_currentType+1).description SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_model = [MEBrandManngerAllModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
//        [hud hideAnimated:YES];
        strongSelf->_maskView.hidden = YES;
        kMeCallBlock(strongSelf.modelBlock,strongSelf->_model.member_info);
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf->_model = [MEBrandManngerAllModel new];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
//        [hud hideAnimated:YES];
        strongSelf->_maskView.hidden = YES;
        kMeCallBlock(strongSelf.modelBlock,[MEBrandMemberInfo new]);
    }];
}

- (void)headrefresh{
    kMeWEAKSELF
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _maskView.hidden = NO;

    [MEPublicNetWorkTool postgetStoreOverviewWithDate:@(_currentType+1).description SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_model = [MEBrandManngerAllModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
//        [hud hideAnimated:YES];
        strongSelf->_maskView.hidden = YES;
        kMeCallBlock(strongSelf.modelBlock,strongSelf->_model.member_info);
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf->_model = [MEBrandManngerAllModel new];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
//        [hud hideAnimated:YES];
        strongSelf->_maskView.hidden = YES;
        kMeCallBlock(strongSelf.modelBlock,[MEBrandMemberInfo new]);
    }];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        MEBrandAllDataCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBrandAllDataCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:_model];
         return cell;
    }else if (indexPath.row == 1){
        MEBrandTriangleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBrandTriangleCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:_model];
        return cell;
    }else if(indexPath.row == 2){
        MEBrandAreasplineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBrandAreasplineCell class]) forIndexPath:indexPath];
        [cell setUiWithModel:kMeUnArr(_model.alive_member) title:@"近7日客户活跃度" subTitle:@"活跃度"];
        return cell;
    }else if(indexPath.row == 3){
        MEBrandPieCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBrandPieCell class]) forIndexPath:indexPath];
        [cell setUiWithModel:kMeUnArr(_model.customer_interest)];
        return cell;
    }else if(indexPath.row == 4){
        MEBrandAreasplineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBrandAreasplineCell class]) forIndexPath:indexPath];
        [cell setUiWithModel:kMeUnArr(_model.anew_member) title:@"近7日新增客户数" subTitle:@"客户数"];
        return cell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return kMEBrandAllDataCellHeight;
    }else if (indexPath.row == 1){
        return kMEBrandTriangleCellHeight;
    }else  if(indexPath.row == 2){
        return kMEBrandAreasplineCellHeight;
    }else  if(indexPath.row == 3){
        return kMEBrandPieCellHeight;
    }else  if(indexPath.row == 4){
        return kMEBrandAreasplineCellHeight;
    }else{
        return 0.1;
    }
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandManngerVCHeaderHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBrandAllDataCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBrandAllDataCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBrandTriangleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBrandTriangleCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBrandAreasplineCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBrandAreasplineCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBrandPieCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBrandPieCell class])];
//
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


@end
