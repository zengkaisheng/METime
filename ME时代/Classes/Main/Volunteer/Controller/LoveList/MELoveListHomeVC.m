//
//  MELoveListHomeVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MELoveListHomeVC.h"
#import "MELoveListContentVC.h"

@interface MELoveListHomeVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>{
    NSArray *_arrType;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MELoveListContentVC *monthVC;
@property (nonatomic, strong) MELoveListContentVC *yearVC;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MELoveListHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"爱心榜";
    self.type = 2;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    
    _arrType = @[@"月榜",@"年榜"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.monthVC.view];
    [self.scrollView addSubview:self.yearVC.view];
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = kMEPink;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
}

#pragma mark -- Action
- (void)changeTypeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.type = 1;
    }else {
        self.type = 2;
    }
//    NSLog(@"type:%@",@(self.type));
    [self.monthVC reloadDatasWithType:self.type];
    [self.yearVC reloadDatasWithType:self.type];
}

#pragma mark - Setter And Getter
- (MELoveListContentVC *)monthVC {
    if (!_monthVC) {
        _monthVC = [[MELoveListContentVC alloc] initWithType:self.type dateType:@"month"];
        _monthVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _monthVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_monthVC];
    }
    return _monthVC;
}

- (MELoveListContentVC *)yearVC {
    if (!_yearVC) {
        _yearVC = [[MELoveListContentVC alloc] initWithType:self.type dateType:@"year"];
        _yearVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _yearVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_yearVC];
    }
    return _yearVC;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 60, 30);
        
        NSString *string = @"个人/组织";
        NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
        //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
        NSRange range = [string rangeOfString:@"/"];
        NSRange fontRange = NSMakeRange(0, range.location);
        NSRange centerRange = NSMakeRange(range.location, 1);
        NSRange backRange = NSMakeRange(range.location+1, string.length-range.location-1);
        //赋值
        NSMutableDictionary *norDic = [NSMutableDictionary dictionary];
        norDic[NSFontAttributeName] = [UIFont systemFontOfSize:11];
        norDic[NSForegroundColorAttributeName] = kME333333;
        
        NSMutableDictionary *selDic = [NSMutableDictionary dictionary];
        selDic[NSFontAttributeName] = [UIFont systemFontOfSize:11];
        selDic[NSForegroundColorAttributeName] = kMEPink;
        
        [attribut addAttributes:norDic range:fontRange];
        [attribut addAttributes:norDic range:centerRange];
        [attribut addAttributes:selDic range:backRange];
        
        NSMutableAttributedString *selectedAttribut = [[NSMutableAttributedString alloc]initWithString:string];
        [selectedAttribut addAttributes:selDic range:fontRange];
        [selectedAttribut addAttributes:norDic range:centerRange];
        [selectedAttribut addAttributes:norDic range:backRange];
        
        [_btnRight setAttributedTitle:attribut forState:UIControlStateNormal];
        [_btnRight setAttributedTitle:selectedAttribut forState:UIControlStateSelected];
        [_btnRight.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_btnRight addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
