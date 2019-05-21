//
//  MEMineHomeVC.m
//  ME时代
//
//  Created by Hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineHomeVC.h"
#import "MEMineHomeHeaderView.h"
#import "MEMineHomeCell.h"
#import "MEMyDistrbutionVC.h"
#import "MEMyAppointmentVC.h"
#import "MEInteralExchangVC.h"
#import "MELoginVC.h"
#import "MEAddTelView.h"
#import "MERCConversationListVC.h"
#import "AppDelegate.h"
#import "MEMineCustomerPhone.h"
#import "MEExpireTipView.h"
#import "MESelectAddressVC.h"
#import "MEMyMobileVC.h"
#import "MEProductListVC.h"
#import "MeMyActityMineVC.h"

@interface MEMineHomeVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrtype;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) MEMineHomeHeaderView *headerView;
@property (strong, nonatomic) MEAddTelView *addTelVIew;
@property (strong, nonatomic) MEExpireTipView *tipVIew;
//@property (nonatomic, strong)MELoginVC *loginVC;
@end


@implementation MEMineHomeVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
    if([MEUserInfoModel isLogin]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnMeaasge) name:kUnMessage object:nil];
    }
    NSInteger f = [[[NSUserDefaults standardUserDefaults] objectForKey:kcheckFirstBuy] integerValue];
    if(f){
        HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"提示" andMessage:@"您有一次免费预约门店服务的机会"];
        alertView.isSupportRotating = YES;
        [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        }];
        kMeWEAKSELF
        [alertView addButtonWithTitle:@"确定" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            kMeSTRONGSELF
            MEProductListVC *productList = [[MEProductListVC alloc]initWithType:MEGoodsTypeNetServiceStyle];
            [strongSelf.navigationController pushViewController:productList animated:YES];
        }];
        [alertView show];
        
//        MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"提示" message:@"您有一次免费预约门店服务的机会"];
//        [aler addButtonWithTitle:@"取消"];
//        kMeWEAKSELF
//        [aler addButtonWithTitle:@"确定" block:^{
//            kMeSTRONGSELF
//            MEProductListVC *productList = [[MEProductListVC alloc]initWithType:MEGoodsTypeNetServiceStyle];
//            [strongSelf.navigationController pushViewController:productList animated:YES];
//        }];
//        [aler show];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUnMeaasge];
    if([MEUserInfoModel isLogin] && _headerView){
        _headerView.lblLevel.text =  [NSString stringWithFormat:@"手机:%@",kMeUnNilStr(kCurrentUser.mobile)];
    }
}

- (void)getUnMeaasge{
    if([MEUserInfoModel isLogin] && _arrtype.count && self.tableView){
        kMeWEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            switch (kCurrentUser.user_type) {
                    
                case 4:{
                    MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    [cell setUnMeaasge];
                }
                    break;
                case 1:{
                    MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    [cell setUnMeaasge];
                }
                    break;
                case 2:{
                        MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        [cell setUnMeaasge];
                    }
                    break;
                case 3:{
                    MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    [cell setUnMeaasge];
                }
                    break;
                case 5:{
                    MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                    [cell setUnMeaasge];
                }
                    break;
                default:{
                    MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    [cell setUnMeaasge];
                }
                    break;
            }
//            NSString *admin = kCurrentUser.path.group;
//            if([kMeUnNilStr(admin) isEqualToString:@"member"]){
//                MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//                [cell setUnMeaasge];
//            }else if([kMeUnNilStr(admin) isEqualToString:@"store"]){
//                 MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//                [cell setUnMeaasge];
//            }else{
//                MEMineHomeCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                [cell setUnMeaasge];
//            }
        });
    }
}

- (void)userLogout{
    [self.navigationController popToViewController:self animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUnMessage object:nil];
    [self.headerView clearUIWithUserInfo];
    _arrtype = @[];
    [self.tableView reloadData];
}

- (void)userLogin{
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnMeaasge) name:kUnMessage object:nil];
}

- (void)loadData{
    kMeWEAKSELF
    [MEPublicNetWorkTool getUserGetUserWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        NSLog(@"%@",kCurrentUser.uid);
        kMeSTRONGSELF
        switch (kCurrentUser.user_type) {
            case 1:{
                
                strongSelf->_arrtype = @[@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
            }
                break;
            case 2:{
                //
                strongSelf->_arrtype = @[@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
            }
                break;
            case 4:{
                //C
                strongSelf->_arrtype = @[@(MeMyDistribution),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
            }
                break;
            case 3:{
                //B
                strongSelf->_arrtype = @[@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
            }
                break;
            case 5:{
                //clerk
                strongSelf->_arrtype = @[@(MeMyDistribution),@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
            }
                break;
            default:{
                strongSelf->_arrtype = @[@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
            }
                break;
        }
        [strongSelf.headerView reloadUIWithUserInfo];
        strongSelf.tableView.tableHeaderView = strongSelf.headerView;
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.tableView.mj_header endRefreshing];
    }];

    
//    kMeWEAKSELF
//    [MEPublicNetWorkTool getUserCentreDataWithSuccessBlock:^(ZLRequestResponse *responseObject) {
//        [kCurrentUser setterWithDict:responseObject.data];
//        [kCurrentUser save];
//        kMeSTRONGSELF
//        //B我的中心 C中心管理 admin_id nil C notnil b
//        NSString *admin = kCurrentUser.path.group;
//        if([kMeUnNilStr(admin) isEqualToString:@"member"]){
//            strongSelf->_arrtype = @[@(MeMyDistribution),@(MeMyExchange),@(MeMyAppointment),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
//        }else if([kMeUnNilStr(admin) isEqualToString:@"store"]){
//            strongSelf->_arrtype = @[@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
//        }else{
//            strongSelf->_arrtype = @[@(MeMyExchange),@(MeMyAppointment),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile)];
//        }
//        [strongSelf.headerView reloadUIWithUserInfo];
//        strongSelf.tableView.tableHeaderView = strongSelf.headerView;
//        [strongSelf.tableView reloadData];
//        [strongSelf.tableView.mj_header endRefreshing];
//    } failure:^(id object) {
//        kMeSTRONGSELF
//         [strongSelf.tableView.mj_header endRefreshing];
//    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrtype.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMineHomeCellStyle type = [_arrtype[indexPath.row] intValue];
    MEMineHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMineHomeCell class]) forIndexPath:indexPath];
    [cell setUiWithType:type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEMineHomeCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMineHomeCellStyle type = [_arrtype[indexPath.row] intValue];
    switch (type) {
        case MeMyDistribution:{
            //我的中心
            MEMyDistrbutionVC *dvc = [[MEMyDistrbutionVC alloc]initWithC];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyCentraManagertment:{
            //管理中心
            MEMyDistrbutionVC *dvc = [[MEMyDistrbutionVC alloc]init];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyAppointment:{
            MEMyAppointmentVC *dvc = [[MEMyAppointmentVC alloc]initWithType:MEAppointmenyUseing];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyExchange:{
            MEInteralExchangVC *dvc = [[MEInteralExchangVC alloc]init];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyCustomer:{
            MERCConversationListVC *cvc = [[MERCConversationListVC alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case MeMyCustomerPhone:{
            MEMineCustomerPhone *cvc = [[MEMineCustomerPhone alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case MeMyAddress:{
            MESelectAddressVC *address = [[MESelectAddressVC alloc]init];
            [self.navigationController pushViewController:address animated:YES];
        }
            break;
        case MeMyMobile:{
            MEMyMobileVC *mobile = [[MEMyMobileVC alloc]init];
            [self.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyActity:{
            MeMyActityMineVC *mobile = [[MeMyActityMineVC alloc]init];
            [self.navigationController pushViewController:mobile animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMineHomeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMineHomeCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEMineHomeHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEMineHomeHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEMineHomeHeaderViewHeight);
        kMeWEAKSELF
        _headerView.addPhoneBlock = ^{
            kMeSTRONGSELF
            [strongSelf.addTelVIew show];
        };
    }
    return _headerView;
}

- (MEAddTelView *)addTelVIew{
    if(!_addTelVIew){
        _addTelVIew = [[[NSBundle mainBundle]loadNibNamed:@"MEAddTelView" owner:nil options:nil] lastObject];
        _addTelVIew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        kMeWEAKSELF
        _addTelVIew.finishBlock = ^(BOOL sucess) {
            kMeSTRONGSELF
            [strongSelf.headerView reloadUIWithUserInfo];
            strongSelf.tableView.tableHeaderView = strongSelf.headerView;
        };
    }
    return _addTelVIew;
}

- (MEExpireTipView *)tipVIew{
    if(!_tipVIew){
        _tipVIew = [[[NSBundle mainBundle]loadNibNamed:@"MEExpireTipView" owner:nil options:nil] lastObject];
        _tipVIew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _tipVIew;
}


//- (MELoginVC *)loginVC{
//    if(!_loginVC){
//        _loginVC = [[MELoginVC alloc]init];
//        _loginVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _loginVC.btnReturn.hidden = YES;
//        _loginVC.view.frame = self.view.bounds;
//        [self addChildViewController:_loginVC];
//    }
//    return _loginVC;
//}


@end
