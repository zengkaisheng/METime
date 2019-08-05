//
//  MEFourHomeVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourHomeVC.h"

#import "METhridHomeNavView.h"
#import "MEAdModel.h"
#import "METhridHomeModel.h"

#import "MERushBuyView.h"
#import "MECouponSearchVC.h"
#import "MECoupleMailVC.h"
#import "MENavigationVC.h"
#import "METhridProductDetailsVC.h"
#import "MEFourHomeBaseVC.h"
//#import "MECoupleHomeVC.h"
#import "MEJDCoupleHomeVC.h"

#import "MEFourCouponSearchHomeVC.h"

#import "MEOnlineCourseVC.h"

@interface MEFourHomeVC ()<UIScrollViewDelegate>{
    METhridHomeModel *_homeModel;
    MEStoreModel *_stroeModel;
    NSInteger _currentIndex;
    NSArray *_arrDicParm;
    CGFloat _contentOffSetX;
}


@property (nonatomic, strong) METhridHomeNavView *navView;

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) MEFourHomeBaseVC *choseVC;//精选
@property (nonatomic, strong) MEFourHomeBaseVC *specialSaleVC;//特卖
@property (nonatomic, strong) MEFourHomeBaseVC *guessVC;//猜你喜欢
@property (nonatomic, strong) MEFourHomeBaseVC *ladiesVC;//女装
@property (nonatomic, strong) MEFourHomeBaseVC *cosmeticsVC;//美妆
@property (nonatomic, strong) MEFourHomeBaseVC *pregnantVC;//母婴

@end

@implementation MEFourHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kMEf5f4f4;
    _currentIndex = 0;
//    _arrDicParm = @[@{@"type":@"3"},@{@"material_id":@"3756"},@{@"material_id":@"3786"},@{@"material_id":@"3767"},@{@"material_id":@"3763"},@{@"material_id":@"3760"}];
    [self requestMaterialData];
    
//    [self getRushGood];
    [self getUnInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnInfo) name:kUnNoticeMessage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
    
    [self requestNetWorhWithClickRecord];
}

- (void)requestMaterialData {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetMaterialWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf->_arrDicParm = [NSArray arrayWithArray:(NSArray *)responseObject.data];
        }else {
            strongSelf->_arrDicParm = [[NSArray alloc] init];
        }
        [strongSelf setUpUI];
    } failure:^(id object) {
        
    }];
}

- (void)setUpUI {
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMEThridHomeNavViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight)];
    self.scrollview.delegate = self;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * _arrDicParm.count,  SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight);//
    self.scrollview.bounces = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
//    [self.scrollview addSubview:self.choseVC.view];
//    [self.scrollview addSubview:self.specialSaleVC.view];
//    [self.scrollview addSubview:self.guessVC.view];
//    [self.scrollview addSubview:self.ladiesVC.view];
//    [self.scrollview addSubview:self.cosmeticsVC.view];
//    [self.scrollview addSubview:self.pregnantVC.view];
    for (int i = 0; i < _arrDicParm.count; i++) {
        MEFourHomeBaseVC *VC = [[MEFourHomeBaseVC alloc] initWithType:i materialArray:_arrDicParm];
        VC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        VC.view.frame = CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight);
        [self addChildViewController:VC];
        if (i == 0) {
            kMeWEAKSELF
            VC.changeColorBlock = ^(id object) {
                kMeSTRONGSELF
                if (strongSelf->_contentOffSetX <= SCREEN_WIDTH) {
                    if ([object isKindOfClass:[UIColor class]]) {
                        UIColor *color = (UIColor *)object;
                        strongSelf.navView.backgroundColor = color;
                    }
                }
            };
        }
        [self.scrollview addSubview:VC.view];
    }
    
    [self.view addSubview:self.scrollview];
    
    self.navView.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    [self.navView setMaterArray:_arrDicParm];
    [self.view addSubview:self.navView];
    self.navView.categoryView.contentScrollView = self.scrollview;
    self.navBarHidden = YES;
    
    [self getRushGood];
}

- (void)requestNetWorhWithClickRecord {
    
    NSArray *records = [kMeUserDefaults objectForKey:kMEGetClickRecord];
    if (records.count > 0) {
//        NSLog(@"record:%@",records);
        NSString *paramsStr = [NSString convertToJsonData:records];
        [MEPublicNetWorkTool recordTapActionWithParameter:@{@"parameter":paramsStr}];
    }
}

- (void)userLogout{
    [self.navView setRead:YES];
    _stroeModel = nil;
//    [self.choseVC setHeaderViewUIWithModel:_homeModel stroeModel:_stroeModel optionsArray:@[]];
    [self.choseVC reloadData];
    [self.specialSaleVC reloadData];
    [self.guessVC reloadData];
    [self.ladiesVC reloadData];
    [self.cosmeticsVC reloadData];
    [self.pregnantVC reloadData];
}

- (void)userLogin{
    [self getUnInfo];
    [self.choseVC reloadData];
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

//弹窗
- (void)getRushGood{
    kMeWEAKSELF
    [MEPublicNetWorkTool postRushGoodWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            MEAdModel *model = [MEAdModel mj_objectWithKeyValues:responseObject.data];
            [MERushBuyView ShowWithModel:model tapBlock:^{
                kMeSTRONGSELF
                if (model.show_type == 8) {
                    [strongSelf.choseVC toStore];
                }else {
                    if(model.product_id!=0){
                        strongSelf.tabBarController.selectedIndex = 0;
                        METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                        [strongSelf.navigationController pushViewController:dvc animated:YES];
                    }
                }
            } cancelBlock:^{
                
            } superView:weakSelf.view];
        }
    } failure:^(id object) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _contentOffSetX = scrollView.contentOffset.x;
    if (_contentOffSetX > SCREEN_WIDTH) {
        self.navView.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    }
}

- (void)searchCoupon{
    MEFourCouponSearchHomeVC *searchHomeVC = [[MEFourCouponSearchHomeVC alloc] init];
    searchHomeVC.recordType = 5;
    [self.navigationController pushViewController:searchHomeVC animated:YES];
    
//    MECouponSearchVC *searchViewController = [MECouponSearchVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索优惠券" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//        MECoupleMailVC *dataVC = [[MECoupleMailVC alloc]initWithQuery:searchText];
//        [searchViewController.navigationController pushViewController:dataVC animated:YES];
//    }];
//    [searchViewController setSearchHistoriesCachePath:kMECouponSearchVCSearchHistoriesCachePath];
//    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
//    [self presentViewController:nav  animated:NO completion:nil];
}

#pragma setter && getter
- (METhridHomeNavView *)navView{
    if(!_navView){
        _navView = [[METhridHomeNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEThridHomeNavViewHeight)];
        kMeWEAKSELF
        _navView.searchBlock = ^{
            kMeSTRONGSELF
//            [strongSelf searchCoupon];
            MEOnlineCourseVC *vc = [[MEOnlineCourseVC alloc] init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        _navView.selectIndexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if(index>=0 && index<6){
                if(strongSelf->_currentIndex != index){
                    strongSelf->_currentIndex = index;
                    if (index > 0) {
                        strongSelf.navView.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
                    }
                }
            }
        };
    }
    return _navView;
}
/*
- (MEFourHomeBaseVC *)choseVC {
    if (!_choseVC) {
        _choseVC = [[MEFourHomeBaseVC alloc] initWithType:0];
        _choseVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _choseVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight);
        kMeWEAKSELF
        _choseVC.changeColorBlock = ^(id object) {
            kMeSTRONGSELF
            if (strongSelf->_contentOffSetX <= SCREEN_WIDTH) {
                if ([object isKindOfClass:[UIColor class]]) {
                    UIColor *color = (UIColor *)object;
                    strongSelf.navView.backgroundColor = color;
                }
            }
        };
        [self addChildViewController:_choseVC];
    }
    return _choseVC;
}

- (MEFourHomeBaseVC *)specialSaleVC {
    if (!_specialSaleVC) {
        _specialSaleVC = [[MEFourHomeBaseVC alloc] initWithType:1];
        _specialSaleVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _specialSaleVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight);
        [self addChildViewController:_specialSaleVC];
    }
    return _specialSaleVC;
}

- (MEFourHomeBaseVC *)guessVC {
    if (!_guessVC) {
        _guessVC = [[MEFourHomeBaseVC alloc] initWithType:2];
        _guessVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _guessVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight);
        [self addChildViewController:_guessVC];
    }
    return _guessVC;
}

- (MEFourHomeBaseVC *)ladiesVC {
    if (!_ladiesVC) {
        _ladiesVC = [[MEFourHomeBaseVC alloc] initWithType:3];
        _ladiesVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _ladiesVC.view.frame = CGRectMake(SCREEN_WIDTH*3,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight);
        [self addChildViewController:_ladiesVC];
    }
    return _ladiesVC;
}

- (MEFourHomeBaseVC *)cosmeticsVC {
    if (!_cosmeticsVC) {
        _cosmeticsVC = [[MEFourHomeBaseVC alloc] initWithType:4];
        _cosmeticsVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _cosmeticsVC.view.frame = CGRectMake(SCREEN_WIDTH*4,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight);
        [self addChildViewController:_cosmeticsVC];
    }
    return _cosmeticsVC;
}

- (MEFourHomeBaseVC *)pregnantVC {
    if (!_pregnantVC) {
        _pregnantVC = [[MEFourHomeBaseVC alloc] initWithType:5];
        _pregnantVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pregnantVC.view.frame = CGRectMake(SCREEN_WIDTH*5,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight);
        [self addChildViewController:_pregnantVC];
    }
    return _pregnantVC;
}
*/

@end
