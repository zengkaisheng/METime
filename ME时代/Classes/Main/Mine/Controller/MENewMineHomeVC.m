//
//  MENewMineHomeVC.m
//  志愿星
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MENewMineHomeVC.h"
#import "MENewMineHomeHeaderView.h"
#import "MENewMineHomeCell.h"
#import "MEProductListVC.h"
#import "MENewMineHomeCodeHeaderView.h"
#import "AppDelegate.h"
#import "MEMineHomeMuneModel.h"

#import "MEMyDistrbutionVC.h"
#import "MEInteralExchangVC.h"
#import "MERCConversationListVC.h"
#import "MEMineCustomerPhone.h"
#import "MEMyMobileVC.h"
#import "MEMyOrderVC.h"

#import "MESelectAddressVC.h"
#import "MEMyAppointmentVC.h"
#import "MELoginVC.h"
#import "MEAddTelView.h"
#import "AppDelegate.h"
#import "MEExpireTipView.h"

#import "MEProductListVC.h"
#import "MeMyActityMineVC.h"
#import "MENewMineHomeVC.h"
#import "MEPosterListVC.h"
#import "MEArticelVC.h"
#import "MEVisiterHomeVC.h"
#import "MECouponOrderVC.h"
//#import "MEStoreApplyVC.h"
#import "MENewStoreApplyVC.h"
#import "MEStoreApplyModel.h"
#import "MEStoreApplyStatusVC.h"
#import "MEDynamicGoodApplyVC.h"
//#import "MEPAVistorVC.h"
#import "MEAIHomeVC.h"
#import "MEPNewAVistorVC.h"

#import "MECouponOrderVC.h"
#import "MEBStoreMannagerVC.h"
#import "MEMySelfExtractionOrderVC.h"
#import "MEBrandManngerVC.h"
#import "MEMoneyDetailedVC.h"
#import "MEMineNewShareVC.h"
#import "MEClerkManngerVC.h"
//#import "MEBDataDealVC.h"
#import "MEBdataVC.h"
#import "MEMyAppointmentVC.h"
#import "MEGetCaseMainSVC.h"
#import "MEWithdrawalVC.h"
#import "MEClerkStatisticsVC.h"
#import "MEDistributionOrderVC.h"
#import "MEDistributionMoneyVC.h"
#import "MEDistributionTeamVC.h"
#import "MEDistributionOrderMainVC.h"
#import "MENewMineCellHeaderView.h"
#import "MeHomeNewGuideVC.h"
#import "MECommonQuestionVC.h"

#import "MEBargainListVC.h"
#import "MEMyBargainListVC.h"
#import "MEMyGroupOrderVC.h"
#import "MEFeedBackVC.h"

#import "MEHomeTestVC.h"
#import "MEProjectSettingVC.h"
#import "MECourseOrderListVC.h"
#import "MEDiagnoseFeedBackVC.h"
#import "MEMyCollectionVC.h"
#import "MEDiagnoseOrderListVC.h"
#import "MEWaitingAnswerListVC.h"
#import "MEMineHomeMuneModel.h"
#import "MELianTongOrderVC.h"
#import "MELianTongCommissionVC.h"

@interface MENewMineHomeVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrtype;
    NSArray *_arrtypeTitle;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MENewMineHomeHeaderView *headerView;
@property (nonatomic, strong) MENewMineHomeCodeHeaderView *headerCodeView;
@property (nonatomic, strong) NSArray *memuList;
@property (nonatomic, strong) NSArray *orderList;
@property (nonatomic, strong) UIView *maskView; //蒙版
@property (nonatomic, strong) UIButton *changeStatusBtn;
@property (nonatomic, copy) NSString *invitation_code;

@end

@implementation MENewMineHomeVC 

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    self.invitation_code = @"";
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
    if([MEUserInfoModel isLogin]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnMeaasge) name:kUnMessage object:nil];
    }
//    NSInteger f = [[[NSUserDefaults standardUserDefaults] objectForKey:kcheckFirstBuy] integerValue];
//    if(f){
//        HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"提示" andMessage:@"您有一次免费预约门店服务的机会"];
//        alertView.isSupportRotating = YES;
//        [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
//        }];
//        kMeWEAKSELF
//        [alertView addButtonWithTitle:@"确定" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
//            kMeSTRONGSELF
//            MEProductListVC *productList = [[MEProductListVC alloc]initWithType:MEGoodsTypeNetServiceStyle];
//            [strongSelf.navigationController pushViewController:productList animated:YES];
//        }];
//        [alertView show];
//    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self getUnMeaasge];
    
    if ([MEUserInfoModel isLogin]) {
        if (kCurrentUser.user_type > 3) {
            if (_headerView) {
                _headerView.lblTel.text =  [NSString stringWithFormat:@"手机:%@",kMeUnNilStr(kCurrentUser.mobile)];
            }
        }else {
            if (_headerCodeView) {
                _headerCodeView.LblTel.text =  [NSString stringWithFormat:@"手机:%@",kMeUnNilStr(kCurrentUser.mobile)];
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)changeStatusAction {
    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
    if ([status isEqualToString:@"customer"]) {
        [kMeUserDefaults setObject:@"business" forKey:kMENowStatus];
    }else if ([status isEqualToString:@"business"]) {
        [kMeUserDefaults setObject:@"customer" forKey:kMENowStatus];
    }
    [kMeUserDefaults synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate reloadTabBar];
}

- (void)getUnMeaasge{
    if([MEUserInfoModel isLogin] && _arrtype.count && self.tableView){
        kMeWEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
             [strongSelf.tableView reloadData];
        });
    }
}

- (void)userLogout{
    [self.navigationController popToViewController:self animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUnMessage object:nil];
    [self.headerView clearUIWithUserInfo];
}

- (void)userLogin{
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnMeaasge) name:kUnMessage object:nil];
}

- (void)showHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];;
    hud.mode = MBProgressHUDModeIndeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

- (void)loadData{
    _changeStatusBtn.hidden = YES;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];;
    hud.mode = MBProgressHUDModeIndeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool getUserGetUserWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            NSLog(@"%@",kCurrentUser.uid);
//            kMeSTRONGSELF
            
//            switch (kCurrentUser.user_type) {
//                case 1:{
//                    //B
//                    //                strongSelf->_arrtype = @[@[@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeDynalApply),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MePAVistor)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData)]];
//                    //,@(MeHomeTest)每日测试
//
//                    /*
//                    if (kCurrentUser.identity_type == 0) {
//                        strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHometixian),@(MeHomejuanyngjing),@(MeHometuigcode)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                        strongSelf->_arrtypeTitle = @[@"商家管理",@"获客",@"必备"];
//                    }else {
//                        strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHometixian),@(MeHomejuanyngjing),@(MeHometuigcode)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                        strongSelf->_arrtypeTitle = @[@"商家管理",@"获客",@"必备"];
//                    }
//                     */
//
//                    if (kCurrentUser.identity_type == 0) {
//                        strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                        strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                    }else {
//                        strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                        strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                    }
//
//                }
//                    break;
//                case 2:{
//                    //
//                    //                strongSelf->_arrtype = @[@[@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeDynalApply),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MePAVistor)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData)]];
//                    /*
//                    if (kCurrentUser.identity_type == 0) {
//                        strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHometixian),@(MeHomejuanyngjing),@(MeHomepinpaigli),@(MeHometuigcode)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                        strongSelf->_arrtypeTitle = @[@"商家管理",@"获客",@"必备"];
//                    }else {
//                        strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHometixian),@(MeHomejuanyngjing),@(MeHomepinpaigli),@(MeHometuigcode)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                        strongSelf->_arrtypeTitle = @[@"商家管理",@"获客",@"必备"];
//                    }
//                    */
//                    if (kCurrentUser.identity_type == 0) {
//                        strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                        strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                    }else {
//                        strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                        strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                    }
//
//                }
//                    break;
//                case 4:{
//                    //C
//                    //                strongSelf->_arrtype = @[@[@(MeMyDistribution),@(MeMyExchange),@(MeMyAppointment),@(MeDynalApply),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply)]];
//                    if (kCurrentUser.identity_type == 0) {
//                        strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                        strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                    }else {
//                        strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                        strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                    }
//                }
//                    break;
//                case 3:{
//                    //B
//                    //                strongSelf->_arrtype = @[@[@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeDynalApply),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MePAVistor),@(MeAILEI)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData)]];
//
//                    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
//                    if ([status isEqualToString:@"customer"]) {
//                        /*
//                        if (kCurrentUser.audit.is_radar == 1) {
//                            if (kCurrentUser.identity_type == 0) {
//                                strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHomedianyuan),@(MeHomeyuyue),@(MeHomedata),@(MeHomedianpu),@(MeHometixian),@(MeHomejuanyngjing),@(MeHomeziti),@(MeAILEI),@(MeHometuigcode)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                                strongSelf->_arrtypeTitle = @[@"商家管理",@"获客",@"必备"];
//                            }else {
//                                strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHomedianyuan),@(MeHomeyuyue),@(MeHomedata),@(MeHomedianpu),@(MeHometixian),@(MeHomejuanyngjing),@(MeHomeziti),@(MeAILEI),@(MeHometuigcode)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                                strongSelf->_arrtypeTitle = @[@"商家管理",@"获客",@"必备"];
//                            }
//                        }else if (kCurrentUser.audit.is_radar == 2) {
//                            if (kCurrentUser.identity_type == 0) {
//                                strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHomedianyuan),@(MeHomeyuyue),@(MeHomedata),@(MeHomedianpu),@(MeHometixian),@(MeHomejuanyngjing),@(MeHomeziti),@(MeHometuigcode)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                                strongSelf->_arrtypeTitle = @[@"商家管理",@"必备"];
//                            }else {
//                                strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHomedianyuan),@(MeHomeyuyue),@(MeHomedata),@(MeHomedianpu),@(MeHometixian),@(MeHomejuanyngjing),@(MeHomeziti),@(MeHometuigcode)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                                strongSelf->_arrtypeTitle = @[@"商家管理",@"必备"];
//                            }
//                        }
//                        */
//                        if (kCurrentUser.identity_type == 0) {
//                            strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                            strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                        }else {
//                            strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                            strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                        }
//                    }else if ([status isEqualToString:@"business"]) {
//                        if (kCurrentUser.audit.is_radar == 1) {
//                            if (kCurrentUser.identity_type == 0) {
//                                strongSelf->_arrtype = @[@[@(MeHometuandui),@(MeHomeshangji),@(MeHomedianyuan),@(MEProjectSet),@(MeHometuigcode)],@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometixian),@(MeHomejuanyngjing),@(MECourseOrder)],@[@(MeHomeyuyue),@(MeHomedata),@(MeHomedianpu),@(MeHomeziti)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor),@(MeAILEI)],@[@(MEConsultQuestion),@(MEDiagnoseFeedBack),@(MEDiagnoseOrder),@(MeMyCollection),@(MeHomeNewGuide)]];
//                                strongSelf->_arrtypeTitle = @[@"商家管理",@"佣金",@"店铺",@"获客",@"必备"];
//                            }else {
//                                strongSelf->_arrtype = @[@[@(MeHometuandui),@(MeHomeshangji),@(MeHomedianyuan),@(MEProjectSet),@(MeHometuigcode)],@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometixian),@(MeHomejuanyngjing),@(MECourseOrder)],@[@(MeHomeyuyue),@(MeHomedata),@(MeHomedianpu),@(MeHomeziti)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor),@(MeAILEI)],@[@(MEConsultQuestion),@(MEDiagnoseFeedBack),@(MEDiagnoseOrder),@(MeMyCollection),@(MeHomeNewGuide),@(MEDiagnoseAnswer)]];
//                                strongSelf->_arrtypeTitle = @[@"商家管理",@"佣金",@"店铺",@"获客",@"必备"];
//                            }
//
//                        }else if (kCurrentUser.audit.is_radar == 2) {
//                            if (kCurrentUser.identity_type == 0) {
//                                strongSelf->_arrtype = @[@[@(MeHometuandui),@(MeHomeshangji),@(MeHomedianyuan),@(MEProjectSet),@(MeHometuigcode)],@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometixian),@(MeHomejuanyngjing),@(MECourseOrder)],@[@(MeHomeyuyue),@(MeHomedata),@(MeHomedianpu),@(MeHomeziti)],@[@(MEConsultQuestion),@(MEDiagnoseFeedBack),@(MEDiagnoseOrder),@(MeMyCollection),@(MeHomeNewGuide)]];
//                                strongSelf->_arrtypeTitle = @[@"商家管理",@"佣金",@"店铺",@"必备"];
//                            }else {
//                                strongSelf->_arrtype = @[@[@(MeHometuandui),@(MeHomeshangji),@(MeHomedianyuan),@(MEProjectSet),@(MeHometuigcode)],@[@(MeHomeyongjing),@(MeHomeorderall),@(MeHometixian),@(MeHomejuanyngjing),@(MECourseOrder)],@[@(MeHomeyuyue),@(MeHomedata),@(MeHomedianpu),@(MeHomeziti)],@[@(MEConsultQuestion),@(MEDiagnoseFeedBack),@(MEDiagnoseOrder),@(MeMyCollection),@(MeHomeNewGuide),@(MEDiagnoseAnswer)]];
//                                strongSelf->_arrtypeTitle = @[@"商家管理",@"佣金",@"店铺",@"必备"];
//                            }
//                        }
//                    }
//                }
//                    break;
//                case 5:{
//                    //clerk
//                    //                                strongSelf->_arrtype = @[@[@(MeMyDistribution),@(MeMyCentraManagertment),@(MeMyExchange),@(MeMyAppointment),@(MeMyActity),@(MeDynalApply),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MePAVistor),@(MeAILEI)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData)]];
//                    /*
//                    if (kCurrentUser.audit.is_radar == 1) {
//                        if (kCurrentUser.identity_type == 0) {
//                            strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomemeiodu),@(MeHomeCorderall),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHomeyuyue),@(MeHometixian),@(MeHomejuanyngjing),@(MeAILEI),@(Mehomeyongjitongji),@(MeHometuigcode)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                            strongSelf->_arrtypeTitle = @[@"商家管理",@"获客",@"必备"];
//                        }else {
//                            strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomemeiodu),@(MeHomeCorderall),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHomeyuyue),@(MeHometixian),@(MeHomejuanyngjing),@(MeAILEI),@(Mehomeyongjitongji),@(MeHometuigcode)],@[@(MeMyPoster),@(MeMyArticel),@(MemyData),@(MePAVistor)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                            strongSelf->_arrtypeTitle = @[@"商家管理",@"获客",@"必备"];
//                        }
//                    }else if (kCurrentUser.audit.is_radar == 2) {
//                        if (kCurrentUser.identity_type == 0) {
//                            strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomemeiodu),@(MeHomeCorderall),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHomeyuyue),@(MeHometixian),@(MeHomejuanyngjing),@(Mehomeyongjitongji),@(MeHometuigcode)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                            strongSelf->_arrtypeTitle = @[@"商家管理",@"必备"];
//                        }else {
//                            strongSelf->_arrtype = @[@[@(MeHomeyongjing),@(MeHomemeiodu),@(MeHomeCorderall),@(MeHomeorderall),@(MeHometuandui),@(MeHomeshangji),@(MeHomeyuyue),@(MeHometixian),@(MeHomejuanyngjing),@(Mehomeyongjitongji),@(MeHometuigcode)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyActity),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                            strongSelf->_arrtypeTitle = @[@"商家管理",@"必备"];
//                        }
//                     }
//                     */
//                    if (kCurrentUser.identity_type == 0) {
//                        strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack)]];
//                        strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                    }else {
//                        strongSelf->_arrtype = @[@[@(MeHomemeiodu),@(MeHomeCorderall),@(MeHometuandui),@(MeHometuigcode),@(MeHomejuanyngjing)],@[@(MeMyBargain),@(MeMyGroup),@(MeMyExchange),@(MeMyCustomer),@(MeMyCustomerPhone),@(MeMyAddress),@(MeMyMobile),@(MeStoreApply),@(MeHomeNewGuide),@(MeHomeCommonQuestion),@(MeMyFeedBack),@(MEDiagnoseAnswer)]];
//                        strongSelf->_arrtypeTitle = @[@"中心管理",@"必备"];
//                    }
//                }
//                    break;
//                default:{
//                    strongSelf->_arrtype = @[];
//                    strongSelf->_arrtypeTitle = @[];
//                }
//                    break;
//
//            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_barrier_sync(queue, ^{
        
    });
    
    dispatch_group_async(group, queue, ^{
        NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
        NSInteger type = 1;
        if ([status isEqualToString:@"business"]) {
            type = 2;
        }
        [MEPublicNetWorkTool getNewUserMenAlluDataWithType:type successBlock:^(ZLRequestResponse *responseObject) {
             kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                NSArray *memu = responseObject.data[@"menu"];
                strongSelf.memuList = [MEMineHomeMuneSubModel mj_objectArrayWithKeyValuesArray:memu];
                strongSelf.orderList = [MEMineHomeMuneChildrenModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"order"]];
                NSMutableArray *titles = [[NSMutableArray alloc] init];
                NSMutableArray *items = [[NSMutableArray alloc] init];
                NSMutableArray *childrens = [[NSMutableArray alloc] init];
                [strongSelf.memuList enumerateObjectsUsingBlock:^(MEMineHomeMuneSubModel *menuSubModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    [titles addObject:menuSubModel.name];
                    
                    [childrens addObjectsFromArray:menuSubModel.children];
                    //                    [menuModel.children enumerateObjectsUsingBlock:^(MEMineHomeMuneChildrenModel *subModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    //                        [childrens addObject:@([subModel.path intValue])];
                    //                    }];
                    [items addObject:[childrens mutableCopy]];
                    [childrens removeAllObjects];
                }];
                strongSelf->_arrtypeTitle = [titles mutableCopy];
                strongSelf->_arrtype = [items mutableCopy];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
        
        /*
        [MEPublicNetWorkTool getUserMenuDataWithType:type successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSArray class]]) {
                strongSelf.memuList = [MEMineHomeMuneModel mj_objectArrayWithKeyValuesArray:responseObject.data];
                NSMutableArray *titles = [[NSMutableArray alloc] init];
                NSMutableArray *items = [[NSMutableArray alloc] init];
                NSMutableArray *childrens = [[NSMutableArray alloc] init];
                [strongSelf.memuList enumerateObjectsUsingBlock:^(MEMineHomeMuneModel *menuModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    [titles addObject:menuModel.name];
                    
                    [childrens addObjectsFromArray:menuModel.children];
//                    [menuModel.children enumerateObjectsUsingBlock:^(MEMineHomeMuneChildrenModel *subModel, NSUInteger idx, BOOL * _Nonnull stop) {
//                        [childrens addObject:@([subModel.path intValue])];
//                    }];
                    [items addObject:[childrens mutableCopy]];
                    [childrens removeAllObjects];
                }];
                strongSelf->_arrtypeTitle = [titles mutableCopy];
                strongSelf->_arrtype = [items mutableCopy];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
         */
    });
    
    
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool getUserInvitationCodeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSString class]]) {
                strongSelf.invitation_code = [responseObject.data mutableCopy];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [hud hideAnimated:YES];
            kCurrentUser.invitation_code = strongSelf.invitation_code;
            [kCurrentUser save];
            if (strongSelf->_arrtypeTitle.count <=0 && strongSelf->_arrtype.count<=0) {
                kNoticeUserLogout
            }
            if (kCurrentUser.user_type < 3) {
                [strongSelf.headerView reloadUIWithUserInfo];
                strongSelf.tableView.tableHeaderView = strongSelf.headerView;
            }else {
                [strongSelf.headerCodeView reloadUIWithUserInfo];
                strongSelf.tableView.tableHeaderView = strongSelf.headerCodeView;
            }
            
            [strongSelf.tableView reloadData];
            [strongSelf.tableView.mj_header endRefreshing];
            
            if (kCurrentUser.user_type != 4) {
                NSString *firstIn = [kMeUserDefaults objectForKey:@"firstInMine"];
                if (!firstIn || firstIn.length <= 0) {
                    [strongSelf.view addSubview:strongSelf.maskView];
                }
            }
            if (kCurrentUser.user_type == 4) {
                strongSelf.changeStatusBtn.hidden = YES;
            }else {
                strongSelf.changeStatusBtn.hidden = NO;
            }
        });
    });
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrtype.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MENewMineHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewMineHomeCell class]) forIndexPath:indexPath];
    NSArray *arr = _arrtype[indexPath.row];
    NSString *title = _arrtypeTitle[indexPath.row];
    [cell setUIWithAtrr:arr title:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = _arrtype[indexPath.row];
//    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
//    if (indexPath.row == 0) {
//        if ([status isEqualToString:@"business"]) {
//            return [MENewMineHomeCell getHeightWithArr:arr]-37-15;
//        }
//    }
    return [MENewMineHomeCell getHeightWithArr:arr];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    [kMeUserDefaults setObject:@"isFirst" forKey:@"firstInMine"];
    [kMeUserDefaults synchronize];
    [self.maskView removeFromSuperview];
}

- (void)tapVCWithTypre:(NSInteger)type {
    switch (type) {
            //新
        case MeMenuHomemeiodu:{
            //我的中心
            MEMyDistrbutionVC *dvc = [[MEMyDistrbutionVC alloc]initWithC];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMenuHomeyongjing:{
            //我的佣金
            MEMyDistrbutionVC *dvc = [[MEMyDistrbutionVC alloc]init];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
            //        case MeMyMenuAppointment:{
            //            MEMyAppointmentVC *dvc = [[MEMyAppointmentVC alloc]initWithType:MEAppointmenyUseing];
            //            [homeVc.navigationController pushViewController:dvc animated:YES];
            //        }
            //            break;
        case MeMyMenuExchange:{
            MEInteralExchangVC *dvc = [[MEInteralExchangVC alloc]init];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyMenuCustomer:{
            MERCConversationListVC *cvc = [[MERCConversationListVC alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case MeMyMenuCustomerPhone:{
            MEMineCustomerPhone *cvc = [[MEMineCustomerPhone alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case MeMyMenuAddress:{
            MESelectAddressVC *address = [[MESelectAddressVC alloc]init];
            [self.navigationController pushViewController:address animated:YES];
        }
            break;
        case MeMyMenuMobile:{
            MEMyMobileVC *mobile = [[MEMyMobileVC alloc]init];
            [self.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyMenuActity:{
            MeMyActityMineVC *mobile = [[MeMyActityMineVC alloc]init];
            [self.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyMenuData:{
            MEVisiterHomeVC *mobile = [[MEVisiterHomeVC alloc]init];
            [self.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyMenuPoster:{
            MEPosterListVC *mobile = [[MEPosterListVC alloc]init];
            [self.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyMenuArticel:{
            MEArticelVC *mobile = [[MEArticelVC alloc]init];
            [self.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMenuStoreApply:{
            [MEPublicNetWorkTool postGetMemberStoreInfoWithsuccessBlock:^(ZLRequestResponse *responseObject) {
                if(![responseObject.data isKindOfClass:[NSDictionary class]] || responseObject.data==nil){
                    //                    MEStoreApplyVC *vc = [[MEStoreApplyVC alloc]init];
                    MENewStoreApplyVC *vc = [[MENewStoreApplyVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    MEStoreApplyModel *model = [MEStoreApplyModel mj_objectWithKeyValues:responseObject.data];
                    MEStoreApplyStatusVC *vc = [[MEStoreApplyStatusVC alloc]init];
                    vc.model = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failure:^(id object) {
                
            }];
        }
            break;
            //        case MeMenuDynalApply:{
            //            MEDynamicGoodApplyVC *vc = [[MEDynamicGoodApplyVC alloc]init];
            //            [homeVc.navigationController pushViewController:vc animated:YES];
            //        }
            //            break;
        case MeMenuPAVistor:{
            MEPNewAVistorVC *vc = [[MEPNewAVistorVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuAILEI:{
            MEAIHomeVC *vc = [[MEAIHomeVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHomeshangji:{
            MEMyMobileVC *mobile = [[MEMyMobileVC alloc]init];
            mobile.isSuper = YES;
            [self.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMenuHomeCorderall:{
            //C
            MEDistributionOrderMainVC *orderVC = [[MEDistributionOrderMainVC alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
            //        case MEDistributionMoney:{
            //            //            MEDistributionMoneyVC *vc = [[MEDistributionMoneyVC alloc]initWithModel:@""];
            //            //            [self.navigationController pushViewController:vc animated:YES];
            //        }
            
            break;
        case MeMenuHometuandui:{
//            MEDistributionTeamVC *vc = [[MEDistributionTeamVC alloc]initWithType:_type];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHomeorderall:{
            //C以上
            MEMoneyDetailedVC *vc = [[MEMoneyDetailedVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHometuigcode:{
//            MEMineNewShareVC *vc = [[MEMineNewShareVC alloc]initWithLevel:_levStr];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MeMenuHomedianyuan:{
            MEClerkManngerVC *clerkVC = [[MEClerkManngerVC alloc]init];
            [self.navigationController pushViewController:clerkVC animated:YES];
        }
            break;
        case MeMenuHomeyuyue:{
            MEMyAppointmentVC *dvc = [[MEMyAppointmentVC alloc]initWithType:MEAppointmenyUseing userType:MEClientBTypeStyle];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
            
        case MeMenuHomedata:{
            MEBdataVC *vc = [[MEBdataVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHomeyongjitongji:{
            MEClerkStatisticsVC *vc = [[MEClerkStatisticsVC alloc]initWithType:MEClientTypeClerkStyle memberId:@""];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHometixian:{
            MEGetCaseMainSVC *vc = [[MEGetCaseMainSVC alloc]initWithType:MEGetCaseAllStyle isLianTong:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHomejuanyngjing:{
            MECouponOrderVC *couponVC = [[MECouponOrderVC alloc]init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case MeMenuHomedianpu:{
            MEBStoreMannagerVC *storeVC = [[MEBStoreMannagerVC alloc]init];
            [self.navigationController pushViewController:storeVC animated:YES];
        }
            break;
        case MeMenuHomeziti:{
            MEMySelfExtractionOrderVC *orderVC = [[MEMySelfExtractionOrderVC alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case MeMenuHomepinpaigli:{
            MEBrandManngerVC *brandVC = [[MEBrandManngerVC alloc]init];
            [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case MeMenuHomeNewGuide:{
            MeHomeNewGuideVC *brandVC = [[MeHomeNewGuideVC alloc]init];
            [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case MeMenuHomeCommonQuestion:{
            MECommonQuestionVC *questionVC = [[MECommonQuestionVC alloc]init];
            [self.navigationController pushViewController:questionVC animated:YES];
        }
            break;
        case MeMenuMyBargain:{
            MEMyBargainListVC *bargainVC = [[MEMyBargainListVC alloc]init];
            bargainVC.callBackBlock = ^{
                MEBargainListVC *listVC = [[MEBargainListVC alloc] init];
                [self.navigationController pushViewController:listVC animated:YES];
            };
            [self.navigationController pushViewController:bargainVC animated:YES];
        }
            break;
        case MeMenuMyGroup:{
            MEMyGroupOrderVC *groupVC = [[MEMyGroupOrderVC alloc]init];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
            break;
        case MeMenuMyFeedBack:{
            MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
            //        case MeMenuHomeTest:{
            //            MEHomeTestVC *vc = [[MEHomeTestVC alloc]init];
            //            [homeVc.navigationController pushViewController:vc animated:YES];
            //        }
            //            break;
        case MEMenuProjectSet:{//项目设置
            MEProjectSettingVC *vc = [[MEProjectSettingVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMenuCourseOrder:{//课程订单
            MECourseOrderListVC *vc = [[MECourseOrderListVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMenuConsultQuestion:{//问题咨询
            MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc] initWithType:1];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case MEMenuDiagnoseFeedBack:{//诊断反馈
            MEDiagnoseFeedBackVC *vc = [[MEDiagnoseFeedBackVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuCollection:{//我的收藏
            MEMyCollectionVC *vc = [[MEMyCollectionVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMenuDiagnoseOrder:{//我的诊断订单/方案订单/美店方案
            MEDiagnoseOrderListVC *vc = [[MEDiagnoseOrderListVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMenuDiagnoseAnswer:{//诊断回复
            MEWaitingAnswerListVC *vc = [[MEWaitingAnswerListVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuLianTong:{//联通订单
            MELianTongOrderVC *vc = [[MELianTongOrderVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuLianTongTopUp:{//联通充值MeMyMenuLianTongCommission
            MELianTongOrderVC *vc = [[MELianTongOrderVC alloc]init];
            vc.isTopUp = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuLianTongCommission:{//联通佣金
            MELianTongCommissionVC *vc = [[MELianTongCommissionVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuAllOrder:{//商品订单
            MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllOrder];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma MARK - Setter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewMineHomeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewMineHomeCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor =  [UIColor colorWithHexString:@"fafafa"];
    }
    return _tableView;
}

- (MENewMineHomeHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MENewMineHomeHeaderView" owner:nil options:nil] lastObject];
//        CGFloat height = kMENewMineHomeHeaderViewHeight+85;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMENewMineHomeHeaderViewHeight);
        _headerView.orderList = self.orderList;
        _headerView.changeStatus = ^{
            NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
            if ([status isEqualToString:@"customer"]) {
                [kMeUserDefaults setObject:@"business" forKey:kMENowStatus];
            }else if ([status isEqualToString:@"business"]) {
                [kMeUserDefaults setObject:@"customer" forKey:kMENowStatus];
            }
            [kMeUserDefaults synchronize];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate reloadTabBar];
        };
        kMeWEAKSELF
        _headerView.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            [strongSelf tapVCWithTypre:index];
        };
    }
    return _headerView;
}

- (MENewMineHomeCodeHeaderView *)headerCodeView{
    if(!_headerCodeView){
        _headerCodeView = [[[NSBundle mainBundle]loadNibNamed:@"MENewMineHomeCodeHeaderView" owner:nil options:nil] lastObject];
//        CGFloat height = kMENewMineHomeCodeHeaderViewHeight+85;
        _headerCodeView.orderList = self.orderList;
        _headerCodeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMENewMineHomeCodeHeaderViewHeight);
        _headerCodeView.changeStatus = ^{
            NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
            if ([status isEqualToString:@"customer"]) {
                [kMeUserDefaults setObject:@"business" forKey:kMENowStatus];
            }else if ([status isEqualToString:@"business"]) {
                [kMeUserDefaults setObject:@"customer" forKey:kMENowStatus];
            }
            [kMeUserDefaults synchronize];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate reloadTabBar];
        };
        kMeWEAKSELF
        _headerCodeView.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            [strongSelf tapVCWithTypre:index];
        };
    }
    return _headerCodeView;
}

- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.8;
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesmask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTap:)];
        [_maskView addGestureRecognizer:gesmask];
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"切换样式 " forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"icon_changeStatus"] forState:UIControlStateNormal];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        btn.frame = CGRectMake(SCREEN_WIDTH-15-109, 87, 109, 32);
//        btn.layer.cornerRadius = 16;
//        btn.backgroundColor = [UIColor colorWithHexString:@"#19A8C9"];
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 0);
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
//        btn.enabled = NO;
        
        UIButton *changeStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeStatusBtn.frame = CGRectMake(SCREEN_WIDTH-84, 88, 84, 32);
        changeStatusBtn.backgroundColor = [UIColor colorWithHexString:@"#FFAFAF"];//#2ED9A4
        [changeStatusBtn setImage:[UIImage imageNamed:@"icon_changeStatusNew"] forState:UIControlStateNormal];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 84, 32) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 84, 32);
        maskLayer.path = maskPath.CGPath;
        changeStatusBtn.layer.mask = maskLayer;
        
        [_maskView addSubview:changeStatusBtn];
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineGuide"]];
        imgV.frame = CGRectMake(40, CGRectGetMaxY(changeStatusBtn.frame)+2, SCREEN_WIDTH-80, (SCREEN_WIDTH-80));
        [_maskView addSubview:imgV];
    }
    return _maskView;
}

- (UIButton *)changeStatusBtn {
    if (!_changeStatusBtn) {
        _changeStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeStatusBtn.frame = CGRectMake(SCREEN_WIDTH-84, 88, 84, 32);
        _changeStatusBtn.backgroundColor = [UIColor colorWithHexString:@"#FFAFAF"];
        [_changeStatusBtn setImage:[UIImage imageNamed:@"icon_changeStatusNew"] forState:UIControlStateNormal];
        [_changeStatusBtn addTarget:self action:@selector(changeStatusAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_changeStatusBtn];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 84, 32) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 84, 32);
        maskLayer.path = maskPath.CGPath;
        _changeStatusBtn.layer.mask = maskLayer;
        _changeStatusBtn.hidden = YES;
    }
    return _changeStatusBtn;
}

@end
