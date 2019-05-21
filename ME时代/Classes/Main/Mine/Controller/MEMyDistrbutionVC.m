//
//  MEMyDistrbutionVC.m
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//
//
#import "MEMyDistrbutionVC.h"
#import "MEMyDistributionReusableView.h"
#import "MEDistrbutionCell.h"
#import "MEDistributionOrderVC.h"
#import "MEDistributionMoneyVC.h"
#import "MEDistributionTeamVC.h"
#import "MEDistributionOrderMainVC.h"
#import "MEDistributionCentreModel.h"
#import "MEMoneyDetailedVC.h"
#import "MEMineNewShareVC.h"
#import "MEClerkManngerVC.h"
//#import "MEBDataDealVC.h"
#import "MEBdataVC.h"
#import "MEMyAppointmentVC.h"
#import "MEGetCaseMainSVC.h"
#import "MEWithdrawalVC.h"
#import "MEClerkStatisticsVC.h"
//b端model
#import "MEadminDistributionModel.h"
#import "MECouponOrderVC.h"
#import "MEBStoreMannagerVC.h"
#import "MEMySelfExtractionOrderVC.h"
#import "MEBrandManngerVC.h"

@interface MEMyDistrbutionVC ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    //c端model
    MEDistributionCentreModel *_cModel;
    MEadminDistributionModel *_bModel;
    MEClientTypeStyle _type;
    NSString *_levStr;
}

@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic)  NSArray *arrData;
@property (strong, nonatomic)  NSArray *arrDataStr;
@end

@implementation MEMyDistrbutionVC

- (instancetype)initWithC{
    //我的中心入口
    if(self = [super init]){
        _type = MEClientCTypeStyle;
    }
    return self;
}

- (instancetype)init{
    if(self = [super init]){
        switch (kCurrentUser.user_type) {
            case 1:{
                _type = MEClientOneTypeStyle;
            }
                break;
            case 2:{
                _type = MEClientTwoTypeStyle;
            }
                break;
            case 4:{
                //C
                _type = MEClientCTypeStyle;
            }
                break;
            case 3:{
                //B
                _type = MEClientBTypeStyle;
            }
                break;
            case 5:{
                //clerk
                _type = MEClientTypeClerkStyle;
            }
                break;
            default:{
                _type = MEClientTypeErrorStyle;
            }
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = _type==MEClientCTypeStyle?@"我的中心":@"管理中心";
    self.title = _type==MEClientCTypeStyle?@"我的美豆":@"我的佣金";
    _levStr = @"";
    _arrData = @[];
    _arrDataStr = @[];
    _bModel = [MEadminDistributionModel new];
    _cModel = [MEDistributionCentreModel new];
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.collectionView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)loadData{
    _levStr = @"";
    kMeWEAKSELF
    
    if(_type == MEClientBTypeStyle){
        [MEPublicNetWorkTool getAdminDistributionWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_bModel = [MEadminDistributionModel mj_objectWithKeyValues:responseObject.data];
            //订单总额
//            CGFloat allMoney = strongSelf->_bModel.use_money + strongSelf->_bModel.ratio_money;
//            strongSelf->_arrData = @[@(MEMyMoney),@(MEMyTeam),@(MEMyLeave),@(MEMySuperior),@(MEMyCode),@(MEMyClerk),@(MEMyAppintMannger),@(MEMyDataDeal),@(MEMyCash),@(MEMyCouponMoney),@(MEMyStoreMannager),@(MEMySelfExtractionOrder)];
//            strongSelf->_arrDataStr = @[[NSString stringWithFormat:@"%.2f",allMoney],[NSString stringWithFormat:@"%@",@(strongSelf->_bModel.admin_team)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_bModel.level)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_bModel.superior)],@"",@"",@"",@"",@"",@"",@"",@""];
            strongSelf->_levStr = [NSString stringWithFormat:@"当前等级:%@",kMeUnNilStr(strongSelf->_bModel.level)];
            [strongSelf.collectionView reloadData];
            [strongSelf.collectionView.mj_header endRefreshing];
        } failure:^(id object) {
            kMeSTRONGSELF
             [strongSelf.collectionView.mj_header endRefreshing];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else if(_type == MEClientOneTypeStyle){
        [MEPublicNetWorkTool getAdminDistributionWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_bModel = [MEadminDistributionModel mj_objectWithKeyValues:responseObject.data];
            //订单总额
//            CGFloat allMoney = strongSelf->_bModel.use_money + strongSelf->_bModel.ratio_money;
//            strongSelf->_arrData = @[@(MEMyMoney),@(MEMyTeam),@(MEMyLeave),@(MEMySuperior),@(MEMyCode),@(MEMyDataDeal),@(MEMyCash),@(MEMyCouponMoney)];
//            strongSelf->_arrDataStr = @[[NSString stringWithFormat:@"%.2f",allMoney],[NSString stringWithFormat:@"%@",@(strongSelf->_bModel.admin_team)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_bModel.level)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_bModel.superior)],@"",@"",@"",@""];
            strongSelf->_levStr = [NSString stringWithFormat:@"当前等级:%@",kMeUnNilStr(strongSelf->_bModel.level)];
            [strongSelf.collectionView reloadData];
            [strongSelf.collectionView.mj_header endRefreshing];
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.collectionView.mj_header endRefreshing];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else if(_type == MEClientTwoTypeStyle){
        [MEPublicNetWorkTool getAdminDistributionWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_bModel = [MEadminDistributionModel mj_objectWithKeyValues:responseObject.data];
            //订单总额
//            CGFloat allMoney = strongSelf->_bModel.use_money + strongSelf->_bModel.ratio_money;
//            strongSelf->_arrData = @[@(MEMyMoney),@(MEMyTeam),@(MEMyLeave),@(MEMySuperior),@(MEMyCode),@(MEMyDataDeal),@(MEMyCash),@(MEMyCouponMoney),@(MEBrandMannager)];
//            strongSelf->_arrDataStr = @[[NSString stringWithFormat:@"%.2f",allMoney],[NSString stringWithFormat:@"%@",@(strongSelf->_bModel.admin_team)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_bModel.level)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_bModel.superior)],@"",@"",@"",@"",@""];
            strongSelf->_levStr = [NSString stringWithFormat:@"当前等级:%@",kMeUnNilStr(strongSelf->_bModel.level)];
            [strongSelf.collectionView reloadData];
            [strongSelf.collectionView.mj_header endRefreshing];
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.collectionView.mj_header endRefreshing];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else if(_type == MEClientTypeClerkStyle){
        [MEPublicNetWorkTool getAdminDistributionWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_bModel = [MEadminDistributionModel mj_objectWithKeyValues:responseObject.data];
            //订单总额
//            CGFloat allMoney = strongSelf->_bModel.use_money + strongSelf->_bModel.ratio_money;
//            strongSelf->_arrData = @[@(MEMyMoney),@(MEMyAppintMannger),@(MEMyLeave),@(MEMyBelongStore),@(MEMyCode),@(MEMyCash),@(MEMyMoneyDeal),@(MEMyCouponMoney)];
//            strongSelf->_arrDataStr = @[[NSString stringWithFormat:@"%.2f",allMoney],@"",[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_bModel.level)],[NSString stringWithFormat:@"%@",kMeUnNilStr(strongSelf->_bModel.superior)],@"",@"",@"",@""];
            strongSelf->_levStr = [NSString stringWithFormat:@"当前等级:%@",kMeUnNilStr(strongSelf->_bModel.level)];
            [strongSelf.collectionView reloadData];
            [strongSelf.collectionView.mj_header endRefreshing];
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.collectionView.mj_header endRefreshing];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else if(_type == MEClientCTypeStyle){
        [MEPublicNetWorkTool getUserDistributionWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_cModel = [MEDistributionCentreModel mj_objectWithKeyValues:responseObject.data];
//            CGFloat allBean = strongSelf->_cModel.wait_integral +  strongSelf->_cModel.integral;
//            strongSelf.arrData = @[@(MEDistributionMoney),@(MEDistributionOrder),@(MEMyTeam),@(MEMyCode),@(MEMyCouponMoney)];
//            strongSelf.arrDataStr = @[[NSString stringWithFormat:@"%@",@(allBean)],[NSString stringWithFormat:@"%@单",@(strongSelf->_cModel.count_order)],[NSString stringWithFormat:@"%@人",@(strongSelf->_cModel.count_user)],@"",@""];
            [strongSelf.collectionView reloadData];
             [strongSelf.collectionView.mj_header endRefreshing];
        } failure:^(id object) {
            kMeSTRONGSELF
             [strongSelf.collectionView.mj_header endRefreshing];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [MEShowViewTool showMessage:@"数据错误,请重新登录" view:self.view];
        [self.collectionView.mj_header endRefreshing];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEDistrbutionCellStyle type = [self.arrData[indexPath.row] integerValue];
    switch (type) {
        case MEDistributionOrder:{
            MEDistributionOrderMainVC *orderVC = [[MEDistributionOrderMainVC alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            
            break;
        case MEDistributionMoney:{
//            MEDistributionMoneyVC *vc = [[MEDistributionMoneyVC alloc]initWithModel:@""];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case MEMyTeam:{
            MEDistributionTeamVC *vc = [[MEDistributionTeamVC alloc]initWithType:_type];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMyMoney:{
            MEMoneyDetailedVC *vc = [[MEMoneyDetailedVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMyCode:{
            MEMineNewShareVC *vc = [[MEMineNewShareVC alloc]initWithLevel:_levStr];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MEMyClerk:{
            MEClerkManngerVC *clerkVC = [[MEClerkManngerVC alloc]init];
            [self.navigationController pushViewController:clerkVC animated:YES];
        }
            break;
            
        case MEMyAppintMannger:{
            MEMyAppointmentVC *dvc = [[MEMyAppointmentVC alloc]initWithType:MEAppointmenyUseing userType:MEClientBTypeStyle];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
            
        case MEMyDataDeal:{
            MEBdataVC *vc = [[MEBdataVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMyMoneyDeal:{
            MEClerkStatisticsVC *vc = [[MEClerkStatisticsVC alloc]initWithType:MEClientTypeClerkStyle memberId:@""];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMyCash:{
            MEGetCaseMainSVC *vc = [[MEGetCaseMainSVC alloc]initWithType:MEGetCaseAllStyle];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEMyCouponMoney:{
            MECouponOrderVC *couponVC = [[MECouponOrderVC alloc]init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case MEMyStoreMannager:{
            MEBStoreMannagerVC *storeVC = [[MEBStoreMannagerVC alloc]init];
            [self.navigationController pushViewController:storeVC animated:YES];
        }
            break;
        case MEMySelfExtractionOrder:{
            MEMySelfExtractionOrderVC *orderVC = [[MEMySelfExtractionOrderVC alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case MEBrandMannager:{
            MEBrandManngerVC *brandVC = [[MEBrandManngerVC alloc]init];
            [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEDistrbutionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEDistrbutionCell class]) forIndexPath:indexPath];
    MEDistrbutionCellStyle type = [self.arrData[indexPath.row] integerValue];
    NSString *typeStr = self.arrDataStr[indexPath.row];
    [cell setUIWithtype:type subtitle:typeStr];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMEDistrbutionCellWdith, kMEDistrbutionCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMEDistrbutionCellMargin, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEDistrbutionCellMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEDistrbutionCellMargin;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){//处理头视图
        MEMyDistributionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEMyDistributionReusableView class]) forIndexPath:indexPath];
        if(_type == MEClientBTypeStyle){
            [headerView setUIBWithModel:_bModel];
            kMeWEAKSELF
            headerView.costBlock = ^{
                kMeSTRONGSELF
                MEWithdrawalVC *vc = [[MEWithdrawalVC alloc]init];
                vc.applySucessBlock = ^{
                    kMeSTRONGSELF
                    [strongSelf.collectionView.mj_header beginRefreshing];
                };
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
        }else if(_type == MEClientOneTypeStyle){
            [headerView setUIBWithModel:_bModel];
            kMeWEAKSELF
            headerView.costBlock = ^{
                kMeSTRONGSELF
                MEWithdrawalVC *vc = [[MEWithdrawalVC alloc]init];
                vc.applySucessBlock = ^{
                    kMeSTRONGSELF
                    [strongSelf.collectionView.mj_header beginRefreshing];
                };
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
        }else if(_type == MEClientTwoTypeStyle){
            [headerView setUIBWithModel:_bModel];
            kMeWEAKSELF
            headerView.costBlock = ^{
                kMeSTRONGSELF
                MEWithdrawalVC *vc = [[MEWithdrawalVC alloc]init];
                vc.applySucessBlock = ^{
                    kMeSTRONGSELF
                    [strongSelf.collectionView.mj_header beginRefreshing];
                };
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
        }else if(_type == MEClientTypeClerkStyle){
            [headerView setUIBWithModel:_bModel];
            kMeWEAKSELF
            headerView.costBlock = ^{
                kMeSTRONGSELF
                MEWithdrawalVC *vc = [[MEWithdrawalVC alloc]init];
                vc.applySucessBlock = ^{
                    kMeSTRONGSELF
                    [strongSelf.collectionView.mj_header beginRefreshing];
                };
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
        }else if(_type == MEClientCTypeStyle){
            [headerView setUIWithModel:_cModel];
        }
        return headerView;
    }
    else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, kMEMyDistributionHeaderViewHeight);
}

#pragma mark - Getting And Setting

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDistrbutionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEDistrbutionCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyDistributionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEMyDistributionReusableView class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = kMEHexColor(@"eeeeee");
    }
    return _collectionView;
}

@end
