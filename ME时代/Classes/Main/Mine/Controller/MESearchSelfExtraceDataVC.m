//
//  MESearchSelfExtraceDataVC.m
//  ME时代
//
//  Created by hank on 2019/2/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MESearchSelfExtraceDataVC.h"
#import "MEOrderModel.h"
#import "MEOrderCell.h"
#import "MEMyOrderDetailVC.h"

@interface MESearchSelfExtraceDataVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>
{
    NSString *_query;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MESearchSelfExtraceDataVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (instancetype)initWithQuery:(NSString *)query{
    if(self = [super init]){
        _query = kMeUnNilStr(query);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _query;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    kSelfExtractOrderReload
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    dic[@"order_status"] = @"";
    dic[@"select"] = _query;
//    dic[@"get_status"] = @(_type);
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEOrderModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //MEStoreModel *storeModel = self.arrStore[section];
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderCell class]) forIndexPath:indexPath];
    MEOrderModel *model = self.refresh.arrData[indexPath.row];
    kMeWEAKSELF
    cell.touchBlock = ^{
        kMeSTRONGSELF
        MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initSelfWithType:[model.order_status integerValue] orderGoodsSn:kMeUnNilStr(model.order_sn)];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    [cell setSelfUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEOrderModel *model = self.refresh.arrData[indexPath.row];
    return [MEOrderCell getCellSelfHeightWithModel:model];
}

#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOrderCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommongetStoreGetOrderList)];
        _refresh.isDataInside = YES;
        //        _refresh.isGet = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有订单";
        }];
    }
    return _refresh;
}





@end
