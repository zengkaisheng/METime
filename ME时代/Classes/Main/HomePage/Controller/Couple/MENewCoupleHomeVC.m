//
//  MENewCoupleHomeVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewCoupleHomeVC.h"
#import "MECoupleHomeNavView.h"
#import "MECoupleMailCell.h"
#import "MEFourHomeExchangeCell.h"
#import "MENewCoupleHomeHeaderView.h"
#import "MENewCoupleHomeMainHeaderView.h"

#import "MEAdModel.h"
#import "MECoupleModel.h"
#import "MEPinduoduoCoupleModel.h"

#import "MEFourCouponSearchHomeVC.h"
#import "MECoupleMailDetalVC.h"

#define kMEGoodsMargin ((IS_iPhoneX?8:7.5)*kMeFrameScaleX())

@interface MENewCoupleHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    NSArray *_todayBuy;
    NSArray *_99BuyBuy;
    NSArray *_arrAdv;
}

@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) MECoupleHomeNavView *navView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, assign)BOOL isTBk;

@end

@implementation MENewCoupleHomeVC

- (instancetype)initWithIsTbK:(BOOL)isTBk{
    if(self = [super init]){
        _isTBk = isTBk;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    self.view.backgroundColor = kMEf5f4f4;
    _todayBuy = [NSArray array];
    _99BuyBuy = [NSArray array];
    _arrAdv = [NSArray array];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
}

- (void)requestNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postGetCouponsBannerWithBannerType:@"tbk" successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_arrAdv =  [MEAdModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
        //            kMeWEAKSELF
        //            [MEPublicNetWorkTool postAgetTbkBannerWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        //                kMeSTRONGSELF
        //                strongSelf->_arrAdv =  [MEAdModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        //                dispatch_semaphore_signal(semaphore);
        //            } failure:^(id object) {
        //                dispatch_semaphore_signal(semaphore);
        //            }];
    });
    
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postCoupledgMaterialOptionalWithType:MECouponSearchTopBuyType successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id arrDIc = responseObject.data[@"tbk_dg_material_optional_response"][@"result_list"][@"map_data"];
            if([arrDIc isKindOfClass:[NSArray class]]){
                strongSelf->_todayBuy = [MECoupleModel mj_objectArrayWithKeyValuesArray:arrDIc];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    //9.9
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postCoupledgMaterialOptionalWithType:MECouponSearch99BuyType successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id arrDIc = responseObject.data[@"tbk_dg_material_optional_response"][@"result_list"][@"map_data"];
            if([arrDIc isKindOfClass:[NSArray class]]){
                strongSelf->_99BuyBuy = [MECoupleModel mj_objectArrayWithKeyValuesArray:arrDIc];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    kMeWEAKSELF
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf->_collectionView reloadData];
        });
    });
}

- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        if(_isTBk){
            [self requestNetWork];
        }else{
            kMeWEAKSELF
            [MEPublicNetWorkTool postGetCouponsBannerWithBannerType:@"tbk" successBlock:^(ZLRequestResponse *responseObject) {
                kMeSTRONGSELF
                strongSelf->_arrAdv =  [MEAdModel mj_objectArrayWithKeyValuesArray:responseObject.data];
                [strongSelf->_collectionView reloadData];
            } failure:^(id object) {
            }];
        }
    }
    if(_isTBk){
        return @{@"type":@(MECouponSearchGoodGoodsType)};
    }else{
        return @{@"sort_type":@"12"};
    }
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if(_isTBk){
        [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
    }else{
        [self.refresh.arrData addObjectsFromArray:[MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:data]];
    }
}

#pragma mark- CollectionView Delegate And DataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isTBk){
        MECoupleModel *model = self.refresh.arrData[indexPath.row];
        
        NSString *typeStr;
        switch (self.recordType) {
            case 1:
                typeStr = @"3";
                break;
            case 3:
                typeStr = @"25";
                break;
            case 4:
                typeStr = @"37";
                break;
            case 5:
                typeStr = @"49";
                break;
            default:
                break;
        }
        NSDictionary *params = @{@"num_iid":kMeUnNilStr(model.num_iid),@"item_title":kMeUnNilStr(model.title),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:typeStr params:params];
        
        if(kMeUnNilStr(model.coupon_id).length){
            MECoupleMailDetalVC *dvc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
            dvc.recordType = self.recordType;
            [self.navigationController pushViewController:dvc animated:YES];
        }else{
            model.coupon_click_url = [NSString stringWithFormat:@"https:%@",kMeUnNilStr(model.coupon_share_url)];//;
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithModel:model];
            vc.recordType = self.recordType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:model];
        vc.recordType = self.recordType;
        
        NSString *typeStr;
        switch (self.recordType) {
            case 1:
                typeStr = @"21";
                break;
            case 2:
                typeStr = @"7";
                break;
            case 3:
                typeStr = @"29";
                break;
            case 4:
                typeStr = @"41";
                break;
            case 5:
                typeStr = @"53";
                break;
            default:
                break;
        }
        NSDictionary *params = @{@"goods_id":kMeUnNilStr(model.goods_id),@"goods_name":kMeUnNilStr(model.goods_name),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:typeStr params:params];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section < 3) {
        return 0;
    }else if (section == 3) {
        return 1;
    }
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        MEFourHomeExchangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEFourHomeExchangeCell class]) forIndexPath:indexPath];
        cell.imgPic.image = [UIImage imageNamed:@"goodgoods"];
        cell.padding = 0.0;
        return cell;
    }
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    if(_isTBk){
        MECoupleModel *model = self.refresh.arrData[indexPath.row];
        [cell setUIWithModel:model];
    }else{
        MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
        [cell setpinduoduoUIWithModel:model];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_arrAdv.count <= 0) {
            return CGSizeMake(SCREEN_WIDTH, [MENewCoupleHomeHeaderView getViewHeightWithisTKb:_isTBk hasSdView:NO]);
        }else {
            return CGSizeMake(SCREEN_WIDTH, [MENewCoupleHomeHeaderView getViewHeightWithisTKb:_isTBk hasSdView:YES]);
        }
    }else {
        if (_isTBk) {
            if (section == 1) {
                return CGSizeMake(SCREEN_WIDTH, [MENewCoupleHomeMainHeaderView getCellHeightWithArr:_todayBuy]);
            }else if (section == 2) {
                return CGSizeMake(SCREEN_WIDTH, [MENewCoupleHomeMainHeaderView getCellHeightWithArr:_99BuyBuy]);
            }
        }else {
            return CGSizeMake(0, 0);
        }
    }
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            MENewCoupleHomeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewCoupleHomeHeaderView class]) forIndexPath:indexPath];
            [header setUiWithModel:_arrAdv isTKb:_isTBk];
            header.recordType = self.recordType;
            headerView = header;
        }else {
            MENewCoupleHomeMainHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewCoupleHomeMainHeaderView class]) forIndexPath:indexPath];
            if (indexPath.section == 1) {
                [header setUIWithArr:_todayBuy type:indexPath.section-1];
            }else if (indexPath.section == 2) {
                [header setUIWithArr:_99BuyBuy type:indexPath.section-1];
            }
            header.recordType = self.recordType;
             headerView = header;
        }
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH*80)/750);
    }
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 4) {
        return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin+2, kMEGoodsMargin, kMEGoodsMargin+2);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}

- (void)searchCoupon{
    
    MEFourCouponSearchHomeVC *searchHomeVC = [[MEFourCouponSearchHomeVC alloc] initWithIndex:0];
    searchHomeVC.recordType = 5;
    [self.navigationController pushViewController:searchHomeVC animated:YES];
}

#pragma mark - Getting And Setting
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = kMEf5f4f4;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeExchangeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEFourHomeExchangeCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewCoupleHomeHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewCoupleHomeHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewCoupleHomeMainHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewCoupleHomeMainHeaderView class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (MECoupleHomeNavView *)navView{
    if(!_navView){
        _navView = [[[NSBundle mainBundle]loadNibNamed:@"MECoupleHomeNavView" owner:nil options:nil] lastObject];
        _navView.frame =CGRectMake(0, 0, SCREEN_WIDTH, kMeNavBarHeight);
        kMeWEAKSELF
        _navView.backBlock = ^{
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _navView.searchBlock = ^{
            kMeSTRONGSELF
            [strongSelf searchCoupon];
        };
    }
    return _navView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        if(_isTBk){
            _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonTaobaokeGetDgMaterialOptional)];
            _refresh.isCoupleMater = YES;
        }else{
            _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonduoduokeGetgetGoodsList)];
            _refresh.isPinduoduoCoupleMater = YES;
        }
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showFailView = NO;
    }
    return _refresh;
}

@end
