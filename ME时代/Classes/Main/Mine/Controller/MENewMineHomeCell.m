//
//  MENewMineHomeCell.m
//  志愿星
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MENewMineHomeCell.h"
#import "MENewMineHomeContentCell.h"
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
#import "MEMyVIPVC.h"
#import "MEProductShoppingCartVC.h"

#import "MECommissionBaseVC.h"
#import "MESignUpActivityVC.h"
#import "MESignInActivityVC.h"
#import "MEMyAttentionVC.h"

@interface MENewMineHomeCell()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_arrModel;
    MEClientTypeStyle _type;
    NSString *_levStr;
    NSString *_title;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConsTop;

@end

@implementation MENewMineHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    _arrModel = @[];
    [self initSomeThing];
}

- (void)initSomeThing{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewMineHomeContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MENewMineHomeContentCell class])];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"HeaderView"];
    [_collectionView  registerNib:[UINib nibWithNibName:NSStringFromClass([MENewMineCellHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewMineCellHeaderView class])];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

#pragma mark- CollectionView Delegate And DataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MENewMineHomeVC *homeVc = [MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    if(!homeVc){
        return;
    }
//    MEMineHomeMenuCellStyle type = [_arrModel[indexPath.row] intValue];
    MEMineHomeMuneChildrenModel *childModel = _arrModel[indexPath.row];
    switch ([childModel.path intValue]) {
            /*
        case MeHomemeiodu:{
            //我的中心
            MEMyDistrbutionVC *dvc = [[MEMyDistrbutionVC alloc]initWithC];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeHomeyongjing:{
            //管理中心
            MEMyDistrbutionVC *dvc = [[MEMyDistrbutionVC alloc]init];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyAppointment:{
            MEMyAppointmentVC *dvc = [[MEMyAppointmentVC alloc]initWithType:MEAppointmenyUseing];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyExchange:{
            MEInteralExchangVC *dvc = [[MEInteralExchangVC alloc]init];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyCustomer:{
            MERCConversationListVC *cvc = [[MERCConversationListVC alloc]init];
            [homeVc.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case MeMyCustomerPhone:{
            MEMineCustomerPhone *cvc = [[MEMineCustomerPhone alloc]init];
            [homeVc.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case MeMyAddress:{
            MESelectAddressVC *address = [[MESelectAddressVC alloc]init];
            [homeVc.navigationController pushViewController:address animated:YES];
        }
            break;
        case MeMyMobile:{
            MEMyMobileVC *mobile = [[MEMyMobileVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyActity:{
            MeMyActityMineVC *mobile = [[MeMyActityMineVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MemyData:{
            MEVisiterHomeVC *mobile = [[MEVisiterHomeVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyPoster:{
            MEPosterListVC *mobile = [[MEPosterListVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyArticel:{
            MEArticelVC *mobile = [[MEArticelVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeStoreApply:{
            [MEPublicNetWorkTool postGetMemberStoreInfoWithsuccessBlock:^(ZLRequestResponse *responseObject) {
                if(![responseObject.data isKindOfClass:[NSDictionary class]] || responseObject.data==nil){
//                    MEStoreApplyVC *vc = [[MEStoreApplyVC alloc]init];
                    MENewStoreApplyVC *vc = [[MENewStoreApplyVC alloc] init];
                    [homeVc.navigationController pushViewController:vc animated:YES];
                }else{
                    MEStoreApplyModel *model = [MEStoreApplyModel mj_objectWithKeyValues:responseObject.data];
                    MEStoreApplyStatusVC *vc = [[MEStoreApplyStatusVC alloc]init];
                    vc.model = model;
                    [homeVc.navigationController pushViewController:vc animated:YES];
                }
            } failure:^(id object) {
                
            }];
        }
            break;
        case MeDynalApply:{
            MEDynamicGoodApplyVC *vc = [[MEDynamicGoodApplyVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MePAVistor:{
            MEPNewAVistorVC *vc = [[MEPNewAVistorVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeAILEI:{
            MEAIHomeVC *vc = [[MEAIHomeVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeHomeshangji:{
            MEMyMobileVC *mobile = [[MEMyMobileVC alloc]init];
            mobile.isSuper = YES;
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeHomeCorderall:{
            //C
            MEDistributionOrderMainVC *orderVC = [[MEDistributionOrderMainVC alloc]init];
            [homeVc.navigationController pushViewController:orderVC animated:YES];
        }
            
            break;
//        case MEDistributionMoney:{
//            //            MEDistributionMoneyVC *vc = [[MEDistributionMoneyVC alloc]initWithModel:@""];
//            //            [self.navigationController pushViewController:vc animated:YES];
//        }
            
            break;
        case MeHometuandui:{
            MEDistributionTeamVC *vc = [[MEDistributionTeamVC alloc]initWithType:_type];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeHomeorderall:{
            //C以上
            MEMoneyDetailedVC *vc = [[MEMoneyDetailedVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeHometuigcode:{
            MEMineNewShareVC *vc = [[MEMineNewShareVC alloc]initWithLevel:_levStr];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MeHomedianyuan:{
            MEClerkManngerVC *clerkVC = [[MEClerkManngerVC alloc]init];
            [homeVc.navigationController pushViewController:clerkVC animated:YES];
        }
            break;
            
        case MeHomeyuyue:{
            MEMyAppointmentVC *dvc = [[MEMyAppointmentVC alloc]initWithType:MEAppointmenyUseing userType:MEClientBTypeStyle];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
            
        case MeHomedata:{
            MEBdataVC *vc = [[MEBdataVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Mehomeyongjitongji:{
            MEClerkStatisticsVC *vc = [[MEClerkStatisticsVC alloc]initWithType:MEClientTypeClerkStyle memberId:@""];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeHometixian:{
            MEGetCaseMainSVC *vc = [[MEGetCaseMainSVC alloc]initWithType:MEGetCaseAllStyle];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeHomejuanyngjing:{
            MECouponOrderVC *couponVC = [[MECouponOrderVC alloc]init];
            [homeVc.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case MeHomedianpu:{
            MEBStoreMannagerVC *storeVC = [[MEBStoreMannagerVC alloc]init];
            [homeVc.navigationController pushViewController:storeVC animated:YES];
        }
            break;
        case MeHomeziti:{
            MEMySelfExtractionOrderVC *orderVC = [[MEMySelfExtractionOrderVC alloc]init];
            [homeVc.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case MeHomepinpaigli:{
            MEBrandManngerVC *brandVC = [[MEBrandManngerVC alloc]init];
            [homeVc.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case MeHomeNewGuide:{
            MeHomeNewGuideVC *brandVC = [[MeHomeNewGuideVC alloc]init];
            [homeVc.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case MeHomeCommonQuestion:{
            MECommonQuestionVC *questionVC = [[MECommonQuestionVC alloc]init];
            [homeVc.navigationController pushViewController:questionVC animated:YES];
        }
            break;
        case MeMyBargain:{
            MEMyBargainListVC *bargainVC = [[MEMyBargainListVC alloc]init];
            bargainVC.callBackBlock = ^{
                MEBargainListVC *listVC = [[MEBargainListVC alloc] init];
                [homeVc.navigationController pushViewController:listVC animated:YES];
            };
            [homeVc.navigationController pushViewController:bargainVC animated:YES];
        }
            break;
        case MeMyGroup:{
            MEMyGroupOrderVC *groupVC = [[MEMyGroupOrderVC alloc]init];
            [homeVc.navigationController pushViewController:groupVC animated:YES];
        }
            break;
        case MeMyFeedBack:{
            MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc]init];
            [homeVc.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case MeHomeTest:{
            MEHomeTestVC *vc = [[MEHomeTestVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEProjectSet:{//项目设置
            MEProjectSettingVC *vc = [[MEProjectSettingVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MECourseOrder:{//课程订单
            MECourseOrderListVC *vc = [[MECourseOrderListVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEConsultQuestion:{//问题咨询
            MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc] initWithType:1];
            [homeVc.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case MEDiagnoseFeedBack:{//诊断反馈
            MEDiagnoseFeedBackVC *vc = [[MEDiagnoseFeedBackVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyCollection:{//我的收藏
            MEMyCollectionVC *vc = [[MEMyCollectionVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEDiagnoseOrder:{//我的诊断订单
            MEDiagnoseOrderListVC *vc = [[MEDiagnoseOrderListVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEDiagnoseAnswer:{
            MEWaitingAnswerListVC *vc = [[MEWaitingAnswerListVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
             */
            //新
        case MeMenuHomemeiodu:{
            //我的中心
            MEMyDistrbutionVC *dvc = [[MEMyDistrbutionVC alloc]initWithC];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMenuHomeyongjing:{
            //我的佣金
            MEMyDistrbutionVC *dvc = [[MEMyDistrbutionVC alloc]init];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyMenuExchange:{
            MEInteralExchangVC *dvc = [[MEInteralExchangVC alloc]init];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyMenuCustomer:{
            MERCConversationListVC *cvc = [[MERCConversationListVC alloc]init];
            [homeVc.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case MeMyMenuCustomerPhone:{
            MEMineCustomerPhone *cvc = [[MEMineCustomerPhone alloc]init];
            [homeVc.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case MeMyMenuAddress:{
            MESelectAddressVC *address = [[MESelectAddressVC alloc]init];
            [homeVc.navigationController pushViewController:address animated:YES];
        }
            break;
        case MeMyMenuMobile:{
            MEMyMobileVC *mobile = [[MEMyMobileVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyMenuActity:{
            MeMyActityMineVC *mobile = [[MeMyActityMineVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyMenuData:{
            MEVisiterHomeVC *mobile = [[MEVisiterHomeVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyMenuPoster:{
            MEPosterListVC *mobile = [[MEPosterListVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMyMenuArticel:{
            MEArticelVC *mobile = [[MEArticelVC alloc]init];
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMenuStoreApply:{
            [MEPublicNetWorkTool postGetMemberStoreInfoWithsuccessBlock:^(ZLRequestResponse *responseObject) {
                if(![responseObject.data isKindOfClass:[NSDictionary class]] || responseObject.data==nil){
                    //                    MEStoreApplyVC *vc = [[MEStoreApplyVC alloc]init];
                    MENewStoreApplyVC *vc = [[MENewStoreApplyVC alloc] init];
                    [homeVc.navigationController pushViewController:vc animated:YES];
                }else{
                    MEStoreApplyModel *model = [MEStoreApplyModel mj_objectWithKeyValues:responseObject.data];
                    MEStoreApplyStatusVC *vc = [[MEStoreApplyStatusVC alloc]init];
                    vc.model = model;
                    [homeVc.navigationController pushViewController:vc animated:YES];
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
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuAILEI:{
            MEAIHomeVC *vc = [[MEAIHomeVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHomeshangji:{
            MEMyMobileVC *mobile = [[MEMyMobileVC alloc]init];
            mobile.isSuper = YES;
            [homeVc.navigationController pushViewController:mobile animated:YES];
        }
            break;
        case MeMenuHomeCorderall:{
            //C
            MEDistributionOrderMainVC *orderVC = [[MEDistributionOrderMainVC alloc]init];
            [homeVc.navigationController pushViewController:orderVC animated:YES];
        }
            break;
            //        case MEDistributionMoney:{
            //            //            MEDistributionMoneyVC *vc = [[MEDistributionMoneyVC alloc]initWithModel:@""];
            //            //            [self.navigationController pushViewController:vc animated:YES];
            //        }
            
            break;
        case MeMenuHometuandui:{
            MEDistributionTeamVC *vc = [[MEDistributionTeamVC alloc]initWithType:_type];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHomeorderall:{
            //C以上
//            MEMoneyDetailedVC *vc = [[MEMoneyDetailedVC alloc]init];
            MECommissionBaseVC *vc = [[MECommissionBaseVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHometuigcode:{
            MEMineNewShareVC *vc = [[MEMineNewShareVC alloc]initWithLevel:_levStr];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MeMenuHomedianyuan:{
            MEClerkManngerVC *clerkVC = [[MEClerkManngerVC alloc]init];
            [homeVc.navigationController pushViewController:clerkVC animated:YES];
        }
            break;
        case MeMenuHomeyuyue:{
            MEMyAppointmentVC *dvc = [[MEMyAppointmentVC alloc]initWithType:MEAppointmenyUseing userType:MEClientBTypeStyle];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
            
        case MeMenuHomedata:{
            MEBdataVC *vc = [[MEBdataVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHomeyongjitongji:{
            MEClerkStatisticsVC *vc = [[MEClerkStatisticsVC alloc]initWithType:MEClientTypeClerkStyle memberId:@""];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHometixian:{
            MEGetCaseMainSVC *vc = [[MEGetCaseMainSVC alloc]initWithType:MEGetCaseAllStyle isLianTong:NO];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuHomejuanyngjing:{
            MECouponOrderVC *couponVC = [[MECouponOrderVC alloc]init];
            [homeVc.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case MeMenuHomedianpu:{
            MEBStoreMannagerVC *storeVC = [[MEBStoreMannagerVC alloc]init];
            [homeVc.navigationController pushViewController:storeVC animated:YES];
        }
            break;
        case MeMenuHomeziti:{
            MEMySelfExtractionOrderVC *orderVC = [[MEMySelfExtractionOrderVC alloc]init];
            [homeVc.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case MeMenuHomepinpaigli:{
            MEBrandManngerVC *brandVC = [[MEBrandManngerVC alloc]init];
            [homeVc.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case MeMenuHomeNewGuide:{
            MeHomeNewGuideVC *brandVC = [[MeHomeNewGuideVC alloc]init];
            [homeVc.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case MeMenuHomeCommonQuestion:{
            MECommonQuestionVC *questionVC = [[MECommonQuestionVC alloc]init];
            [homeVc.navigationController pushViewController:questionVC animated:YES];
        }
            break;
        case MeMenuMyBargain:{
            MEMyBargainListVC *bargainVC = [[MEMyBargainListVC alloc]init];
            bargainVC.callBackBlock = ^{
                MEBargainListVC *listVC = [[MEBargainListVC alloc] init];
                [homeVc.navigationController pushViewController:listVC animated:YES];
            };
            [homeVc.navigationController pushViewController:bargainVC animated:YES];
        }
            break;
        case MeMenuMyGroup:{
            MEMyGroupOrderVC *groupVC = [[MEMyGroupOrderVC alloc]init];
            [homeVc.navigationController pushViewController:groupVC animated:YES];
        }
            break;
        case MeMenuMyFeedBack:{
            MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc]init];
            [homeVc.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
//        case MeMenuHomeTest:{
//            MEHomeTestVC *vc = [[MEHomeTestVC alloc]init];
//            [homeVc.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        case MEMenuProjectSet:{//项目设置
            MEProjectSettingVC *vc = [[MEProjectSettingVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMenuCourseOrder:{//课程订单
            MECourseOrderListVC *vc = [[MECourseOrderListVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMenuConsultQuestion:{//问题咨询
            MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc] initWithType:1];
            [homeVc.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case MEMenuDiagnoseFeedBack:{//诊断反馈
            MEDiagnoseFeedBackVC *vc = [[MEDiagnoseFeedBackVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuCollection:{//我的收藏
            MEMyCollectionVC *vc = [[MEMyCollectionVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMenuDiagnoseOrder:{//我的诊断订单/方案订单
            MEDiagnoseOrderListVC *vc = [[MEDiagnoseOrderListVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMenuDiagnoseAnswer:{//诊断回复
            MEWaitingAnswerListVC *vc = [[MEWaitingAnswerListVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuLianTong:{//联通订单
            MELianTongOrderVC *vc = [[MELianTongOrderVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuLianTongTopUp:{//联通充值MeMyMenuLianTongCommission
            MELianTongOrderVC *vc = [[MELianTongOrderVC alloc]init];
            vc.isTopUp = YES;
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuLianTongCommission:{//联通佣金
            MELianTongCommissionVC *vc = [[MELianTongCommissionVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuVIP:{//我的VIP
            MEMyVIPVC *vc = [[MEMyVIPVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuShopCart:{//我的购物车
            MEProductShoppingCartVC *vc = [[MEProductShoppingCartVC alloc]init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuAppointment:{//我的预约
            MEMyAppointmentVC *dvc = [[MEMyAppointmentVC alloc]initWithType:MEAppointmenyUseing];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyMenuOrganizationEnter:{//组织入驻
            
        }
            break;
        case MeMyMenuMyFunds:{//我的资金
            
        }
            break;
        case MeMyMenuMyComment:{//我的评论

        }
            break;
        case MeMyMenuMySignUpActivity:{//已报名的活动
            MESignUpActivityVC *vc = [[MESignUpActivityVC alloc] init];
            [homeVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMyMenuMySignInActivity:{//已签到的活动
            MESignInActivityVC *dvc = [[MESignInActivityVC alloc] init];
            [homeVc.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case MeMyMenuMyAttention:{//我的关注
            MEMyAttentionVC *dvc = [[MEMyAttentionVC alloc] init];
            [homeVc.navigationController pushViewController:dvc animated:YES];
            }
            break;
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MENewMineHomeContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MENewMineHomeContentCell class]) forIndexPath:indexPath];
//    MEMineHomeMenuCellStyle type = [_arrModel[indexPath.row] intValue];
//    [cell setUIWithType:type];
    MEMineHomeMuneChildrenModel *childModel = _arrModel[indexPath.row];
    [cell setUIWithModel:childModel];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 25);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
//    if ([_title isEqualToString:@"商家"]) {
//        if ([status isEqualToString:@"business"]) {
//            return CGSizeZero;
//        }
//    }
    return CGSizeMake(SCREEN_WIDTH-30, kMENewMineCellHeaderViewHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        headerView.backgroundColor = [UIColor whiteColor];
//        UILabel *lbl = [MEView lblWithFram:CGRectMake(15, 0, SCREEN_WIDTH-60, 37) textColor:kMEblack str:kMeUnNilStr(_title) font:kMeFont(13)];
//        lbl.backgroundColor = [UIColor whiteColor];
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH-30, 1)];
//        view.backgroundColor = [UIColor colorWithHexString:@"F2F1F1"];
//        [headerView addSubview:lbl];
//        [headerView addSubview:view];
//        return headerView;
        MENewMineCellHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewMineCellHeaderView class]) forIndexPath:indexPath];
        reusableView.lblTitle.text = kMeUnNilStr(_title);
        return reusableView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMENewMineHomeContentCellWdith, kMENewMineHomeContentCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)setUIWithAtrr:(NSArray *)arr title:(NSString*)title{
    _arrModel = kMeUnArr(arr);
    _title = kMeUnNilStr(title);
    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];

//    if ([_title isEqualToString:@"商家"]) {
//        if ([status isEqualToString:@"business"]) {
//            _viewConsTop.constant = 0.0;
//        }
//    }else {
//        _viewConsTop.constant = 15.0;
//    }
    switch (kCurrentUser.user_type) {
        case 1:{
            _type = MEClientOneTypeStyle;
            _levStr = @"当前等级:售后中心";
        }
            break;
        case 2:{
            _type = MEClientTwoTypeStyle;
            _levStr = @"当前等级:营销中心";
        }
            break;
        case 4:{
            //C
            _type = MEClientCTypeStyle;
            _levStr = @"当前等级:普通会员";
        }
            break;
        case 3:{
            //B
            _type = MEClientBTypeStyle;
            _levStr = @"当前等级:体验中心";

        }
            break;
        case 5:{
            //clerk
            _type = MEClientTypeClerkStyle;
            _levStr = @"当前等级:店员";

        }
            break;
        default:{
            _type = MEClientTypeErrorStyle;
            _levStr = @"";
        }
            break;
    }
    [_collectionView reloadData];
}

+ (CGFloat)getHeightWithArr:(NSArray *)arr{
    if(arr.count == 0){
        return 0;
    }
    NSInteger section = (arr.count/3)+((arr.count%3)>0?1:0);
    CGFloat height = (section * kMENewMineHomeContentCellHeight)+25+15+37;
    return height;
}

@end
