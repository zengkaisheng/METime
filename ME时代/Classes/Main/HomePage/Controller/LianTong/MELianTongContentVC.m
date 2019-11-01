//
//  MELianTongContentVC.m
//  志愿星
//
//  Created by gao lei on 2019/9/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MELianTongContentVC.h"
#import "MEOrderCell.h"
#import "MEMyOrderDetailVC.h"
#import "MEOrderModel.h"

@interface MELianTongContentVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEOrderStyle _type;
    BOOL _isTopUp;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MELianTongContentVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (instancetype)initWithType:(NSInteger)type isTopUp:(BOOL)isTopUp{
    if(self = [super init]){
        _type = type;
        _isTopUp = isTopUp;
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
    NSDictionary *dict;
    switch (_type) {
        case 0:
            dict = @{@"token":kMeUnNilStr(kCurrentUser.token),
                     @"order_status":@""
                     };
            break;
        case 1:
            dict = @{@"token":kMeUnNilStr(kCurrentUser.token),
                     @"order_status":@"1"
                     };
            break;
        case 2:
            dict = @{@"token":kMeUnNilStr(kCurrentUser.token),
                     @"top_up_status":@"2",
                     @"order_status":@""
                     };
            break;
        case 3:
            dict = @{@"token":kMeUnNilStr(kCurrentUser.token),
                     @"top_up_status":@"1",
                     @"order_status":@""
                     };
            break;
        default:
            break;
    }
    return dict;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEOrderModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------- <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderCell class]) forIndexPath:indexPath];
        kMeWEAKSELF
    cell.cancelOrderBlock = ^{
        kMeSTRONGSELF
        [strongSelf.refresh.arrData removeObjectAtIndex:indexPath.row];
        [strongSelf.tableView beginUpdates];
        [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [strongSelf.tableView endUpdates];
    };
    MEOrderModel *model = self.refresh.arrData[indexPath.row];
    model.isTopUp = _isTopUp;
    [cell setLianTongUIWithModel:model Type:[model.order_status integerValue]];
    cell.finishBlock = ^{
        [self.refresh reload];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEOrderModel *model = self.refresh.arrData[indexPath.row];
    return [MEOrderCell getCellHeightWithLianTongModel:model Type:[model.order_status integerValue]];
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
        NSString *url = kGetApiWithUrl(MEIPcommonOrderGetLianTongOrder);
        if (_isTopUp) {
            url = kGetApiWithUrl(MEIPcommonOrderGetStoreLianTongOrder);
        }
        _refresh = [[ZLRefreshTool alloc] initWithContentView:self.tableView url:url];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有订单";
        }];
    }
    return _refresh;
}
@end
