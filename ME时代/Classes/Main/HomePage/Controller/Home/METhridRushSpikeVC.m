//
//  METhridRushSpikeVC.m
//  ME时代
//
//  Created by hank on 2019/1/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridRushSpikeVC.h"
#import "METhridHomeRudeTimeModel.h"
#import "METhridHomeRudeGoodModel.h"
#import "MERushBuyCell.h"
#import "METhridHomeTimeSecionView.h"

@interface METhridRushSpikeVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
//    NSArray *_arrRudeBuy;
    NSArray *_arrRudeTime;
    NSInteger _selectTimeIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@end

@implementation METhridRushSpikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"秒杀产品";
    _selectTimeIndex = 0;
//    _arrRudeBuy = @[];
    _arrRudeTime = @[];
    kMeWEAKSELF
    [MEPublicNetWorkTool postThridHomeGetSeckillTimeSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_arrRudeTime =[METhridHomeRudeTimeModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        [strongSelf initSomeThing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    if(kMeUnArr(_arrRudeTime).count==0){
        return @{};
    }
    METhridHomeRudeTimeModel *model = _arrRudeTime[_selectTimeIndex];
    return @{@"product_position":@"3",@"seckill_time":kMeUnNilStr(kMeUnNilStr(model.time))};;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[METhridHomeRudeGoodModel mj_objectArrayWithKeyValuesArray:data]];
}


- (void)initSomeThing{
    for (NSInteger i =0; i<_arrRudeTime.count; i++) {
        METhridHomeRudeTimeModel *model = _arrRudeTime[i];
        if(model.status==1){
            _selectTimeIndex = i;
        }
    }
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRushGoods)];
//    [self.tableView.mj_header beginRefreshing];
}

//-(void)getRushGoods{
//    METhridHomeRudeTimeModel *model = _arrRudeTime[_selectTimeIndex];
//    kMeWEAKSELF
//    [MEPublicNetWorkTool postThridHomegetSeckillGoodsWithSeckillTime:kMeUnNilStr(model.time) SuccessBlock:^(ZLRequestResponse *responseObject) {
//        kMeSTRONGSELF
//        strongSelf->_arrRudeBuy =[METhridHomeRudeGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
//        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    } failure:^(id object) {
//        kMeSTRONGSELF
//        strongSelf->_arrRudeBuy = @[];
//        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    }];
//}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MERushBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERushBuyCell class]) forIndexPath:indexPath];
    if(kMeUnArr(_arrRudeTime).count){
        METhridHomeRudeTimeModel *model = _arrRudeTime[_selectTimeIndex];
        cell.time = kMeUnNilStr(model.time);
    }
    [cell setUIWithArr:self.refresh.arrData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MERushBuyCell getCellHeightWithArr:self.refresh.arrData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    METhridHomeTimeSecionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([METhridHomeTimeSecionView class])];
    kMeWEAKSELF
    [headview setUIWithArr:_arrRudeTime selectIndex:_selectTimeIndex selectBlock:^(NSInteger index) {
        kMeSTRONGSELF
        strongSelf->_selectTimeIndex = index;
        [strongSelf.refresh reload];
//        [strongSelf getRushGoods];
    }];
    return headview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kMEThridHomeTimeSecionViewHeight;
}

#pragma mark - Setter And Getter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERushBuyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERushBuyCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeTimeSecionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([METhridHomeTimeSecionView class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonGetgetSeckillGoods)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        _refresh.showFailView = NO;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
        }];
    }
    return _refresh;
}

@end
