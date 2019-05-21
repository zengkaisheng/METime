//
//  MEMyOrderContentVC.m
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyOrderContentVC.h"
#import "MEOrderCell.h"
#import "MEMyOrderDetailVC.h"
#import "MEOrderModel.h"

@interface MEMyOrderContentVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEOrderStyle _type;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZLRefreshTool         *refresh;
@end

@implementation MEMyOrderContentVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (instancetype)initWithType:(MEOrderStyle)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    kOrderReload
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    dic[@"order_status"] = @(_type).description;
    if(_type == MEAllOrder){
        dic[@"order_status"] = @"";
    }
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
//    kMeWEAKSELF
    cell.cancelOrderBlock = ^{
//        kMeSTRONGSELF
//        [strongSelf.refresh.arrData removeObjectAtIndex:indexPath.row];
//        [strongSelf.tableView beginUpdates];
//        [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [strongSelf.tableView endUpdates];
    };
    MEOrderModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model Type:[model.order_status integerValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEOrderModel *model = self.refresh.arrData[indexPath.row];
    return [MEOrderCell getCellHeightWithModel:model Type:[model.order_status integerValue]];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonUserGetOrderList)];
        _refresh.isDataInside = YES;
        _refresh.isGet = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有订单";
        }];
    }
    return _refresh;
}


@end
