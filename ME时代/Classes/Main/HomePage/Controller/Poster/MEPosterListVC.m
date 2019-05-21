//
//  MEPosterListVC.m
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEPosterListVC.h"
#import "MEPosterContentListVC.h"
#import "MEMyPosterContentListVC.h"

@interface MEPosterListVC()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
    NSInteger _currentType;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEPosterContentListVC *listVC;
@property (nonatomic, strong) MEMyPosterContentListVC *mylistVC;
@property (nonatomic, strong) MEMyPosterContentListVC *activictVC;
@end

@implementation MEPosterListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"海报";
    _currentType = 0;
    _arrType = @[@"海报列表",@"活动海报",@"我的分享"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.listVC.view];
    [self.scrollView addSubview:self.activictVC.view];
    [self.scrollView addSubview:self.mylistVC.view];
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 55 *kMeFrameScaleX();
    lineView.indicatorLineViewColor =  [UIColor colorWithHexString:@"333333"];
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    //    self.categoryView.lineStyle = JXCategoryLineStyle_None;
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"333333"];
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
    self.categoryView.contentScrollView = self.scrollView;
//    self.categoryView.indicatorLineWidth = 55 *kMeFrameScaleX();
//    self.categoryView.indicatorLineViewColor = [UIColor colorWithHexString:@"333333"];
//    self.categoryView.indicatorLineViewHeight = 2;
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = _currentType;
}

#pragma mark - Setter And Getter

- (MEPosterContentListVC *)listVC{
    if(!_listVC){
        _listVC = [[MEPosterContentListVC alloc]init];
        _listVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _listVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_listVC];
    }
    return _listVC;
}

- (MEMyPosterContentListVC *)mylistVC{
    if(!_mylistVC){
        _mylistVC = [[MEMyPosterContentListVC alloc]init];
        _mylistVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _mylistVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_mylistVC];
    }
    return _mylistVC;
}

- (MEMyPosterContentListVC *)activictVC{
    if(!_activictVC){
        _activictVC = [[MEMyPosterContentListVC alloc]initWithActice];
        _activictVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _activictVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_activictVC];
    }
    return _activictVC;
}
@end
