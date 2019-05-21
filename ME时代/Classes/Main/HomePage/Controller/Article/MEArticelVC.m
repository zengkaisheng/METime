//
//  MEArticelVC.m
//  ME时代
//
//  Created by hank on 2018/11/30.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEArticelVC.h"
#import "MEArticleListVC.h"
#import "MEArticelSearchVC.h"
#import "MEArticelSearchDataVC.h"
#import "MENavigationVC.h"
#import "MEArticelCategoryModel.h"

@interface MEArticelVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSMutableArray *_arrType;
}

@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSMutableArray *arrVC;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MEArticelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章";
    _arrType = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    [self requestNetWork];
    // Do any additional setup after loading the view.
}

- (void)initSomeThing{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    NSMutableArray *arrTitle = [NSMutableArray array];
    for (NSInteger i=0;i<_arrType.count;i++) {
        MEArticelCategoryModel *model = _arrType[i];
        [arrTitle addObject:kMeUnNilStr(model.article_name)];
        MEArticleListVC *vc = [[MEArticleListVC alloc]initWithModel:model];
        vc.view.frame = CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:vc];
        [self.arrVC addObject:vc];
        [self.scrollView addSubview:vc.view];
    }
    
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
//    self.categoryView.lineStyle = JXCategoryLineStyle_None;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor =  [UIColor colorWithHexString:@"333333"];
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = arrTitle;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"333333"];
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
    self.categoryView.contentScrollView = self.scrollView;
//    self.categoryView.indicatorLineViewColor = [UIColor colorWithHexString:@"333333"];
//    self.categoryView.indicatorLineViewHeight = 2;
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
}

- (void)requestNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postArticleClassWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MEArticelCategoryModel *model = [MEArticelCategoryModel new];
        model.article_name = @"全部文章";
        model.idField = 0;
        [strongSelf->_arrType addObject:model];
        [strongSelf->_arrType addObjectsFromArray:[MEArticelCategoryModel mj_objectArrayWithKeyValuesArray:responseObject.data]];
        [strongSelf initSomeThing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)searchArticel:(UIButton *)btn{
    MEArticelSearchVC *searchViewController = [MEArticelSearchVC searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索文章" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        MEArticelSearchDataVC *dataVC = [[MEArticelSearchDataVC alloc]initWithKey:searchText];
        [searchViewController.navigationController pushViewController:dataVC animated:YES];
    }];
    [searchViewController setSearchHistoriesCachePath:kMEArticelVCSearchHistoriesCachePath];
    MENavigationVC *nav = [[MENavigationVC alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}


- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 30, 25);
        _btnRight.contentMode = UIViewContentModeRight;
        [_btnRight setImage:[UIImage imageNamed:@"common_nav_btn_search"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(searchArticel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

- (NSMutableArray *)arrVC{
    if(!_arrVC){
        _arrVC = [NSMutableArray array];
    }
    return _arrVC;
}

@end
