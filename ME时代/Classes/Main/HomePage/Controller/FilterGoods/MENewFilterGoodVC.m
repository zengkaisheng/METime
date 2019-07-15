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
#import "MENewFilterGoodsMiddleBannerView.h"
#import "MEProductCell.h"
#import "METhridProductDetailsVC.h"

#import "MEPinduoduoCoupleModel.h"
#import "MECoupleMailCell.h"
#import "MECoupleMailDetalVC.h"

#import "MEFilterMainModel.h"
#import "MEAdModel.h"
#import "MEServiceDetailsVC.h"
#import "ZLWebViewVC.h"
#import "MECoupleMailVC.h"

#import "MEBargainDetailVC.h"
#import "MEGroupProductDetailVC.h"
#import "MEJoinPrizeVC.h"

#define kMEGoodsMargin ((IS_iPhoneX?8:7.5)*kMeFrameScaleX())

@interface MENewFilterGoodVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RefreshToolDelegate,JXCategoryViewDelegate>{
    NSArray *_productArr;//
    NSArray *_filterArr;//分类
    NSString *_top_banner_image;
    NSArray *_banner_images;
    NSArray *_banner_midddle_images;
    NSString *_category_id;
    NSInteger _selectedIndex;
    BOOL _is_show;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@end

@implementation MENewFilterGoodVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"efc388"];
    _productArr = [NSArray array];
    _filterArr = [NSArray array];
    _banner_images = [NSArray array];
    _banner_midddle_images = [NSArray array];
    _category_id = @"";
    _is_show = NO;
    _selectedIndex = 0;
    
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"index:%ld",(long)index);
    [self reloadProductsWithIndex:index isTop:YES];
}
//刷新优选商品
- (void)reloadProductsWithIndex:(NSInteger)index isTop:(BOOL)isTop{
    _selectedIndex = index;
    MEFilterMainModel *model = _filterArr[index];
    _category_id = [NSString stringWithFormat:@"%ld",(long)model.idField];
    [self fetchYouXuanProductsWithTop:isTop];
}

- (void)fetchYouXuanProductsWithTop:(BOOL)isTop {
    kMeWEAKSELF
    [MECommonTool showMessage:@"数据加载中..." view:kMeCurrentWindow];
    [MEPublicNetWorkTool postFetchProductsWithCategoryId:self->_category_id successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        id data = responseObject.data[@"data"];
        if ([data isKindOfClass:[NSArray class]]) {
            strongSelf->_productArr = [MEGoodModel mj_objectArrayWithKeyValuesArray:data];
            [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            if (isTop) {
                [self.collectionView setContentOffset:CGPointMake(0, 223*kMeFrameScaleY()-kMeStatusBarHeight+2) animated:YES];
            }
            strongSelf.categoryView.defaultSelectedIndex = strongSelf->_selectedIndex;
            [strongSelf.categoryView reloadData];
        }
    } failure:^(id object) {
    }];
}

- (void)requestNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //获取分类
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postGoodFilterWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id arrDIc = responseObject.data;
            if([arrDIc isKindOfClass:[NSArray class]]){
                strongSelf->_filterArr = [MEFilterMainModel mj_objectArrayWithKeyValuesArray:arrDIc];
                if (strongSelf->_filterArr.count > 0) {
                    MEFilterMainModel *model = strongSelf->_filterArr[0];
                    strongSelf->_category_id = [NSString stringWithFormat:@"%ld",(long)model.idField];
                }
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
                
                strongSelf->_banner_images = [MEAdModel mj_objectArrayWithKeyValuesArray:dict[@"banner_img"]];
                strongSelf->_banner_midddle_images = [MEAdModel mj_objectArrayWithKeyValuesArray:dict[@"banner_middle"]];
            }

            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    //原优选商品
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF//category_id
        [MEPublicNetWorkTool postFetchProductsWithCategoryId:self->_category_id successBlock:^(ZLRequestResponse *responseObject) {
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
    //控制原商品显示隐藏
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF//category_id
        [MEPublicNetWorkTool postGetYouxuanAdGoodsShowWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_is_show = [responseObject.data[@"is_show"] integerValue]==1?YES:NO;
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
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            NSMutableArray *titles = [[NSMutableArray alloc] init];
            for (int i = 0; i < strongSelf->_filterArr.count; i++) {
                MEFilterMainModel *model = strongSelf->_filterArr[i];
                [titles addObject:model.category_name];
            }
            if (titles.count > 1) {
                strongSelf.categoryView.titles = [titles copy];
                strongSelf.categoryView.defaultSelectedIndex = 0;
                [strongSelf.categoryView reloadData];
            }
            [strongSelf.collectionView reloadData];
        });
    });
}
#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestNetWork];
    }
//    return @{@"sort_type":@"12"};
    return @{};
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
        if (_is_show) {
            return _productArr.count;
        }
        return 0;
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
        
        NSDictionary *params = @{@"goods_id":kMeUnNilStr(model.goods_id),@"goods_name":kMeUnNilStr(model.goods_name),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:@"7" params:params];
        
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc] initWithPinduoudoModel:model];
        vc.recordType = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_is_show) {
            if (_banner_images.count > 0) {
                if (_filterArr.count > 1) {
                    return CGSizeMake(SCREEN_WIDTH, 223*kMeFrameScaleY() + 46);
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 223*kMeFrameScaleY());
                }
            }else {
                if (_filterArr.count > 1) {
                    return CGSizeMake(SCREEN_WIDTH, 92*kMeFrameScaleY() + 46);
                }else {
                    return CGSizeMake(0, 0);
                }
            }
        }else {
            return CGSizeMake(0, 0);
        }
    }
    
    if (_is_show) {
        return CGSizeMake(SCREEN_WIDTH, 167*kMeFrameScaleY());
    }else {
        if (_banner_midddle_images.count > 0) {
            return CGSizeMake(SCREEN_WIDTH, (167+92)*kMeFrameScaleY());
        }else {
            return CGSizeMake(SCREEN_WIDTH, 92*kMeFrameScaleY());
        }
    }
//    return CGSizeMake(SCREEN_WIDTH, 92*kMeFrameScaleY());
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        if (indexPath.section == 0) {
            MENewFilterGoodsTopHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewFilterGoodsTopHeaderView class]) forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            [header setUIWithBackgroundImage:kMeUnNilStr(_top_banner_image) bannerImage:kMeUnArr(_banner_images) hasTop:_is_show isTop:YES];
            NSMutableArray *titles = [[NSMutableArray alloc] init];
            if (_filterArr.count > 0) {
                for (int i = 0; i < _filterArr.count; i++) {
                    MEFilterMainModel *model = _filterArr[i];
                    [titles addObject:model.category_name];
                }
            }
            [header setUIWithTitleArray:titles.copy];
            [header reloadTitleViewWithIndex:_selectedIndex];
            kMeWEAKSELF
            header.titleSelectedIndexBlock = ^(NSInteger index) {
                [weakSelf reloadProductsWithIndex:index isTop:NO];
            };
        }else {
            [header setUIWithBackgroundImage:kMeUnNilStr(_top_banner_image) bannerImage:kMeUnArr(_banner_midddle_images) hasTop:_is_show isTop:NO];
            [header setUIWithTitleArray:@[]];
        }
        kMeWEAKSELF
            header.selectedIndexBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                MEAdModel *model = strongSelf->_banner_midddle_images[index];
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            };
            headerView = header;
//        }else if (indexPath.section == 1) {
//            MENewFilterGoodsMiddleBannerView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewFilterGoodsMiddleBannerView class]) forIndexPath:indexPath];
//            [header setUIWithImages:_banner_midddle_images];
//            kMeWEAKSELF
//            header.selectedIndexBlock = ^(NSInteger index) {
//                kMeSTRONGSELF
//                MEAdModel *model = strongSelf->_banner_midddle_images[index];
//                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
//            };
//            headerView = header;
//        }
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
    if (section == 0 ) {
        if (!_is_show) {
            return UIEdgeInsetsMake(0, kMEGoodsMargin, 0, kMEGoodsMargin);
        }else {
            return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin+2, kMEGoodsMargin, kMEGoodsMargin+2);
        }
    }
    return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin+2, kMEGoodsMargin, kMEGoodsMargin+2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    if (section == 0) {
//        return kMEGoodsMargin;
//    }
    return kMEGoodsMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    if (section == 0) {
//        return kMEGoodsMargin;
//    }
    return kMEGoodsMargin;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        if (_is_show) {
            if (_filterArr.count > 1) {
                if (scrollView.contentOffset.y >= 243*kMeFrameScaleY()-kMeStatusBarHeight) {
                    self.navView.hidden = NO;
                }else {
                    self.navView.hidden = YES;
                }
            }else {
                self.navView.hidden = YES;
            }
        }
    }
}
//banner图点击跳转
- (void)cycleScrollViewDidSelectItemWithModel:(MEAdModel *)model {
    
    if (model.is_need_login == 1) {
        if(![MEUserInfoModel isLogin]){
            kMeWEAKSELF
            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                kMeSTRONGSELF
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            } failHandler:^(id object) {
                return;
            }];
            return;
        }
    }
    
    NSDictionary *params = @{@"type":@(model.type), @"show_type":@(model.show_type), @"ad_id":kMeUnNilStr(model.ad_id), @"product_id":@(model.product_id), @"keywork":kMeUnNilStr(model.keywork)};
    [self saveClickRecordsWithType:@"1" params:params];
    
    switch (model.show_type) {//0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标
        case 1:
        {
            METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 2:
        {
            MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 3:
        {
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            [webVC loadURL:[NSURL URLWithString:kMeUnNilStr(model.ad_url)]];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 4:
        {
            NSURL *URL = [NSURL URLWithString:kMeUnNilStr(model.ad_url)];
            [[UIApplication sharedApplication] openURL:URL];
        }
            break;
        case 5:
        {
            MEBaseVC *vc = [[MEBaseVC alloc] init];
            vc.title = @"详情";
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
            [webView loadHTMLString:model.content baseURL:nil];
            [vc.view addSubview:webView];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            
        }
            break;
        case 8:
        {
            [self toTaoBaoActivityWithUrl:kMeUnNilStr(model.ad_url)];
        }
            break;
        case 13:
        {//跳拼多多推荐商品列表
            MECoupleMailVC *vc = [[MECoupleMailVC alloc] initWithAdId:model.ad_id];
            vc.recordType = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {//跳砍价活动详情
            if([MEUserInfoModel isLogin]){
                MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
                [self.navigationController pushViewController:bargainVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
                    [strongSelf.navigationController pushViewController:bargainVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 15:
        {//跳拼团活动详情
            if([MEUserInfoModel isLogin]){
                MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                [self.navigationController pushViewController:groupVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                    [strongSelf.navigationController pushViewController:groupVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 16:
        {//跳签到活动详情
            if([MEUserInfoModel isLogin]){
                MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",model.activity_id]];
                [self.navigationController pushViewController:prizeVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",model.activity_id]];
                    [strongSelf.navigationController pushViewController:prizeVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        default:
            break;
    }
}
//618活动
- (void)toTaoBaoActivityWithUrl:(NSString *)url{
    kMeWEAKSELF
    if([MEUserInfoModel isLogin]){
        [weakSelf checkRelationIdWithUrl:url];
    }else {
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf toTaoBaoActivityWithUrl:url];
        } failHandler:nil];
    }
}

//获取淘宝授权
- (void)obtainTaoBaoAuthorizeWithUrl:(NSString *)url {
    NSString *str = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25425439&redirect_uri=http://test.meshidai.com/src/taobaoauthorization.html&view=wap";
    ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
    webVC.showProgress = YES;
    webVC.title = @"获取淘宝授权";
    [webVC loadURL:[NSURL URLWithString:str]];
    kMeWEAKSELF
    webVC.authorizeBlock = ^{
        [weakSelf checkRelationIdWithUrl:url];
    };
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)checkRelationIdWithUrl:(NSString *)url {
    if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
        //        [self openAddTbView];
        [self obtainTaoBaoAuthorizeWithUrl:url];
    }else{
        if (url.length > 0) {
            NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
            NSString *str = [url stringByAppendingString:rid];
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            webVC.title = @"活动主会场";
            [webVC loadURL:[NSURL URLWithString:str]];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
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
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewFilterGoodsMiddleBannerView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MENewFilterGoodsMiddleBannerView class])];
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
        _refresh.delegate = self;
        _refresh.showMaskView = YES;
        _refresh.isDataInside = YES;
        _refresh.isPinduoduoCoupleMater = YES;
        _refresh.isFilter = YES;
    }
    return _refresh;
}

- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 46 + kMeStatusBarHeight)];
        _navView.backgroundColor = [UIColor whiteColor];
        
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeStatusBarHeight, SCREEN_WIDTH, 46)];
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor =  kMEPink;
        lineView.indicatorLineViewHeight = 1;
        
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        if (_filterArr.count > 0) {
            for (int i = 0; i < _filterArr.count; i++) {
                MEFilterMainModel *model = _filterArr[i];
                [titles addObject:model.category_name];
            }
        }
        _categoryView.titles = titles;
        _categoryView.indicators = @[lineView];
        _categoryView.delegate = self;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titleColor =  [UIColor blackColor];
        _categoryView.titleSelectedColor = kMEPink;
//        _categoryView.defaultSelectedIndex = 0;
        [_navView addSubview:_categoryView];
        [self.view addSubview:_navView];
        _navView.hidden = YES;
    }
    return _navView;
}


@end
