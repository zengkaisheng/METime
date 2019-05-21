//
//  MEAIDataHomeActiveVC.m
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAIDataHomeActiveVC.h"
#import "MEAIDataHomeActiveHomeView.h"
#import "MEAIDataHomeActiveHomeCell.h"
#import "MEAIDataHomeActiveModel.h"

@interface MEAIDataHomeActiveVC ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_arrData;
    NSArray *_arrDataStr;
    MEAIDataHomeActiveHomeViewType _type;
    MEAIDataHomeActiveModel *_model;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@end

@implementation MEAIDataHomeActiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = MEAIDataHomeActiveHomeViewAllType;
    _model = [MEAIDataHomeActiveModel new];
    _arrData = @[@[@(MEAIDataHomeActiveHomeCellcheckStoreType),@(MEAIDataHomeActiveHomeCellshareStoreType)],@[@(MEAIDataHomeActiveHomeCellcheckpintuanType),@(MEAIDataHomeActiveHomeCellcheckServerType)]];
    _arrDataStr = @[@[@(0),@(0)],@[@(0),@(0)]];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.tableView.mj_header beginRefreshing];
//    [self.refresh addRefreshView];
}

- (void)getData{
    kMeWEAKSELF
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    [MEPublicNetWorkTool postgetMemberBehaviorWithtype:@(_type).description SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_model = [MEAIDataHomeActiveModel mj_objectWithKeyValues:responseObject.data];
        strongSelf->_arrDataStr = @[@[@(strongSelf->_model.look_store),@(strongSelf->_model.share_store)],@[@(strongSelf->_model.look_group_buy_activity),@(strongSelf->_model.look_services)]];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
        [HUD hideAnimated:YES];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf->_arrDataStr = @[@[@(0),@(0)],@[@(0),@(0)]];
        [strongSelf.tableView reloadData];
        [HUD hideAnimated:YES];
        [strongSelf.tableView.mj_header endRefreshing];
    }];
}

//- (NSDictionary *)requestParameter{
//    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
//}
//
//- (void)handleResponse:(id)data{
//    if(![data isKindOfClass:[NSArray class]]){
//        return;
//    }
//    [self.refresh.arrData addObjectsFromArray:[MEAIDataHomeTimeModel mj_objectArrayWithKeyValuesArray:data]];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _arrData[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEAIDataHomeActiveHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAIDataHomeActiveHomeCell class]) forIndexPath:indexPath];
    MEAIDataHomeActiveHomeCellType type = [_arrData[indexPath.section][indexPath.row] integerValue];
    NSInteger count =  [_arrDataStr[indexPath.section][indexPath.row] integerValue];
    [cell setUIWithType:type count:count];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEAIDataHomeActiveHomeCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MEAIDataHomeTimeModel *model = self.refresh.arrData[indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return kMEAIDataHomeActiveHomeViewHeight+k10Margin;
    }else{
        return k10Margin;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        MEAIDataHomeActiveHomeView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEAIDataHomeActiveHomeView class])];
        [headview setUiWithType:_type];
        kMeWEAKSELF
        headview.selectBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            strongSelf->_type = index;
            [strongSelf getData];
        };
        return headview;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, k10Margin)];
        view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        return view;
    }
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAIDataHomeActiveHomeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAIDataHomeActiveHomeCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAIDataHomeActiveHomeView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEAIDataHomeActiveHomeView class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor =[UIColor colorWithHexString:@"f4f4f4"];
    }
    return _tableView;
}


@end
