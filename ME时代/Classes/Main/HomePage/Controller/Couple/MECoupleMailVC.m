//
//  MECoupleMailVC.m
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MECoupleMailVC.h"
#import "MECoupleMailCell.h"
#import "MECoupleModel.h"
#import "MECoupleMailDetalVC.h"


@interface MECoupleMailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    NSString *_queryStr;
    MECouponSearchType _type;
}

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, assign) BOOL isMater;

@end

@implementation MECoupleMailVC

- (instancetype)initWithType:(MECouponSearchType)type{
    if(self = [super init]){
        _isMater = YES;
        _type = type;
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
                str = @"9块9专场";
            }
                break;
            case MECouponSearchShiShangType:{
                str = @"时尚潮流专场";
            }
                break;
            case MECouponSearchTopBuyType:{
                str = @"人气爆款专场";
            }
                break;
            case MECouponSearchBigJuanType:{
                str = @"大额券专场";
            }
                break;
            case MECouponSearchTeHuiType:{
                str = @"超值特惠专场";
            }
                break;
            case MECouponSearchGoodGoodsType:{
                str = @"人气爆款专场";//@"精选好物专场";
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
            default:
                str = @"优惠券";
                break;
        }
        if(kMeUnNilStr(self.titleStr).length){
            self.title = kMeUnNilStr(self.titleStr);
        }else{
           self.title = str;
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
        return @{@"type":@(_type)};
    }else{
        return @{@"q":kMeUnNilStr(_queryStr),@"tool":@"ios"};
    }
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isMater){
        MECoupleModel *model = self.refresh.arrData[indexPath.row];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url)];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MECoupleModel *model = self.refresh.arrData[indexPath.row];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    MECoupleModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
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
        NSString *str = MEIPcommonTaobaokeGetCoupon;
        if(_isMater){
            str = MEIPcommonTaobaokeGetDgMaterialOptional;
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(str)];
        _refresh.delegate = self;
        if(_isMater){
            _refresh.isCoupleMater = YES;
        }else{
            _refresh.isCouple = YES;
        }
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有优惠产品";
        }];
    }
    return _refresh;
}


@end
