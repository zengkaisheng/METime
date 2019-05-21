//
//  MENewStoreDetailsVC.m
//  ME时代
//
//  Created by hank on 2018/10/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MENewStoreDetailsVC.h"
#import "MEStoreDetailHeaderView.h"
#import "MEStoreDetailCell.h"
#import "MEStoreHomeIntroduceCell.h"
#import "MEServiceDetailsVC.h"
#import "MEStoreDetailModel.h"
#import "MEGoodModel.h"


@interface MENewStoreDetailsVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    BOOL _isExpand;
    NSInteger _detailsId;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) MEStoreDetailHeaderView *headerView;
@property (nonatomic, strong) MEStoreDetailModel *model;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MENewStoreDetailsVC

- (instancetype)initWithId:(NSInteger)detailsId{
    if(self = [super init]){
        _detailsId = detailsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店详情";
    [self initWithSomeThing];
}

- (void)initWithSomeThing{
    kMeWEAKSELF
    [MEPublicNetWorkTool postStroeDetailWithGoodsId:_detailsId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MEStoreDetailModel *model = [MEStoreDetailModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf setUIWithModel:model];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"type":@(MEGoodsTypeNetServiceStyle),@"pageSize":@(100),@"uid":kMeUnNilStr(kCurrentUser.uid)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEGoodModel mj_objectArrayWithKeyValuesArray:data]];
}


- (void)setUIWithModel:(MEStoreDetailModel *)model{
    _isExpand = NO;
    _model = model;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [self.refresh addRefreshView];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return self.refresh.arrData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        MEStoreHomeIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEStoreHomeIntroduceCell class]) forIndexPath:indexPath];
        kMeWEAKSELF
        [cell setUIWithModel:_model isExpand:_isExpand ExpandBlock:^(BOOL isExpand) {
            kMeSTRONGSELF
            strongSelf->_isExpand = isExpand;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return cell;
    }else{
        MEStoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEStoreDetailCell class]) forIndexPath:indexPath];
        MEGoodModel *model = self.refresh.arrData[indexPath.row];
        [cell setUIWithModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [MEStoreHomeIntroduceCell getCellHeightWithModel:_model isExpand:_isExpand];
    }else{
        return kMEStoreDetailCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section){
        MEGoodModel *model = self.refresh.arrData[indexPath.row];
        MEServiceDetailsVC *vc = [[MEServiceDetailsVC alloc]initWithId:model.product_id storeDetailModel:_model];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEStoreHomeIntroduceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEStoreHomeIntroduceCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEStoreDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEStoreDetailCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEStoreDetailHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEStoreDetailHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEStoreDetailHeaderView getViewHeight:_model]);
        [_headerView setUIWithModel:_model];
    }
    return _headerView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonGoodsGetGoodsList)];
        _refresh.delegate = self;
        _refresh.numOfsize = @(100);
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有服务";
        }];
    }
    return _refresh;
}




@end
