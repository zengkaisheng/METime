//
//  MEAppointmentDetailVC.m
//  ME时代
//
//  Created by hank on 2018/9/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentDetailVC.h"
#import "MEMyOrderDetailCell.h"
#import "MEOrderDetailView.h"
#import "MEOrderDetailContentCell.h"
#import "MEAppointDetailModel.h"
#import "MEAppointmentDetailBootomView.h"

@interface MEAppointmentDetailVC ()<UITableViewDelegate, UITableViewDataSource>{
    MEAppointmenyStyle _appointType;
    NSString *_reserve_sn;
    MEAppointDetailModel *_detaliModel;
    
    //那个端进来
    MEClientTypeStyle _userType;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrData;//预约信息
@property (nonatomic, strong) MEOrderDetailView *headerView;
@property (nonatomic, strong) NSArray *arrDataStr;

@property (nonatomic, strong) NSArray *arrUserData;//用户信息
@property (nonatomic, strong) NSArray *arrUserDataStr;
@property (nonatomic, strong) MEAppointmentDetailBootomView *bottomView;

//@property (nonatomic, strong) NSArray *arrChild;
@end

@implementation MEAppointmentDetailVC

- (instancetype)initWithOrderreserve_sn:(NSString *)reserve_sn{
    if(self = [super init]){
        _reserve_sn = reserve_sn;
    }
    return self;
}

- (instancetype)initWithReserve_sn:(NSString *)reserve_sn userType:(MEClientTypeStyle)userType{
    if(self = [super init]){
        _reserve_sn = reserve_sn;
        _userType = userType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约详情";
    kMeWEAKSELF
    //c端
    if(_userType == MEClientCTypeStyle){
        [MEPublicNetWorkTool postAppointDetailWithReserve_sn:_reserve_sn successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_detaliModel =  [MEAppointDetailModel mj_objectWithKeyValues:responseObject.data];
            strongSelf->_appointType = strongSelf->_detaliModel.is_use;
            if( strongSelf->_detaliModel.is_first_buy){
                strongSelf->_arrData = @[@(MEAppointmentSettlmentTime),@(MEAppointmentSettlmentFristBuy)];
                strongSelf.arrDataStr = @[kMeUnNilStr(strongSelf->_detaliModel.arrive_time),@""];
            }else{
                strongSelf->_arrData = @[@(MEAppointmentSettlmentTime)];
                strongSelf.arrDataStr = @[kMeUnNilStr(strongSelf->_detaliModel.arrive_time)];
            }
            
            //        strongSelf.arrChild = @[strongSelf->_detaliModel];
            strongSelf.tableView.tableHeaderView =strongSelf.headerView;
            [strongSelf.view addSubview:strongSelf.tableView];
            [strongSelf.tableView reloadData];
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        //B 店员 端
        [MEPublicNetWorkTool postReserveDetailBlWithReserve_sn:_reserve_sn successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_detaliModel =  [MEAppointDetailModel mj_objectWithKeyValues:responseObject.data];
            strongSelf->_appointType = strongSelf->_detaliModel.is_use;
            if( strongSelf->_detaliModel.is_first_buy){
                strongSelf->_arrData = @[@(MEAppointmentSettlmentTime),@(MEAppointmentSettlmentFristBuy)];
                strongSelf.arrDataStr = @[kMeUnNilStr(strongSelf->_detaliModel.arrive_time),@""];
                strongSelf.arrUserData = @[@(MEAppointmentSettlmentUserNameStyle),@(MEAppointmentSettlmentUserTelStyle)];
                strongSelf.arrUserDataStr = @[kMeUnNilStr(strongSelf->_detaliModel.name),kMeUnNilStr(strongSelf->_detaliModel.member_cellphone)];
                
            }else{
                strongSelf->_arrData = @[@(MEAppointmentSettlmentTime)];
                strongSelf.arrDataStr = @[kMeUnNilStr(strongSelf->_detaliModel.arrive_time)];
                
                strongSelf.arrUserData = @[@(MEAppointmentSettlmentUserNameStyle),@(MEAppointmentSettlmentUserTelStyle)];
                strongSelf.arrUserDataStr = @[kMeUnNilStr(strongSelf->_detaliModel.name),kMeUnNilStr(strongSelf->_detaliModel.member_cellphone)];
            }
            strongSelf.tableView.tableHeaderView =strongSelf.headerView;
            if(strongSelf->_appointType == MEAppointmenyUseing){
                strongSelf.tableView.tableFooterView = strongSelf.bottomView;
            }
            [strongSelf.view addSubview:strongSelf.tableView];
            [strongSelf.tableView reloadData];
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
 
    }
}
#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_userType == MEClientCTypeStyle){
        return 2;
    }else{
        return 3;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_userType == MEClientCTypeStyle){
        if(section){
            return _arrData.count;
        }else{
            return 1;
        }
    }else{
        switch (section) {
            case 0:
            {
                return 1;
            }
                break;
            case 1:
            {
                return _arrData.count;
            }
                break;
            case 2:
            {
                return _arrUserData.count;
            }
                break;
            default:
                return 0;
                break;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            MEOrderDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderDetailContentCell class]) forIndexPath:indexPath];
            //        id model = _arrChild[indexPath.row];
            [cell setAppointUIWithChildModel:_detaliModel];
            return cell;
        }
            break;
        case 1:{
            MEMyOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyOrderDetailCell class]) forIndexPath:indexPath];
            ;
            [cell setAppointUIWithModel:_arrDataStr[indexPath.row] appointType:[_arrData[indexPath.row] integerValue] orderType:_appointType];
            return cell;
        }
            break;
        case 2:{
            MEMyOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMyOrderDetailCell class]) forIndexPath:indexPath];
            ;
            [cell setAppointUIWithModel:_arrUserDataStr[indexPath.row] appointType:[_arrUserData[indexPath.row] integerValue] orderType:_appointType];
            return cell;
        }
            break;
        default:
            return  [UITableViewCell new];
            break;
    }
    
//    if(indexPath.section){
//
//    }else{
//
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section?kMEMyOrderDetailCellHeight:kMEOrderDetailContentCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section?kMEMyOrderDetailCellHeight:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEMyOrderDetailCellHeight)];
    UILabel *lblTitle = [[UILabel alloc]init];
    [sectionView addSubview:lblTitle];
    lblTitle.text = @"预约信息";
    if(section == 2){
        lblTitle.text = @"客户信息";
    }
    lblTitle.font = [UIFont systemFontOfSize:16];
    lblTitle.textColor = kMEHexColor(@"333333");
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView.mas_left).offset(15);
        make.right.equalTo(sectionView.mas_right).offset(15);
        make.top.equalTo(sectionView);
        make.bottom.equalTo(sectionView);
    }];
    return sectionView;
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyOrderDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMyOrderDetailCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOrderDetailContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOrderDetailContentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEOrderDetailView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEOrderDetailView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEOrderDetailViewHeight);
        [_headerView setAppointUIWithModel:_detaliModel orderType:_appointType];
    }
    return _headerView;
}

- (MEAppointmentDetailBootomView *)bottomView{
    if(!_bottomView){
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"MEAppointmentDetailBootomView" owner:nil options:nil] lastObject];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEAppointmentDetailBootomViewheight);
        kMeWEAKSELF
        _bottomView.cancelBlock = ^{
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定取消预约吗?"];
            [aler addButtonWithTitle:@"确定" block:^{
                kMeSTRONGSELF
                [MEPublicNetWorkTool postCancelReserveWithReserveSn:strongSelf->_detaliModel.reserve_sn successBlock:^(ZLRequestResponse *responseObject) {
                    kNoticeReloadAppoint
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                } failure:^(id object) {
                    
                }];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
        };
        _bottomView.finishBlock = ^{
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定完成预约吗?"];
            [aler addButtonWithTitle:@"确定" block:^{
                kMeSTRONGSELF
                [MEPublicNetWorkTool postFinishReserveWithReserveSn:strongSelf->_detaliModel.reserve_sn successBlock:^(ZLRequestResponse *responseObject) {
                    kNoticeReloadAppoint
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                } failure:^(id object) {
                    
                }];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
        };
    }
    return _bottomView;
}




@end
