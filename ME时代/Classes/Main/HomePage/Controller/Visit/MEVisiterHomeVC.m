//
//  MEVisiterHomeVC.m
//  ME时代
//
//  Created by hank on 2018/11/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEVisiterHomeVC.h"
#import "MEVisitHomeHeaderView.h"
#import "MEVisterTodySectionView.h"
#import "MEVisterTodyCell.h"
#import "MEVisterSectionView.h"
#import "MEVistorVisterCell.h"
#import "MEVistorPathVC.h"
#import "MEVistorCountModel.h"
#import "MEVistorUserModel.h"

@interface MEVisiterHomeVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MyEnumkMEVisterSectionViewType _type;
}

@property (nonatomic , strong) MEVisitHomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic , strong) UIView *viewForNav;
@property (nonatomic , strong) MEVisterTodyCell *vCell;
@property (nonatomic , strong) MEVistorCountModel *countModel;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEVisiterHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    self.view.backgroundColor = kMEPink;
    _type = MyEnumkMEVisterSectionViewAllType;
    [self.view addSubview:self.viewForNav];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNetWork)];
//    [self.tableView.mj_header beginRefreshing];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestNetWork];
    }
    switch (_type) {
        case MyEnumkMEVisterSectionViewAllType:{
            return @{@"token":kMeUnNilStr(kCurrentUser.token)};
        }
        break;
        case MyEnumkMEVisterSectionViewHopeType:{
            return @{@"token":kMeUnNilStr(kCurrentUser.token),@"is_intention":@"2"};
        }
            break;
        case MyEnumkMEVisterSectionViewVisterType:{
            return @{@"token":kMeUnNilStr(kCurrentUser.token),@"is_intention":@"1"};
        }
            break;
        default:
            return @{};
            break;
    }
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEVistorUserModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)requestNetWork{
//    self.refresh.pageIndex = 1;
//    [self.refresh.arrData removeAllObjects];
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetAccessWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf.countModel = [MEVistorCountModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf.headerView setUIWithModel:strongSelf.countModel];
        [strongSelf.tableView reloadData];
//        [strongSelf.tableView.mj_header endRefreshing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)pop:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!section){
        return 1;
    }
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(!_vCell){
            _vCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVisterTodyCell class]) forIndexPath:indexPath];
        }
        NSInteger count = [self.countModel.article_count integerValue];
        NSInteger countposter = [self.countModel.poster_count integerValue];
        NSNumber *countNum = [NSNumber numberWithInteger:count];
        NSNumber *countposterNum = [NSNumber numberWithInteger:countposter];
        [_vCell setUiWithModel:countNum posterCount:countposterNum];
        return _vCell;
    }
    MEVistorUserModel *model = self.refresh.arrData[indexPath.row];
    MEVistorVisterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVistorVisterCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.setIntenBlock = ^{
        kMeSTRONGSELF
        [strongSelf.refresh reload];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return kMEVisterTodyCellwHeight;
    }
    return kMEVistorVisterCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!section){
       return kMEVisterTodySectionViewHeight;
    }
    return kMEVisterSectionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(!section){
        MEVisterTodySectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEVisterTodySectionView class])];
        return headview;
    }else{
        MEVisterSectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEVisterSectionView class])];
        kMeWEAKSELF
        [headview setTypeWithType:_type block:^(NSInteger index) {
            kMeSTRONGSELF
            strongSelf->_type = index;
            [strongSelf.refresh reload];
        }];
        return headview;
    }
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVisterTodyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVisterTodyCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVisterTodySectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEVisterTodySectionView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVisterSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEVisterSectionView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVistorVisterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVistorVisterCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


- (MEVisitHomeHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEVisitHomeHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEVisitHomeHeaderView getViewHeight]);
    }
    return _headerView;
}

- (UIView *)viewForNav{
    if(!_viewForNav){
        _viewForNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeNavBarHeight)];
        _viewForNav.backgroundColor = kMEPink;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, kMeStatusBarHeight, 50, kMeNavBarHeight-kMeStatusBarHeight);
        [btn setImage:[UIImage imageNamed:@"icon-rrqcdatuud"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        [_viewForNav addSubview:btn];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(btn.right + 14, kMeStatusBarHeight, SCREEN_WIDTH-128, kMeNavBarHeight-kMeStatusBarHeight)];
        lbl.text = @"访问";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:20];
        lbl.textColor = [UIColor whiteColor];
        [_viewForNav addSubview:lbl];
    }
    return _viewForNav;
}

- (MEVistorCountModel *)countModel{
    if(!_countModel){
        _countModel = [MEVistorCountModel new];
    }
    return _countModel;
}


- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonGetAccessUser)];
        _refresh.delegate = self;
        _refresh.showFailView = NO;
        _refresh.isDataInside = YES;
    }
    return _refresh;
}


@end
