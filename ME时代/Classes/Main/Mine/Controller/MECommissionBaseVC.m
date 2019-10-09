//
//  MECommissionBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/10/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommissionBaseVC.h"
#import "MECommissionListVC.h"

@interface MECommissionBaseVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
    MEOrderStyle _currentType;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MECommissionListVC *productVC;
@property (nonatomic, strong) MECommissionListVC *courseVC;
@property (nonatomic, strong) MECommissionListVC *vipVC;

@end

@implementation MECommissionBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"佣金订单";
    _arrType = @[@"商品",@"课程",@"VIP"] ;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight+7, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-7)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-7);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.productVC.view];
    [self.scrollView addSubview:self.courseVC.view];
    [self.scrollView addSubview:self.vipVC.view];
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight+7, SCREEN_WIDTH, kCategoryViewHeight)];
    //    self.categoryView.lineStyle = JXCategoryLineStyle_None;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
}

#pragma mark - Setter And Getter
- (MECommissionListVC *)productVC{
    if(!_productVC){
        _productVC = [[MECommissionListVC alloc]initWithType:1];
        _productVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _productVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_productVC];
    }
    return _productVC;
}

- (MECommissionListVC *)courseVC{
    if(!_courseVC){
        _courseVC = [[MECommissionListVC alloc]initWithType:2];
        _courseVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _courseVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_courseVC];
    }
    return _courseVC;
}

- (MECommissionListVC *)vipVC{
    if(!_vipVC){
        _vipVC = [[MECommissionListVC alloc]initWithType:3];
        _vipVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _vipVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_vipVC];
    }
    return _vipVC;
}


@end
