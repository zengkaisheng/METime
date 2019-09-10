//
//  MELianTongOrderVC.m
//  ME时代
//
//  Created by gao lei on 2019/9/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MELianTongOrderVC.h"
#import "MELianTongContentVC.h"

@interface MELianTongOrderVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MELianTongContentVC *allVC;
@property (nonatomic, strong) MELianTongContentVC *needPayVC;
@property (nonatomic, strong) MELianTongContentVC *deliveryVC;
@property (nonatomic, strong) MELianTongContentVC *finishVC;

@end

@implementation MELianTongOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联通订单";
    _arrType = @[@"全部",@"待付款",@"待充值",@"已充值"];
    if (self.isTopUp) {
        self.title = @"联通充值订单";
        _arrType = @[@"全部",@"待充值",@"已充值"];
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.allVC.view];
    if (!self.isTopUp) {
        [self.scrollView addSubview:self.needPayVC.view];
    }
    [self.scrollView addSubview:self.deliveryVC.view];
    [self.scrollView addSubview:self.finishVC.view];
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
    self.categoryView.defaultSelectedIndex = 0;
}

#pragma mark - Setter And Getter
- (MELianTongContentVC *)allVC{
    if(!_allVC){
        _allVC = [[MELianTongContentVC alloc] initWithType:0 isTopUp:_isTopUp];
        _allVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _allVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_allVC];
    }
    return _allVC;
}

- (MELianTongContentVC *)needPayVC{
    if(!_needPayVC){
        _needPayVC = [[MELianTongContentVC alloc] initWithType:1 isTopUp:_isTopUp];
        _needPayVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _needPayVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_needPayVC];
    }
    return _needPayVC;
}

- (MELianTongContentVC *)deliveryVC{
    if(!_deliveryVC){
        _deliveryVC = [[MELianTongContentVC alloc] initWithType:2 isTopUp:_isTopUp];
        _deliveryVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        if (self.isTopUp) {
            _deliveryVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        }
        _deliveryVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_deliveryVC];
    }
    return _deliveryVC;
}

- (MELianTongContentVC *)finishVC{
    if(!_finishVC){
        _finishVC = [[MELianTongContentVC alloc] initWithType:3 isTopUp:_isTopUp];
        _finishVC.view.frame = CGRectMake(SCREEN_WIDTH*3,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        if (self.isTopUp) {
            _finishVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        }
        _finishVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_finishVC];
    }
    return _finishVC;
}

@end
