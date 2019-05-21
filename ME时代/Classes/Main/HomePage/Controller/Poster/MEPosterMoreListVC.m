//
//  MEPosterMoreListVC.m
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEPosterMoreListVC.h"
#import "MEPosterMoreListContentVC.h"
#import "MEPosterModel.h"

@interface MEPosterMoreListVC()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
    NSInteger _currentType;
    MEPosterModel *_model;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEPosterMoreListContentVC *newVC;
@property (nonatomic, strong) MEPosterMoreListContentVC *TopVC;

@end

@implementation MEPosterMoreListVC

- (instancetype)initWithModel:(MEPosterModel *)Model{
    if(self = [super init]){
        _model = Model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"海报";
    _currentType = 0;
    _arrType = @[@"上架时间最新",@"分享量最高"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.newVC.view];
    [self.scrollView addSubview:self.TopVC.view];
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 55 *kMeFrameScaleX();
    lineView.indicatorLineViewColor = [UIColor colorWithHexString:@"333333"];
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
//    self.categoryView.lineStyle = JXCategoryLineStyle_None;
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"333333"];
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
    self.categoryView.contentScrollView = self.scrollView;

    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = _currentType;
}

#pragma mark - Setter And Getter

- (MEPosterMoreListContentVC *)newVC{
    if(!_newVC){
        _newVC = [[MEPosterMoreListContentVC alloc]initWithModel:_model isNew:YES];
        _newVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _newVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_newVC];
    }
    return _newVC;
}

- (MEPosterMoreListContentVC *)TopVC{
    if(!_TopVC){
        _TopVC = [[MEPosterMoreListContentVC alloc]initWithModel:_model isNew:NO];
        _TopVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _TopVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_TopVC];
    }
    return _TopVC;
}
@end
