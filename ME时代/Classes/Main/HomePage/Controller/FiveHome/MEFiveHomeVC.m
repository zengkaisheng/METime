//
//  MEFiveHomeVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFiveHomeVC.h"
#import "MEAdModel.h"

#import "MERushBuyView.h"
#import "MEFiveHomeNavView.h"
#import "MEFiveCategoryView.h"

#import "MEFiveHomeBaseVC.h"
#import "METhridProductDetailsVC.h"
#import "MEFourCouponSearchHomeVC.h"
#import "MECommunityServiceHomeVC.h"
#import "MELianTongListVC.h"
#import "MEPublicServiceCourseVC.h"
#import "MERegisteVolunteerVC.h"

@interface MEFiveHomeVC ()<UIScrollViewDelegate>{
    NSInteger _currentIndex;
    NSArray *_arrDicParm;
    CGFloat _contentOffSetX;
}
@property (nonatomic, strong) MEFiveHomeNavView *navView;
@property (nonatomic, strong) MEFiveCategoryView *categoryView;

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) MEFiveHomeBaseVC *choseVC;//精选
@property (nonatomic, strong) UIColor *currentColor;

@end

@implementation MEFiveHomeVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kMEf5f4f4;
    _currentIndex = 0;
    self.currentColor = [UIColor colorWithHexString:@"#2ED9A4"];
    [self requestMaterialData];
    
    [self getUnInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnInfo) name:kUnNoticeMessage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
    
    [self requestNetWorhWithClickRecord];
}

- (void)requestMaterialData {
    kMeWEAKSELF
    //新
    [MEPublicNetWorkTool postGetHomeNavWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf->_arrDicParm = [NSArray arrayWithArray:(NSArray *)responseObject.data];
        }else {
            strongSelf->_arrDicParm = [[NSArray alloc] init];
        }
        [strongSelf setUpUI];
    } failure:^(id object) {
        
    }];
//    [MEPublicNetWorkTool postGetMaterialWithSuccessBlock:^(ZLRequestResponse *responseObject) {
//        kMeSTRONGSELF
//        if ([responseObject.data isKindOfClass:[NSArray class]]) {
//            strongSelf->_arrDicParm = [NSArray arrayWithArray:(NSArray *)responseObject.data];
//        }else {
//            strongSelf->_arrDicParm = [[NSArray alloc] init];
//        }
//        [strongSelf setUpUI];
//    } failure:^(id object) {
//
//    }];
}

- (void)setUpUI {
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMEFiveHomeNavViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight)];
    self.scrollview.delegate = self;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * _arrDicParm.count,  SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight);//
    self.scrollview.bounces = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _arrDicParm.count; i++) {
        CGFloat top = 0.0;
        if (i > 0) {
            top = kMEFiveCategoryViewHeight;
        }
        NSDictionary *dict = _arrDicParm[i];
        if ([dict[@"title"] isEqualToString:@"公益课堂"]) {
            MEPublicServiceCourseVC *VC = [[MEPublicServiceCourseVC alloc] init];
            VC.isHome = YES;
            VC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            VC.view.frame = CGRectMake(SCREEN_WIDTH*i,top, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight-top);
            [self addChildViewController:VC];
            [self.scrollview addSubview:VC.view];
        }else  if ([dict[@"title"] isEqualToString:@"社区服务"]) {
            MECommunityServiceHomeVC *VC = [[MECommunityServiceHomeVC alloc] init];
            VC.isHome = YES;
            VC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            VC.view.frame = CGRectMake(SCREEN_WIDTH*i,top, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight-top);
            [self addChildViewController:VC];
            [self.scrollview addSubview:VC.view];
        }else if ([dict[@"title"] isEqualToString:@"福利领取"]) {
            MELianTongListVC *VC = [[MELianTongListVC alloc] init];
            VC.isHome = YES;
            VC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            VC.view.frame = CGRectMake(SCREEN_WIDTH*i,top, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight-top);
            [self addChildViewController:VC];
            [self.scrollview addSubview:VC.view];
        }else {
            MEFiveHomeBaseVC *VC = [[MEFiveHomeBaseVC alloc] initWithType:i materialArray:_arrDicParm];
            VC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            VC.view.frame = CGRectMake(SCREEN_WIDTH*i,top, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight-top);
            [self addChildViewController:VC];
            if (i == 0) {
                kMeWEAKSELF
                self.choseVC = VC;
                VC.selectedIndexBlock = ^(NSInteger index) {
                    kMeSTRONGSELF
                    if (index == 0) {
                        strongSelf.categoryView.hidden = YES;
                    }else {
                        strongSelf.categoryView.hidden = NO;
                    }
                    strongSelf.categoryView.categoryView.defaultSelectedIndex = index;
                    [strongSelf.categoryView.categoryView reloadData];
                };
                VC.changeColorBlock = ^(id object) {
                    kMeSTRONGSELF
                    if (strongSelf->_contentOffSetX <= SCREEN_WIDTH) {
                        if ([object isKindOfClass:[UIColor class]]) {
                            UIColor *color = (UIColor *)object;
                            strongSelf.navView.backgroundColor = color;
                            strongSelf.categoryView.backgroundColor = color;
                            strongSelf.currentColor = color;
                        }
                    }
                };
            }
            [self.scrollview addSubview:VC.view];
        }
    }
    
    [self.view addSubview:self.scrollview];
    
    self.scrollview.scrollEnabled = NO;
    self.navView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
    [self.view addSubview:self.navView];
    
    [self.categoryView setMaterArray:_arrDicParm];
    self.categoryView.categoryView.contentScrollView = self.scrollview;
    
    [self.view addSubview:self.categoryView];
    self.categoryView.hidden = YES;
    
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
    [self.choseVC reloadData];
}

- (void)userLogin{
    [self getUnInfo];
    [MEPublicNetWorkTool getUserInvitationCodeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        if ([responseObject.data isKindOfClass:[NSString class]]) {
            kCurrentUser.invite_code = [responseObject.data mutableCopy];
        }
    } failure:^(id object) {
    }];
    [self.choseVC reloadData];
}

- (void)getUnInfo{
    if([MEUserInfoModel isLogin]){
        kMeWEAKSELF
        [MEPublicNetWorkTool getUserCountListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                kMeSTRONGSELF
                if(strongSelf.navView){
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

#pragma mark -- ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _contentOffSetX = scrollView.contentOffset.x;
    if (_contentOffSetX > 0) {
        if (self.categoryView.hidden) {
            self.categoryView.hidden = NO;
            self.navView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        }
    }else {
        self.categoryView.hidden = YES;
        self.navView.backgroundColor = self.currentColor;
        [self.choseVC setCurrentIndex:0];
    }
    if (_contentOffSetX >= SCREEN_WIDTH) {
        self.navView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        self.categoryView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
    }
}

- (void)searchCoupon{
    MEFourCouponSearchHomeVC *searchHomeVC = [[MEFourCouponSearchHomeVC alloc] init];
    searchHomeVC.recordType = 5;
    [self.navigationController pushViewController:searchHomeVC animated:YES];
}

#pragma setter && getter
- (MEFiveHomeNavView *)navView{
    if(!_navView){
        _navView = [[MEFiveHomeNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEFiveHomeNavViewHeight)];
        kMeWEAKSELF
        _navView.searchBlock = ^{
            kMeSTRONGSELF
            [strongSelf searchCoupon];
        };
    }
    return _navView;
}

- (MEFiveCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[MEFiveCategoryView alloc] initWithFrame:CGRectMake(0, kMEFiveHomeNavViewHeight, SCREEN_WIDTH, kMEFiveCategoryViewHeight)];
        _categoryView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        kMeWEAKSELF
        _categoryView.selectIndexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if(index>=0 && index<6){
                if(strongSelf->_currentIndex != index){
                    NSDictionary *dict = strongSelf->_arrDicParm[index];
                    if ([dict[@"title"] isEqualToString:@"公益课堂"] || [dict[@"title"] isEqualToString:@"社区服务"]) {
                        if (kCurrentUser.is_volunteer != 1) {
                            MERegisteVolunteerVC *vc = [[MERegisteVolunteerVC alloc] init];
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                            strongSelf->_categoryView.categoryView.defaultSelectedIndex = strongSelf->_currentIndex;
                            [strongSelf->_categoryView.categoryView reloadData];
                            [strongSelf.choseVC setCurrentIndex:0];
                        }else {
                            strongSelf->_currentIndex = index;
                            if (index > 0) {
                                strongSelf.navView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
                                strongSelf.categoryView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
                            }else {
                                [strongSelf.choseVC setCurrentIndex:0];
                            }
                        }
                    }else {
                        strongSelf->_currentIndex = index;
                        if (index > 0) {
                            strongSelf.navView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
                            strongSelf.categoryView.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
                        }else {
                            [strongSelf.choseVC setCurrentIndex:0];
                        }
                    }
                    
                }
            }
        };
    }
    return _categoryView;
}


@end
