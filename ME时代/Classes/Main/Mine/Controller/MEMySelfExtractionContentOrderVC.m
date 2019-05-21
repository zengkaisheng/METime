//
//  MEMySelfExtractionContentOrderVC.m
//  ME时代
//
//  Created by hank on 2019/2/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEMySelfExtractionContentOrderVC.h"
#import "MEOrderModel.h"
#import "MEOrderCell.h"
#import "MEMyOrderDetailVC.h"

@interface MEMySelfExtractionContentOrderVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEOSelfExtractionrderStyle _type;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEMySelfExtractionContentOrderVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (instancetype)initWithType:(MEOSelfExtractionrderStyle)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    kSelfExtractOrderReload
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    dic[@"order_status"] = @"";
    dic[@"get_status"] = @(_type);
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
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
