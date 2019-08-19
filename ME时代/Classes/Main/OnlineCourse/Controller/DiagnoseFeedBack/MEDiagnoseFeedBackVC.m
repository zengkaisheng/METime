//
//  MEDiagnoseFeedBackVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseFeedBackVC.h"
#import "MEDiagnoseFeedBackBaseVC.h"

@interface MEDiagnoseFeedBackVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) MEDiagnoseFeedBackBaseVC *consultVC;//问题咨询
@property (nonatomic, strong) MEDiagnoseFeedBackBaseVC *reoprtVC;//诊断反馈

@end

@implementation MEDiagnoseFeedBackVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"诊断反馈";
    
    _arrType = @[@"问题咨询",@"诊断反馈"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.consultVC.view];
    [self.scrollView addSubview:self.reoprtVC.view];
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 55 *kMeFrameScaleX();
    lineView.indicatorLineViewColor = kMEPink;//[UIColor colorWithHexString:@"333333"];
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
}

#pragma MARK - Setter
- (MEDiagnoseFeedBackBaseVC *)consultVC {
    if (!_consultVC) {
        _consultVC = [[MEDiagnoseFeedBackBaseVC alloc] initWithType:1];
        _consultVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _consultVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_consultVC];
    }
    return _consultVC;
}

- (MEDiagnoseFeedBackBaseVC *)reoprtVC {
    if (!_reoprtVC) {
        _reoprtVC = [[MEDiagnoseFeedBackBaseVC alloc] initWithType:2];
        _reoprtVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _reoprtVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_reoprtVC];
    }
    return _reoprtVC;
}



@end
