//
//  MECourseOrderListVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseOrderListVC.h"
#import "MECourseOrderCell.h"
#import "MECourseOrderModel.h"
#import "MECourseDetailVC.h"

@interface MECourseOrderListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MECourseOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订购课程";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"order_status":@"2"
             };//
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECourseOrderModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECourseOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECourseOrderCell class]) forIndexPath:indexPath];
    MECourseOrderModel *model = self.refresh.arrData[indexPath.row];
    [cell setupUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 182;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECourseOrderModel *model = self.refresh.arrData[indexPath.row];
    MECourseOrderGoodsModel *goodsModel = model.order_goods;
    NSInteger type = 0;
    if (model.order_type == 2) {
        type = 1;
    }
    MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:goodsModel.product_id type:type];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECourseOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECourseOrderCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonOnlineGetOrderList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关订单";
        }];
    }
    return _refresh;
}

@end
