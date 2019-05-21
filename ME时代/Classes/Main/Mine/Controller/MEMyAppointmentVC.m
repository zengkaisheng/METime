//
//  MEMyAppointmentVC.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyAppointmentVC.h"
#import "MEMyAppointmentContentVC.h"

@interface MEMyAppointmentVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
    MEAppointmenyStyle _currentType;
    MEClientTypeStyle _userType;//那个端展示的预约
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEMyAppointmentContentVC *useingVC;
@property (nonatomic, strong) MEMyAppointmentContentVC *usedVC;
@property (nonatomic, strong) MEMyAppointmentContentVC *notUseVC;

@end

@implementation MEMyAppointmentVC

- (instancetype)initWithType:(MEAppointmenyStyle)type{
    if(self = [super init]){
        _currentType = type;
        _userType = MEClientCTypeStyle;
    }
    return self;
}

- (instancetype)initWithType:(MEAppointmenyStyle)type userType:(MEClientTypeStyle)userType{
    if(self = [super init]){
        _currentType = type;
        _userType = userType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_userType == MEClientCTypeStyle){
         self.title = @"我的预约";
    }else{
        self.title = @"预约管理";
    }
    _arrType = MEAppointmenyStyleTitle;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.useingVC.view];
    [self.scrollView addSubview:self.usedVC.view];
    [self.scrollView addSubview:self.notUseVC.view];
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

- (MEMyAppointmentContentVC *)useingVC{
    if(!_useingVC){
        _useingVC = [[MEMyAppointmentContentVC alloc]initWithType:0 userType:_userType];
        _useingVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _useingVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_useingVC];
    }
    return _useingVC;
}

- (MEMyAppointmentContentVC *)usedVC{
    if(!_usedVC){
        _usedVC = [[MEMyAppointmentContentVC alloc]initWithType:1 userType:_userType];
        _usedVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _usedVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_usedVC];
    }
    return _usedVC;
}

- (MEMyAppointmentContentVC *)notUseVC{
    if(!_notUseVC){
        _notUseVC = [[MEMyAppointmentContentVC alloc]initWithType:2 userType:_userType];
        _notUseVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _notUseVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_notUseVC];
    }
    return _notUseVC;
}


@end
