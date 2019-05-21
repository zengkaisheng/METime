//
//  MEPNewAVistorVC.m
//  ME时代
//
//  Created by hank on 2019/4/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEPNewAVistorVC.h"
#import "MEPNewAVistorContentVC.h"

@interface MEPNewAVistorVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>
{
    NSArray *_arrType;
    
}
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEPNewAVistorContentVC *posterVC;
@property (nonatomic, strong) MEPNewAVistorContentVC *articleVC;

@end

@implementation MEPNewAVistorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"获客图文";
    _arrType = @[@"获客海报",@"获客文章"] ;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.posterVC.view];
    [self.scrollView addSubview:self.articleVC.view];
    
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    //    self.categoryView.lineStyle = JXCategoryLineStyle_None;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = kMEPink;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    [self.view addSubview:self.categoryView];
    //self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * _currentType, 0);
    // Do any additional setup after loading the view.
}

#pragma mark - Setter And Getter

- (MEPNewAVistorContentVC *)posterVC{
    if(!_posterVC){
        _posterVC = [[MEPNewAVistorContentVC alloc]initWithPoster];
        _posterVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _posterVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_posterVC];
    }
    return _posterVC;
}

- (MEPNewAVistorContentVC *)articleVC{
    if(!_articleVC){
        _articleVC = [[MEPNewAVistorContentVC alloc]initWithArticel];
        _articleVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _articleVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_articleVC];
    }
    return _articleVC;
}

@end
