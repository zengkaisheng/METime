//
//  METhridHomeVC.m
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeVC.h"
#import "METhridHomeHeaderView.h"
#import "METhridHomeTimeSecionView.h"
#import "MERushBuyCell.h"
#import "MECommondCouponCell.h"
#import "MECoupleModel.h"
#import "MECoupleHomeMainGoodGoodsCell.h"
#import "METhridHomeNavView.h"
#import "MEShoppingMallVC.h"
#import "MECoupleHomeVC.h"
#import "MEAdModel.h"
#import "MERushBuyView.h"
#import "METhridProductDetailsVC.h"
#import "METhridHomeModel.h"
#import "MECouponSearchVC.h"
#import "MECoupleMailVC.h"
#import "MENavigationVC.h"
//#import "METhridHomeRudeTimeModel.h"
//#import "METhridHomeRudeGoodModel.h"
#import "MECoupleMailDetalVC.h"
#import "MENetListModel.h"
#import "MEStoreModel.h"
//#import "MENewStoreDetailsVC.h"
//#import "MEAIHomeVC.h"
//#import "MEAIDataHomeTimeVC.h"
//#import "METhridHomeHotCell.h"
//#import <MediaPlayer/MediaPlayer.h>
//#import "MEBasePlayerVC.h"
//#import "METhridHomeHotGoodModel.h"
//#import "MEAppHomeTitleModel.h"
#import "MEGoodModel.h"

#import "METhridGoodsGoodSectionView.h"
#import "METhridHomeCommondSectionView.h"

#import "METhridHomeGoodGoodFilterCell.h"
#import "METhridHomeGoodGoodMainCell.h"
#import "METhridHomeTopCell.h"
#import "MEHomeRecommendAndSpreebuyModel.h"
#import "METhridHomeExchangeCell.h"
#import "MEHomeAddRedeemcodeVC.h"
#import "MERedeemgetStatusModel.h"

const static CGFloat kImgStore = 50;
@interface METhridHomeVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _selectTimeIndex;
//    NSArray *_arrRudeBuy;
    NSArray *_arrRudeTime;
    NSArray *_arrHot;
    METhridHomeModel *_homeModel;
//    CGFloat _sectionHeaderHeight;
    CGFloat _alphaNum;
    MEStoreModel *_stroeModel;
    MEHomeRecommendAndSpreebuyModel *_spreebugmodel;
//    MEAppHomeTitleModel *_homeTitleModel;
    NSInteger _currentIndex;
    NSArray *_arrDicParm;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) METhridHomeHeaderView *headerView;
@property (nonatomic, strong) METhridHomeNavView *navView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIImageView *imgStore;
@end

@implementation METhridHomeVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    self.view.backgroundColor = kMEf5f4f4;
    _currentIndex = 0;
    _alphaNum = (kSdHeight*kMeFrameScaleX())+80;
    //@[@"精选",@"特卖",@"猜你喜欢",@"女装",@"美妆",@"母婴"];
    _arrDicParm = @[@{@"type":@"3"},@{@"material_id":@"3756"},@{@"material_id":@"3786"},@{@"material_id":@"3767"},@{@"material_id":@"3763"},@{@"material_id":@"3760"}];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.imgStore];
    _selectTimeIndex = 0;
    _arrHot = [NSArray array];
    _arrRudeTime = [NSArray array];
    _homeModel = [METhridHomeModel new];
    self.tableView.tableHeaderView = self.headerView;
    [self.refresh addRefreshView];
    self.tableView.mj_header.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.tableView.mj_header;
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    self.headerView.viewForBack.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    [self getRushGood];
    [self getUnInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnInfo) name:kUnNoticeMessage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
}

- (void)setSdBackgroundColorWithIndex:(NSInteger)index{
    NSArray *arr = kMeUnArr(_homeModel.top_banner);
    if(arr.count==0 || index>arr.count){
        return;
    }
    METhridHomeAdModel *model = arr[index];
    if(kMeUnNilStr(model.color_start).length){
        UIColor *color = [UIColor colorWithHexString:kMeUnNilStr(model.color_start)];
        if(!color){
            color = [UIColor colorWithHexString:@"#E52E26"];
        }
        self.tableView.mj_header.backgroundColor = color;
        self.navView.backgroundColor = color;
        self.view.backgroundColor = color;
        self.headerView.viewForBack.backgroundColor = color;
    }
}

- (void)userLogout{
    [self.navView setRead:YES];
    _stroeModel = nil;
    [_headerView setUIWithModel:_homeModel stroeModel:_stroeModel];
    _imgStore.image = [UIImage imageNamed:@"icon-wgvilogo"];
}

- (void)userLogin{
    [self getUnInfo];
    [self.refresh reload];
}

- (void)getUnInfo{
    if([MEUserInfoModel isLogin]){
        kMeWEAKSELF
        [MEPublicNetWorkTool getUserCountListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    kMeSTRONGSELF
                    if(strongSelf->_navView){
                        NSInteger unread = [responseObject.data integerValue];
                        [strongSelf.navView setRead:!unread];
                    }
                });
        } failure:^(id object) {
        }];
    }
}

- (void)getNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGetappHomePageDataWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                strongSelf->_stroeModel = [MEStoreModel mj_objectWithKeyValues:responseObject.data];
            }else{
                strongSelf->_stroeModel = nil;
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_stroeModel = nil;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postThridHomeStyleWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_homeModel = [METhridHomeModel mj_objectWithKeyValues:responseObject.data];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });

    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postThridHomehomegetRecommendWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSArray class]]) {
                strongSelf->_arrHot =[MEGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            }else{
                strongSelf->_arrHot = [NSArray array];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_arrHot = [NSArray array];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postThridHomeRecommendAndSpreebuyWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                strongSelf->_spreebugmodel = [MEHomeRecommendAndSpreebuyModel mj_objectWithKeyValues:responseObject.data];
            }else{
                strongSelf->_spreebugmodel = nil;
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_spreebugmodel = nil;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf->_headerView setUIWithModel:strongSelf->_homeModel stroeModel:strongSelf->_stroeModel];
            if(strongSelf->_headerView.sdView){
                [strongSelf->_headerView.sdView makeScrollViewScrollToIndex:0];
            }
            [strongSelf setSdBackgroundColorWithIndex:0];
            if(strongSelf->_stroeModel){
                 kSDLoadImg(strongSelf->_imgStore, kMeUnNilStr(strongSelf->_stroeModel.mask_img));
            }else{
                strongSelf->_imgStore.image = [UIImage imageNamed:@"icon-wgvilogo"];
            }
            strongSelf->_imgStore.hidden = YES;
            strongSelf.tableView.tableHeaderView = strongSelf->_headerView;
            [strongSelf.tableView reloadData];
        });
    });
}

//弹窗
- (void)getRushGood{
    kMeWEAKSELF
    [MEPublicNetWorkTool postRushGoodWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            MEAdModel *model = [MEAdModel mj_objectWithKeyValues:responseObject.data];
            [MERushBuyView ShowWithModel:model tapBlock:^{
                if(model.product_id!=0){
                    kMeSTRONGSELF
                    strongSelf.tabBarController.selectedIndex = 0;
                    METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                    [strongSelf.navigationController pushViewController:dvc animated:YES];
                }
            } cancelBlock:^{
                
            } superView:weakSelf.view];
        }
    } failure:^(id object) {
        
    }];
}

- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self getNetWork];
    }
    NSDictionary *dic = _arrDicParm[_currentIndex];
    NSLog(@"---------%@",dic);
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)toStore{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 2?1+(kMeUnArr(_arrHot).count):1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(_homeModel && kMeUnNilStr(_homeModel.member_of_the_ritual_image).length){
            METhridHomeExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeExchangeCell class]) forIndexPath:indexPath];
            kSDLoadImg(cell.imgPic, kMeUnNilStr(_homeModel.member_of_the_ritual_image));
            return cell;
        }else{
            return [UITableViewCell new];
        }
    }else if(indexPath.section== 1){
        if(_spreebugmodel){
            METhridHomeTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeTopCell class]) forIndexPath:indexPath];
            [cell setUiWithModel:_spreebugmodel];
            return cell;
        }else{
            return [UITableViewCell new];
        }
    }else if(indexPath.section==2){
        if(indexPath.row == 0){
            METhridHomeGoodGoodFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeGoodGoodFilterCell class]) forIndexPath:indexPath];
            return cell;
        }else{
            METhridHomeGoodGoodMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class]) forIndexPath:indexPath];
            MEGoodModel *model = _arrHot[indexPath.row-1];
            [cell setUIWithModel:model];
            kMeWEAKSELF
            cell.buyBlock = ^{
                kMeSTRONGSELF
                MEGoodModel *model = strongSelf->_arrHot[indexPath.row-1];
                METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                [strongSelf.navigationController pushViewController:details animated:YES];
            };
            return cell;
        }
    }else if (indexPath.section==3){
        MECoupleHomeMainGoodGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECoupleHomeMainGoodGoodsCell class]) forIndexPath:indexPath];
        [cell setUIWithArr:self.refresh.arrData];
        kMeWEAKSELF
        cell.selectBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            MECoupleModel *model = self.refresh.arrData[index];
            if(kMeUnNilStr(model.coupon_id).length){
                MECoupleMailDetalVC *dvc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            }else{
                MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithModel:model];
                model.coupon_click_url = [NSString stringWithFormat:@"https:%@",kMeUnNilStr(model.coupon_share_url)];//;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    }else{
         return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(_homeModel && kMeUnNilStr(_homeModel.member_of_the_ritual_image).length){
            return kMEThridHomeExchangeCellheight;
        }else{
            return 0.1;
        }
    }else if(indexPath.section==1){
        if(_spreebugmodel){
            return kMEThridHomeTopCellHeight;
        }else{
            return 0.1;
        }
    }else if(indexPath.section==2){
        if(indexPath.row == 0){
            return [METhridHomeGoodGoodFilterCell getCellHeight];
        }
        return kMEThridHomeGoodGoodMainCellHeight;
    }else if (indexPath.section==3){
        return [MECoupleHomeMainGoodGoodsCell getCellHeightWithArr:self.refresh.arrData];;
    }else{
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 2 && indexPath.row > 0 && kMeUnArr(_arrHot).count>0){
        MEGoodModel *model = _arrHot[indexPath.row-1];
        METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
        [self.navigationController pushViewController:details animated:YES];
    }
    
    if(indexPath.section == 0 && _homeModel && kMeUnNilStr(_homeModel.member_of_the_ritual_image).length){
        if([MEUserInfoModel isLogin]){
            [self toReDeemVC];
        }else{
            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            } failHandler:nil];
        }
    }
}

- (void)toReDeemVC{
    kMeWEAKSELF
    [MEPublicNetWorkTool postcommonredeemgetStatusWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MERedeemgetStatusModel *model = [MERedeemgetStatusModel mj_objectWithKeyValues:responseObject.data];
        if(model.status == 1){
            METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.goods_id];
            [strongSelf.navigationController pushViewController:details animated:YES];
        }else{
            MEHomeAddRedeemcodeVC *vc = [[MEHomeAddRedeemcodeVC alloc]init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(id object) {
        
    }];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0.1;
    }else if(section==1){
        return 0.1;
    }else if(section==2){
        return MEMEThridGoodsGoodSectionViewHeight;
    }else{
        return kMMEThridHomeCommondSectionViewHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return [UIView new];
    }else if(section==1){
        return [UIView new];
    }else if(section==2){
        METhridGoodsGoodSectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([METhridGoodsGoodSectionView class])];
        return headview;
    }else{
        METhridHomeCommondSectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
        return headview;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y>=_alphaNum){
        _imgStore.hidden = NO;
    }else if (scrollView.contentOffset.y<0){
        _imgStore.hidden = YES;
    }else{
         _imgStore.hidden = YES;
    }
}

- (void)searchCoupon{
    MECouponSearchVC *searchViewController = [MECouponSearchVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索优惠券" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        MECoupleMailVC *dataVC = [[MECoupleMailVC alloc]initWithQuery:searchText];
        [searchViewController.navigationController pushViewController:dataVC animated:YES];
    }];
    [searchViewController setSearchHistoriesCachePath:kMECouponSearchVCSearchHistoriesCachePath];
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMEThridHomeNavViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleHomeMainGoodGoodsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECoupleHomeMainGoodGoodsCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeGoodGoodMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridHomeGoodGoodMainCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeGoodGoodFilterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridHomeGoodGoodFilterCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridGoodsGoodSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([METhridGoodsGoodSectionView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeCommondSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([METhridHomeCommondSectionView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridHomeTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridHomeExchangeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridHomeExchangeCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

- (UIImageView *)imgStore{
    if(!_imgStore){
        _imgStore = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-k15Margin-kImgStore, SCREEN_HEIGHT-kMeTabBarHeight-k15Margin-kImgStore, kImgStore, kImgStore)];
        _imgStore.cornerRadius = kImgStore/2;
        _imgStore.clipsToBounds = YES;
        _imgStore.hidden = YES;
        _imgStore.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toStore)];
        [_imgStore addGestureRecognizer:ges];
    }
    return _imgStore;
}

- (METhridHomeHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"METhridHomeHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [METhridHomeHeaderView getViewHeight]);
        kMeWEAKSELF
        _headerView.scrollToIndexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            [strongSelf setSdBackgroundColorWithIndex:index];
        };
    }
    return _headerView;
}

- (METhridHomeNavView *)navView{
    if(!_navView){
        _navView = [[METhridHomeNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEThridHomeNavViewHeight)];
        kMeWEAKSELF
        _navView.searchBlock = ^{
            kMeSTRONGSELF
            [strongSelf searchCoupon];
        };
        _navView.selectIndexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if(index>=0 && index<6){
                if(strongSelf->_currentIndex != index){
                    strongSelf->_currentIndex = index;
                    [strongSelf.refresh reload];
                }
            }
        };
    }
    return _navView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonTaobaokeGetDgMaterialOptional)];
        _refresh.delegate = self;
        _refresh.isCoupleMater = YES;
        _refresh.isPinduoduoCoupleMater = NO;
        _refresh.isDataInside = YES;
        _refresh.showFailView = NO;
//        _refresh.showMaskView = YES;
    }
    return _refresh;
}

@end
