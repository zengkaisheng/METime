//
//  MECoupleMailVC.m
//  志愿星
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MECoupleMailVC.h"
#import "MECoupleMailCell.h"
#import "MECoupleModel.h"
#import "MECoupleMailDetalVC.h"
//#import "MEJuHuaSuanCoupleModel.h"
#import "MEPinduoduoCoupleModel.h"

@interface MECoupleMailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    NSString *_queryStr;
    MECouponSearchType _type;
    NSInteger _material_id;
    NSString *_ad_id;
}

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, assign) BOOL isMater;
@property (nonatomic, assign) BOOL isPDD;

@end

@implementation MECoupleMailVC

- (instancetype)initWithType:(MECouponSearchType)type{
    if(self = [super init]){
        _isMater = YES;
        _type = type;
    }
    return self;
}

- (instancetype)initWithAdId:(NSString *)adId{//拼多多推荐商品
    if(self = [super init]){
        _ad_id = adId;
        _isPDD = YES;
        _isMater = YES;
    }
    return self;
}

- (instancetype)initWithQuery:(NSString *)query{
    if(self = [super init]){
        _queryStr = query;
        _isMater = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithHexString:@"eeeeee"];
    _material_id = 0;
//    //type:1:9.9、2：时尚潮流、3人气爆款、4大额券、5特惠、6好货、7好券直播、8品牌
//    typedef enum : NSUInteger {
//        MECouponSearch99BuyType = 1,
//        MECouponSearchShiShangType = 2,
//        MECouponSearchTopBuyType = 3,
//        MECouponSearchBigJuanType = 4,
//        MECouponSearchTeHuiType = 5,
//        MECouponSearchGoodGoodsType = 6,
//        MECouponSearchGoodJuanType = 7,
//        MECouponSearchPinPaiType = 8,
//    }  MECouponSearchType;

    if(_isMater){
        NSString *str = @"";
        switch (_type) {
            case MECouponSearch99BuyType:{
                str = @"9块9包邮";
            }
                break;
            case MECouponSearchShiShangType:{
                str = @"时尚潮流";
                _material_id = 4093;
            }
                break;
            case MECouponSearchTopBuyType:{
                str = @"今日热卖榜";
            }
                break;
            case MECouponSearchBigJuanType:{
                str = @"大额优惠券";
            }
                break;
            case MECouponSearchTeHuiType:{
                str = @"超值特惠";
            }
                break;
            case MECouponSearchGoodGoodsType:{
                str = @"人气爆款";//@"人气爆款专场"
//                _material_id = 9660;
            }
                break;
            case MECouponSearchGoodJuanType:{
                str = @"好券直播专场";
            }
                break;
            case MECouponSearchPinPaiType:{
                str = @"品牌专场";
            }
                break;
            case MECouponSearchJuHSType:{
                str = @"聚划算";
            }
                break;
            default:
                str = @"优惠券";
                break;
        }
        if(kMeUnNilStr(self.titleStr).length){
            self.title = kMeUnNilStr(self.titleStr);
        }else{
           self.title = str;
            if (self.isPDD) {
                self.title = @"拼多多";
            }
        }
    }else{
        self.title = _queryStr;
    }
    
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
//    return @{@"r":@"Port/index",@"type":@"total",@"appkey":@"58de5a1fe2",@"v":@"2"};
    if(_isMater){
        if (_type == MECouponSearchJuHSType) {
            return @{@"is_ju_goods":@"1"};
        }
        if (self.isPDD) {
            if (_ad_id.length > 0) {
                return @{@"ad_id":_ad_id};
            }
            return @{};
        }
        if (_material_id != 0) {
            return @{@"material_id":@(_material_id)};
        }else {
            return @{@"type":@(_type)};
        }
    }else{
        return @{@"q":kMeUnNilStr(_queryStr),@"tool":@"ios"};
    }
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if (self.isPDD) {
        [self.refresh.arrData addObjectsFromArray:[MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:data]];
    }else {
        [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
    }
}

#pragma mark- CollectionView Delegate And DataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isMater){
        if (self.isPDD) {
            MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc] initWithPinduoudoModel:model];
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
        }else {
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
        }
    }else{//搜索
        MECoupleModel *model = self.refresh.arrData[indexPath.row];
        
        NSDictionary *params = @{@"num_iid":kMeUnNilStr(model.num_iid),@"item_title":kMeUnNilStr(model.title),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:@"5" params:params];
        
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
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    if (self.isPDD) {
        MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
        [cell setpinduoduoUIWithModel:model];
    }else {
        MECoupleModel *model = self.refresh.arrData[indexPath.row];
        [cell setUIWithModel:model];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMEMargin, 0, kMEMargin, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEMargin;
}


#pragma mark - Getting And Setting

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, kMeNavBarHeight, SCREEN_WIDTH-20, SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        NSString *str = MEIPcommonTaobaokeGetDgMaterialOptional;
        if(_isMater){
            if (self.isPDD) {
                str = MEIPcommonGetRecommendGoodsLit;
            }else {
//                if (_type == MECouponSearchJuHSType) {
//                    str = MEIPcommonTaobaokeGetTbkJuItemsSearch;
//                }else {
//                    str = MEIPcommonTaobaokeGetDgMaterialOptional;
//                }
                str = MEIPcommonTaobaokeGetDgMaterialOptional;
            }
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(str)];
        _refresh.delegate = self;
        if(_isMater){
            if (self.isPDD) {
                _refresh.isPinduoduoCoupleMater = YES;
                _refresh.isFilter = YES;
            }else {
//                if (_type == MECouponSearchJuHSType) {
//                    _refresh.isJuHS = YES;
//                }else {
//                    _refresh.isCoupleMater = YES;
//                }
                _refresh.isCoupleMater = YES;
            }
        }else{
            _refresh.isCoupleMater = YES;
        }
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有优惠券";
        }];
    }
    return _refresh;
}


@end
