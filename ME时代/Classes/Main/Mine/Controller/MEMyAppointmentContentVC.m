//
//  MEMyAppointmentContentVC.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyAppointmentContentVC.h"
#import "MEMyAppointmentCell.h"
#import "MEAppointmentDetailVC.h"
#import "MEAppointmentModel.h"


@interface MEMyAppointmentContentVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEAppointmenyStyle _type;
    MEClientTypeStyle _userType;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEMyAppointmentContentVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (instancetype)initWithType:(MEAppointmenyStyle)type userType:(MEClientTypeStyle)userType{
    if(self = [super init]){
        _type = type;
        _userType = userType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    kAppointReload
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    dic[@"is_use"] = @(_type).description;
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEAppointmentModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEAppointmentModel *model = self.refresh.arrData[indexPath.row];
    MEMyAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyAppointmentCell class]) forIndexPath:indexPath];
    if(_userType == MEClientCTypeStyle){
        cell.cancelAppointBlock = ^{
            
        };
        [cell setUIWithModel:model Type:_type];
    }else{
        [cell setBUIWithModel:model Type:_type];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEMyAppointmentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEAppointmentModel *model = self.refresh.arrData[indexPath.row];
    MEAppointmentDetailVC *vc = [[MEAppointmentDetailVC alloc]initWithReserve_sn:kMeUnNilStr(model.reserve_sn) userType:_userType];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyAppointmentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyAppointmentCell class])];
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
        NSString *IPStr = MEIPcommonreserveListB;
        if(_userType == MEClientCTypeStyle){
            IPStr = MEIPcommonGetReserveList;
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(IPStr)];
        _refresh.isDataInside = YES;
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有预约";
        }];
    }
    return _refresh;
}

@end
