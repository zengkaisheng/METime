//
//  MEFourCoupleVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourCoupleVC.h"
#import "MECoupleHomeNavView.h"
#import "MEFourCoupleHeaderView.h"
#import "MECoupleMailCell.h"

#import "MEAdModel.h"
#import "MEJDCoupleModel.h"
#import "MEPinduoduoCoupleModel.h"

#import "MENavigationVC.h"
#import "MECouponSearchVC.h"
#import "MECoupleMailDetalVC.h"
#import "MEPinduoduoCouponSearchDataVC.h"

#import "MEJDCoupleHomeSearchDataVC.h"
#import "MEJDCoupleMailDetalVC.h"
#import "METhridProductDetailsVC.h"
#import "MEServiceDetailsVC.h"
#import "ZLWebViewVC.h"

#import "MEFourCouponSearchHomeVC.h"

#define kMEGoodsMargin ((IS_iPhoneX?10:7.5)*kMeFrameScaleX())

@interface MEFourCoupleVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    NSArray *_arrAdv;
}

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) MECoupleHomeNavView *navView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, assign) BOOL isJD;

@property (nonatomic, strong) UIView *siftView;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation MEFourCoupleVC

- (instancetype)initWithIsJD:(BOOL)isJD{
    if(self = [super init]){
        _isJD = isJD;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    self.view.backgroundColor = kMEf5f4f4;
    _arrAdv = [NSArray array];
    
    self.isUp = YES;
    self.sort = @"";
    self.isTop = NO;
    [self.view addSubview:self.navView];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.siftView];
    [self sortDataWithSiftTag:100];
    [self.refresh addRefreshView];
    [self showHUD];
}

- (void)showHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];;
    hud.mode = MBProgressHUDModeIndeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

- (void)siftBtnAction:(UIButton *)sender {
    UIButton *siftBtn = (UIButton *)sender;
    self.selectedBtn = siftBtn;
    [self reloadStatusWithSiftButton:siftBtn];
    
    [self sortDataWithSiftTag:siftBtn.tag];
    [self showHUD];
    
    if (self.isJD) {
        [self getJDDataWithNetwork];
    }else {
        [self getPDDDataWithNetwork];
    }
}
//刷新筛选按钮状态
- (void)reloadStatusWithSiftButton:(UIButton *)siftBtn {
    for (UIButton *btn in self.siftView.subviews) {
        if (btn.tag == siftBtn.tag) {
            if (self.isTop) {
                if (siftBtn.selected == YES && siftBtn.tag != 100) {
                    if (self.isUp == YES) {
                        self.isUp = NO;
                        [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateSelected];
                    }else {
                        [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
                        self.isUp = YES;
                    }
                }else {
                    siftBtn.selected = YES;
                    if (siftBtn.tag == 103) {
                        self.isUp = YES;
                        [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
                    }else {
                        self.isUp = NO;
                        if (siftBtn.tag != 100) {
                            [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateSelected];
                        }
                    }
                }
            }else {
                if (btn.tag != 100) {
                    btn.selected = YES;
                    if (self.isUp) {
                        [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
                    }else {
                        [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateSelected];
                    }
                }
            }
        }else {
            btn.selected = NO;
        }
    }
}

- (void)sortDataWithSiftTag:(NSInteger)tag {
    switch (tag) {
        case 100:
        {
            if (self.isJD) {
                self.dic = @{@"eliteId":@(16)};
            }else {
                self.dic = @{@"sort_type":@(0)};
            }
        }
            break;
        case 101:
        {
            if (self.isJD) {
                if (self.isUp) {
                    self.dic = @{@"eliteId":@(16),@"sortName":@"commission",@"sort":@"asc"};
                }else {
                    self.dic = @{@"eliteId":@(16),@"sortName":@"commission",@"sort":@"desc"};
                }
            }else {
                if (self.isUp) {
                    self.dic = @{@"sort_type":@(13)};
                }else {
                    self.dic = @{@"sort_type":@(14)};
                }
            }
        }
            break;
        case 102:
        {
            if (self.isJD) {
                if (self.isUp) {
                    self.dic = @{@"eliteId":@(16),@"sortName":@"goodComments",@"sort":@"asc"};
                }else {
                    self.dic = @{@"eliteId":@(16),@"sortName":@"goodComments",@"sort":@"desc"};
                }
            }else {
                if (self.isUp) {
                    self.dic = @{@"sort_type":@(5)};
                }else {
                    self.dic = @{@"sort_type":@(6)};
                }
            }
        }
            break;
        case 103:
        {
            if (self.isJD) {
                if (self.isUp) {
                    self.dic = @{@"eliteId":@(16),@"sortName":@"price",@"sort":@"asc"};
                }else {
                    self.dic = @{@"eliteId":@(16),@"sortName":@"price",@"sort":@"desc"};
                }
            }else {
                if (self.isUp) {
                    self.dic = @{@"sort_type":@(9)};
                }else {
                    self.dic = @{@"sort_type":@(10)};
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestBannerNetWork];
    }
    return self.dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if(_isJD){
        [self.refresh.arrData addObjectsFromArray:[MEJDCoupleModel mj_objectArrayWithKeyValuesArray:data]];
    }else{
        [self.refresh.arrData addObjectsFromArray:[MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:data]];
    }
}
#pragma mark -- netWorking
- (void)requestBannerNetWork {
    kMeWEAKSELF
    NSString *type = @"pdd";
    if (_isJD) {
        type = @"jd";
    }
    [MEPublicNetWorkTool postGetCouponsBannerWithBannerType:type successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_arrAdv =  [MEAdModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        [strongSelf.collectionView reloadData];
    } failure:^(id object) {
    }];
}

- (void)getPDDDataWithNetwork {
    NSInteger type = [self.dic[@"sort_type"] integerValue];
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetPinduoduoCommondPoductWithSortType:type successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = (NSArray *)responseObject.data[@"goods_search_response"][@"goods_list"];
            strongSelf.refresh.pageIndex = 1;
            [strongSelf.refresh.arrData removeAllObjects];
            [strongSelf.refresh.arrData addObjectsFromArray:[MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:dataArray]];
            if (strongSelf.isTop) {
                [strongSelf.collectionView setContentOffset:CGPointMake(0, 150) animated:YES];
            }
            [strongSelf.collectionView reloadData];
        }
    } failure:^(id object) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
        if([object isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)object;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
    }];
}

- (void)getJDDataWithNetwork{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.dic];
    [dic addEntriesFromDictionary:@{@"pageSize":@"20",@"page":@"1"}];
    
    NSString *url = kGetApiWithUrl(MEIPcommonjingdonggoodsJingFen);
    kMeWEAKSELF
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSArray class]]){
            
            NSArray *dicArr = responseObject.data;
            strongSelf.refresh.pageIndex = 1;
            [strongSelf.refresh.arrData removeAllObjects];
            [strongSelf.refresh.arrData addObjectsFromArray:[MEJDCoupleModel mj_objectArrayWithKeyValuesArray:dicArr]];
            if (strongSelf.isTop) {
                [strongSelf.collectionView setContentOffset:CGPointMake(0, 150) animated:YES];
            }
            [strongSelf.collectionView reloadData];
        }
    } failure:^(id error) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        if (_arrAdv.count > 0) {
            if (scrollView.contentOffset.y >= 150) {
                self.siftView.hidden = NO;
                self.isTop = YES;
            }else {
                self.siftView.hidden = YES;
                self.isTop = NO;
            }
        }else {
            if (scrollView.contentOffset.y >= 40) {
                self.siftView.hidden = NO;
                self.isTop = YES;
            }else {
                self.siftView.hidden = YES;
                self.isTop = NO;
            }
        }
    }
}

#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isJD){
        MEJDCoupleModel *model = self.refresh.arrData[indexPath.row];
        MEJDCoupleMailDetalVC *vc = [[MEJDCoupleMailDetalVC alloc]initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    if(_isJD){
        MEJDCoupleModel *model = self.refresh.arrData[indexPath.row];
        [cell setJDUIWithModel:model];
    }else{
        MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
        [cell setpinduoduoUIWithModel:model];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (_arrAdv.count > 0) {
        return CGSizeMake(SCREEN_WIDTH, 190);
    }
    return CGSizeMake(SCREEN_WIDTH, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            MEFourCoupleHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourCoupleHeaderView class]) forIndexPath:indexPath];
            [header setUIWithBannerImage:_arrAdv];
            if (self.isTop) {
                [header reloadSiftButtonWithSelectedBtn:self.selectedBtn isUp:self.isUp isTop:self.isTop];
            }
            
            kMeWEAKSELF
            header.selectedIndexBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                MEAdModel *model = strongSelf->_arrAdv[index];
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            };
            header.titleSelectedIndexBlock = ^(NSInteger tag, BOOL isUp) {
                kMeSTRONGSELF
                strongSelf.isUp = isUp;
                strongSelf.isTop = NO;
                for (UIButton *btn in strongSelf.siftView.subviews) {
                    if (btn.tag == tag) {
                        [strongSelf siftBtnAction:btn];
                    }
                }
            };
            headerView = header;
        }
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin, kMEGoodsMargin, kMEGoodsMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}

//banner图点击跳转
- (void)cycleScrollViewDidSelectItemWithModel:(MEAdModel *)model {
    if (kMeUnNilStr(model.keywork).length > 0) {
        if (_isJD) {
            MEFourCouponSearchHomeVC *searchHomeVC = [[MEFourCouponSearchHomeVC alloc] initWithIndex:2];
            searchHomeVC.keyWords = model.keywork;
            [self.navigationController pushViewController:searchHomeVC animated:YES];
        }else {
            MEFourCouponSearchHomeVC *searchHomeVC = [[MEFourCouponSearchHomeVC alloc] initWithIndex:1];
            searchHomeVC.keyWords = model.keywork;
            [self.navigationController pushViewController:searchHomeVC animated:YES];
        }
    }
    
    /*
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
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
            tv.attributedText = attributedString;
            tv.editable = NO;
            [vc.view addSubview:tv];
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
        default:
            break;
    }
     */
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

- (void)searchCoupon{
    
    NSInteger index = 1;
    if (_isJD) {
        index = 2;
    }
    MEFourCouponSearchHomeVC *searchHomeVC = [[MEFourCouponSearchHomeVC alloc] initWithIndex:index];
    [self.navigationController pushViewController:searchHomeVC animated:YES];
    
//    kMeWEAKSELF
//    MECouponSearchVC *searchViewController = [MECouponSearchVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索优惠券" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//        kMeSTRONGSELF
//        if(strongSelf->_isJD){
//            MEJDCoupleHomeSearchDataVC *dataVC = [[MEJDCoupleHomeSearchDataVC alloc]initWithQuery:searchText];
//            [searchViewController.navigationController pushViewController:dataVC animated:YES];
//        }else{
//            MEPinduoduoCouponSearchDataVC *dataVC = [[MEPinduoduoCouponSearchDataVC alloc]initWithQuery:searchText];
//            [searchViewController.navigationController pushViewController:dataVC animated:YES];
//        }
//
//    }];
//    [searchViewController setSearchHistoriesCachePath:kMECouponSearchVCSearchHistoriesCachePath];
//    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
//    [self presentViewController:nav  animated:NO completion:nil];
}

#pragma helper
- (UIButton *)createSiftButtomWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *siftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [siftBtn setTitle:title forState:UIControlStateNormal];
    [siftBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [siftBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [siftBtn setTitleColor:[UIColor colorWithHexString:@"#E74192"] forState:UIControlStateSelected];
    if (tag != 100) {
        [siftBtn setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
        [siftBtn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
    }
    //jiagedown  jiagenomal  jiageup
    [siftBtn setTag:tag];
    if ([title isEqualToString:@"优惠券"]) {
        [siftBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-95];
    }else {
        [siftBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-70];
    }
    [siftBtn addTarget:self action:@selector(siftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    siftBtn.backgroundColor = [UIColor whiteColor];
    
    return siftBtn;
}

#pragma mark - Getting And Setting
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = kMEf5f4f4;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourCoupleHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourCoupleHeaderView class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        if(_isJD){
            _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonjingdonggoodsJingFen)];
            _refresh.isJD = YES;
            _refresh.isDataInside = NO;
        }else{
            _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonduoduokeGetgetGoodsList)];
            _refresh.isPinduoduoCoupleMater = YES;
            _refresh.isDataInside = YES;
        }
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有优惠产品";
        }];
    }
    return _refresh;
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

- (UIView *)siftView {
    if (!_siftView) {
        _siftView = [[UIView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, 40)];
        _siftView.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"综合",@"优惠券",@"销量",@"价格"];
        CGFloat itemW = SCREEN_WIDTH / titles.count;
        for (int i = 0; i < titles.count; i++) {
            UIButton *siftBtn = [self createSiftButtomWithTitle:titles[i] tag:100+i];
            siftBtn.frame = CGRectMake(itemW * i, 0, itemW, 40);
            if (i == 0) {
                siftBtn.selected = YES;
            }
            [_siftView addSubview:siftBtn];
        }
    }
    return _siftView;
}

@end
