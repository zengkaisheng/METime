//
//  MENewFilterGoodVC.m
//  ME时代
//
//  Created by gao lei on 2019/5/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewFilterGoodVC.h"
#import "MEGoodModel.h"

#import "MENewFilterGoodsTopHeaderView.h"
#import "MENewFilterGoodsMiddleHeaderView.h"
#import "MEProductCell.h"
#import "METhridProductDetailsVC.h"

#import "MEPinduoduoCoupleModel.h"
#import "MECoupleMailCell.h"
#import "MECoupleMailDetalVC.h"

#define kMEGoodsMargin (7.5)

@interface MENewFilterGoodVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RefreshToolDelegate>{
    NSArray *_productArr;
    NSArray *_mainArr;
    //    NSMutableArray *_bannerArr;
    NSString *_top_banner_image;
    NSString *_banner_image;
    NSString *_banner_midddle_image;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MENewFilterGoodVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"efc388"];
    //    _bannerArr = [NSMutableArray array];
    _productArr = [NSArray array];
    _mainArr = [NSArray array];
    
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate
- (void)requestNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //原优选商品
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postFetchProductsWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id data = responseObject.data[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                strongSelf->_productArr = [MEGoodModel mj_objectArrayWithKeyValuesArray:data];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postFetchYouxianBannerWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id data = responseObject.data;
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)data;
                strongSelf->_top_banner_image = dict[@"banner_top_background"][@"ad_img"];
                strongSelf->_banner_image = dict[@"banner_img"][@"ad_img"];
                strongSelf->_banner_midddle_image = dict[@"banner_middle"][@"ad_img"];
                //                MEAdModel *topBackModel = [MEAdModel mj_objectWithKeyValues:dict[@"banner_top_background"]];
                //                [strongSelf->_bannerArr addObject:topBackModel];
                //
                //                MEAdModel *bannerModel = [MEAdModel mj_objectWithKeyValues:dict[@"banner_img"]];
                //                [strongSelf->_bannerArr addObject:bannerModel];
                //
                //                MEAdModel *bannerMiddleModel = [MEAdModel mj_objectWithKeyValues:dict[@"banner_middle"]];
                //                [strongSelf->_bannerArr addObject:bannerMiddleModel];
            }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    //拼多多
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postGetPinduoduoCommondPoductWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id arrDIc = responseObject.data[@"goods_search_response"][@"goods_list"];
            if([arrDIc isKindOfClass:[NSArray class]]){
                strongSelf->_mainArr = [MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:arrDIc];
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
//            [strongSelf->_headerView setUIWithBackgroundImage:kMeUnNilStr(strongSelf->_top_banner_image) bannerImage:kMeUnNilStr(strongSelf->_banner_image)];
            [strongSelf.collectionView reloadData];
        });
    });
}

- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestNetWork];
    }
    return @{@"sort_type":@"12"};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark- CollectionView Delegate And DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _productArr.count;
    }
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MEProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEProductCell class]) forIndexPath:indexPath];
        MEGoodModel *model = _productArr[indexPath.row];
        [cell setUIWithModel:model];
        return cell;
    }
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
    [cell setpinduoduoUIWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MEGoodModel *model = _productArr[indexPath.row];
        METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
        [self.navigationController pushViewController:details animated:YES];
    }else {
        MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc] initWithPinduoudoModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 223 *kMeFrameScaleY());
    }
    return CGSizeMake(SCREEN_WIDTH, 260*kMeFrameScaleY());
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            MENewFilterGoodsTopHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewFilterGoodsTopHeaderView class]) forIndexPath:indexPath];
            [header setUIWithBackgroundImage:kMeUnNilStr(_top_banner_image) bannerImage:kMeUnNilStr(_banner_image)];
            headerView = header;
        }else if (indexPath.section == 1) {
            MENewFilterGoodsMiddleHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewFilterGoodsMiddleHeaderView class]) forIndexPath:indexPath];
            [header setUIWithArr:_mainArr];
            [header setbgImageViewWithImage:_banner_midddle_image];
            headerView = header;
        }
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(kMEProductCellWdith, kMEProductCellHeight);
    }
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(kMEGoodsMargin*2, kMEGoodsMargin*2, kMEGoodsMargin*2, kMEGoodsMargin*2);
    }
    return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin, kMEGoodsMargin, kMEGoodsMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return kMEGoodsMargin;
    }
    return kMEGoodsMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return kMEGoodsMargin;
    }
    return kMEGoodsMargin;
}

#pragma mark - Getting And Setting
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, IS_iPhoneX?10:0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-(IS_iPhoneX?10:0)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEProductCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewFilterGoodsTopHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewFilterGoodsTopHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewFilterGoodsMiddleHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewFilterGoodsMiddleHeaderView class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = kMEf5f4f4;
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonGetRecommendGoodsLit)];
        _refresh.isPinduoduoCoupleMater = YES;
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showFailView = NO;
    }
    return _refresh;
}

@end
