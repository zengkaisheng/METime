//
//  MECourseChargeOrFreeListVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseChargeOrFreeListVC.h"
#import "MECourseChargeOrFreeBaseVC.h"

@interface MECourseChargeOrFreeListVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *arrType;
@property (nonatomic, assign) BOOL isFree;

@property (nonatomic, strong) MECourseChargeOrFreeBaseVC *videoListVC;
@property (nonatomic, strong) MECourseChargeOrFreeBaseVC *audioListVC;

@end

@implementation MECourseChargeOrFreeListVC

- (instancetype)initWithIsFree:(BOOL)isFree {
    if (self = [super init]) {
        _isFree = isFree;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arrType = @[@"视频列表",@"音频列表"];
    if (self.isFree) {
        self.title = @"免费课程列表";
    }else {
        self.title = @"收费课程列表";
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.videoListVC.view];
    [self.scrollView addSubview:self.audioListVC.view];
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
- (MECourseChargeOrFreeBaseVC *)videoListVC {
    if (!_videoListVC) {
        _videoListVC = [[MECourseChargeOrFreeBaseVC alloc] initWithType:0 isFree:self.isFree];
        _videoListVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _videoListVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_videoListVC];
    }
    return _videoListVC;
}

- (MECourseChargeOrFreeBaseVC *)audioListVC {
    if (!_audioListVC) {
        _audioListVC = [[MECourseChargeOrFreeBaseVC alloc] initWithType:1 isFree:self.isFree];
        _audioListVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _audioListVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_audioListVC];
    }
    return _audioListVC;
}

@end
