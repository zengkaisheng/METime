//
//  MEMyGroupOrderVC.m
//  ME时代
//
//  Created by gao lei on 2019/7/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyGroupOrderVC.h"
#import "MEMyGroupOrderContentVC.h"

@interface MEMyGroupOrderVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
    MEOrderStyle _currentType;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEMyGroupOrderContentVC *processVC;
@property (nonatomic, strong) MEMyGroupOrderContentVC *finishVC;
@property (nonatomic, strong) MEMyGroupOrderContentVC *failVC;

@end

@implementation MEMyGroupOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的拼团";
    _arrType = @[@"进行中",@"已完成",@"失败"] ;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.processVC.view];
    [self.scrollView addSubview:self.finishVC.view];
    [self.scrollView addSubview:self.failVC.view];
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
}

#pragma mark - Setter And Getter
- (MEMyGroupOrderContentVC *)processVC {
    if (!_processVC) {
        _processVC = [[MEMyGroupOrderContentVC alloc] initWithType:10];
        _processVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _processVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_processVC];
    }
    return _processVC;
}

- (MEMyGroupOrderContentVC *)finishVC {
    if (!_finishVC) {
        _finishVC = [[MEMyGroupOrderContentVC alloc] initWithType:11];
        _finishVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _finishVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_finishVC];
    }
    return _finishVC;
}

- (MEMyGroupOrderContentVC *)failVC {
    if (!_failVC) {
        _failVC = [[MEMyGroupOrderContentVC alloc] initWithType:12];
        _failVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _failVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_failVC];
    }
    return _failVC;
}

@end
