//
//  MEMySelfExtractionOrderVC.m
//  ME时代
//
//  Created by hank on 2019/2/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEMySelfExtractionOrderVC.h"
#import "MEMySelfExtractionContentOrderVC.h"
#import "MESearchSelfExtraceVC.h"
#import "MENavigationVC.h"
#import "MESearchSelfExtraceDataVC.h"

@interface MEMySelfExtractionOrderVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
    MEOSelfExtractionrderStyle _currentType;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEMySelfExtractionContentOrderVC *notExtractVC;
@property (nonatomic, strong) MEMySelfExtractionContentOrderVC *extractedVC;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MEMySelfExtractionOrderVC

- (instancetype)initWithType:(MEOSelfExtractionrderStyle)type{
    if(self = [super init]){
        _currentType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自提订单";
    _arrType = @[@"未提取",@"已提取"] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.notExtractVC.view];
    [self.scrollView addSubview:self.extractedVC.view];

    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    //    self.categoryView.lineStyle = JXCategoryLineStyle_None;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = _currentType;
    //self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * _currentType, 0);
    // Do any additional setup after loading the view.
}

#pragma mark - Setter And Getter

- (MEMySelfExtractionContentOrderVC *)notExtractVC{
    if(!_notExtractVC){
        _notExtractVC = [[MEMySelfExtractionContentOrderVC alloc]initWithType:MEOSelfNotExtractionrderStyle];
        _notExtractVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _notExtractVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_notExtractVC];
    }
    return _notExtractVC;
}

- (MEMySelfExtractionContentOrderVC *)extractedVC{
    if(!_extractedVC){
        _extractedVC = [[MEMySelfExtractionContentOrderVC alloc]initWithType:MEOSelfExtractionedrderStyle];
        _extractedVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _extractedVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_extractedVC];
    }
    return _extractedVC;
}

- (void)searchOrder{
    MESearchSelfExtraceVC *searchViewController = [MESearchSelfExtraceVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索订单号" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        MESearchSelfExtraceDataVC *vc = [[MESearchSelfExtraceDataVC alloc]initWithQuery:searchText];
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
    [searchViewController setSearchHistoriesCachePath:kMESelfExtraceSearchVCSearchHistoriesCachePath];
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 30, 25);
        _btnRight.contentMode = UIViewContentModeRight;
        [_btnRight setImage:[UIImage imageNamed:@"common_nav_btn_search"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(searchOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
