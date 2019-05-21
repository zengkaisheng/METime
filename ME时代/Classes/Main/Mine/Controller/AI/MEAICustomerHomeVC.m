//
//  MEAICustomerHomeVC.m
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAICustomerHomeVC.h"
#import "MEAICustomerHomeContentVC.h"
#import "MEAICustomerHomeHeaderSearchView.h"
#import "MEAICustomerSearchVC.h"
#import "MENavigationVC.h"
#import "MEAICustomerSearchDataVC.h"

@interface MEAICustomerHomeVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
    MEAICustomerHomeContentVCType _currentType;
    
}
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) MEAICustomerHomeContentVC *addtimeVC;
@property (nonatomic, strong) MEAICustomerHomeContentVC *flowtimeVC;
@property (nonatomic, strong) MEAICustomerHomeContentVC *activetimeC;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEAICustomerHomeHeaderSearchView *headerView;

@end

@implementation MEAICustomerHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    _arrType = @[@"加入时间",@"跟进时间",@"活跃时间"];
    _currentType = 0;
    [self.view addSubview:self.headerView];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight+kMEAICustomerHomeHeaderSearchViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMeTabBarHeight-kMEAICustomerHomeHeaderSearchViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMeTabBarHeight-kMEAICustomerHomeHeaderSearchViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.addtimeVC.view];
    [self.scrollView addSubview:self.flowtimeVC.view];
    [self.scrollView addSubview:self.activetimeC.view];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight+kMEAICustomerHomeHeaderSearchViewHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    
    
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorLineWidth = 40;
//    lineView.indicatorLineViewColor = kME333333;
//    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"55ba14"];
    self.categoryView.titleColor = kME333333;
    self.categoryView.contentScrollView = self.scrollView;
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = _currentType;
    
}


- (void)toSearchData{
    kMeWEAKSELF
    MEAICustomerSearchVC *searchViewController = [MEAICustomerSearchVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索客户" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        kMeSTRONGSELF
        MEAICustomerSearchDataVC *dataVC = [[MEAICustomerSearchDataVC alloc]initWithKey:searchText type:strongSelf->_currentType];
        [searchViewController.navigationController pushViewController:dataVC animated:YES];
    }];
    [searchViewController setSearchHistoriesCachePath:kMEMEAICustomerSearchVCHistoriesCachePath];
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

- (MEAICustomerHomeContentVC *)addtimeVC{
    if(!_addtimeVC){
        _addtimeVC = [[MEAICustomerHomeContentVC alloc]initWithType:0];
        _addtimeVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _addtimeVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMeTabBarHeight-kMEAICustomerHomeHeaderSearchViewHeight);
        [self addChildViewController:_addtimeVC];
    }
    return _addtimeVC;
}

- (MEAICustomerHomeContentVC *)flowtimeVC{
    if(!_flowtimeVC){
        _flowtimeVC = [[MEAICustomerHomeContentVC alloc]initWithType:1];
        _flowtimeVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _flowtimeVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMeTabBarHeight-kMEAICustomerHomeHeaderSearchViewHeight);
        [self addChildViewController:_flowtimeVC];
    }
    return _flowtimeVC;
}

- (MEAICustomerHomeContentVC *)activetimeC{
    if(!_activetimeC){
        _activetimeC = [[MEAICustomerHomeContentVC alloc]initWithType:2];
        _activetimeC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _activetimeC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMeTabBarHeight-kMEAICustomerHomeHeaderSearchViewHeight);
        [self addChildViewController:_activetimeC];
    }
    return _activetimeC;
}

- (MEAICustomerHomeHeaderSearchView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEAICustomerHomeHeaderSearchView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, kMEAICustomerHomeHeaderSearchViewHeight);
        kMeWEAKSELF
        _headerView.touchBlock = ^{
            kMeSTRONGSELF
            strongSelf->_currentType = strongSelf.categoryView.selectedIndex;
            [strongSelf toSearchData];
        };
    }
    return _headerView;
}
@end
