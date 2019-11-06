//
//  MEEyesightAppointmentInfoVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEyesightAppointmentInfoVC.h"
#import "MEAppointDetailModel.h"
#import "MEAppointmentStatusCell.h"
#import "MEAppointmentMsgCell.h"
#import "MEEyesightStoreCell.h"
#import "MEAppointmentEyesightCell.h"

@interface MEEyesightAppointmentInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *reserve_sn;
@property (nonatomic, strong) MEAppointDetailModel *detaliModel;

@end

@implementation MEEyesightAppointmentInfoVC

- (instancetype)initWithOrderReserve_sn:(NSString *)reserve_sn{
    if(self = [super init]){
        self.reserve_sn = reserve_sn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
     [self requestAppointmentDetailWithNetWork];
}

#pragma mark -- Networking
//视力预约详情
- (void)requestAppointmentDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postAppointDetailWithReserve_sn:self.reserve_sn successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf.detaliModel =  [MEAppointDetailModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MEAppointmentStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAppointmentStatusCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.detaliModel];
        return cell;
    }else if (indexPath.row == 1) {
        MEAppointmentEyesightCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAppointmentEyesightCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.detaliModel];
        return cell;
    }else if (indexPath.row == 3) {
        MEEyesightStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEEyesightStoreCell class]) forIndexPath:indexPath];
        [cell setAppointmentInfoUIWithModel:self.detaliModel];
        kMeWEAKSELF
        cell.pilotBlock = ^{
            kMeSTRONGSELF
            [MECommonTool doNavigationWithEndLocation:@[kMeUnNilStr(strongSelf.detaliModel.company_latitude),kMeUnNilStr(strongSelf.detaliModel.company_longitude)]];
        };
        return cell;
    }
    MEAppointmentMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAppointmentMsgCell class]) forIndexPath:indexPath];
    [cell setUIWithTitle:@"预约时间" content:kMeUnNilStr(self.detaliModel.arrive_time)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }else if (indexPath.row == 1) {
        return 158;
    }else if (indexPath.row == 3) {
        return 97;
    }
    return 63;
}

#pragma setter && getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-56) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointmentStatusCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAppointmentStatusCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointmentMsgCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAppointmentMsgCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEEyesightStoreCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEEyesightStoreCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointmentEyesightCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAppointmentEyesightCell class])];
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


@end
