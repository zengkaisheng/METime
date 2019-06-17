//
//  MEFourCouponSearchHomeVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/17.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourCouponSearchHomeVC.h"
#import "MEFourCouponSearchBaseVC.h"

@interface MEFourCouponSearchHomeVC ()<UITextFieldDelegate,JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray *arrType;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) MEFourCouponSearchBaseVC *TBVC;
@property (nonatomic, strong) MEFourCouponSearchBaseVC *PDDVC;
@property (nonatomic, strong) MEFourCouponSearchBaseVC *JDVC;

@end

@implementation MEFourCouponSearchHomeVC

- (instancetype)initWithIndex:(NSInteger)index{
    if (self = [super init]) {
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"inc-xz"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.titleView = self.searchTF;
//    [self.navigationController.navigationBar addSubview:self.searchTF];
    
    //right
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.arrType = @[@"淘宝",@"拼多多",@"京东"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.TBVC.view];
    [self.scrollView addSubview:self.PDDVC.view];
    [self.scrollView addSubview:self.JDVC.view];
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 35 *kMeFrameScaleX();
    lineView.indicatorLineViewColor = kMEPink;//[UIColor colorWithHexString:@"333333"];
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"333333"];
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = self.index;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        [self.rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kME333333 forState:UIControlStateNormal];
    }else {
        [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kMEPink forState:UIControlStateNormal];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        [self.rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kME333333 forState:UIControlStateNormal];
    }else {
        [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kMEPink forState:UIControlStateNormal];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        [self.rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kME333333 forState:UIControlStateNormal];
    }else {
        [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kMEPink forState:UIControlStateNormal];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:kMEPink forState:UIControlStateNormal];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([str length] > 0) {
        switch (self.categoryView.selectedIndex) {
            case 0:
                [self.TBVC searchCouponDataWithQueryStr:str];
                break;
            case 1:
                [self.PDDVC searchCouponDataWithQueryStr:str];
                break;
            case 2:
                [self.JDVC searchCouponDataWithQueryStr:str];
                break;
            default:
                break;
        }
    }
    return YES;
}

- (void)leftBarButtonClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick {
    if ([self.rightBtn.titleLabel.text isEqualToString:@"搜索"]) {
        [self.searchTF resignFirstResponder];
        NSString *str = [self.searchTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        switch (self.categoryView.selectedIndex) {
            case 0:
                [self.TBVC searchCouponDataWithQueryStr:str];
                break;
            case 1:
                [self.PDDVC searchCouponDataWithQueryStr:str];
                break;
            case 2:
                [self.JDVC searchCouponDataWithQueryStr:str];
                break;
            default:
                break;
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Getting And Setting
- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(43, 4, SCREEN_WIDTH - 43 - 53, 36)];
        _searchTF.placeholder = @"搜索商品";
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.backgroundColor = kMEeeeeee;
        _searchTF.layer.cornerRadius = 18;
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 36)];
        leftV.backgroundColor = kMEeeeeee;
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_nav_btn_search"]];
        imgV.frame = CGRectMake(18, 9, 18, 18);
        [leftV addSubview:imgV];
        _searchTF.leftView = leftV;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_rightBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kMEPink forState:UIControlStateNormal];
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _rightBtn;
}

- (MEFourCouponSearchBaseVC *)TBVC {
    if (!_TBVC) {
        _TBVC = [[MEFourCouponSearchBaseVC alloc] initWithType:0];
        _TBVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _TBVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_TBVC];
    }
    return _TBVC;
}

- (MEFourCouponSearchBaseVC *)PDDVC {
    if (!_PDDVC) {
        _PDDVC = [[MEFourCouponSearchBaseVC alloc] initWithType:1];
        _PDDVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _PDDVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_PDDVC];
    }
    return _PDDVC;
}

- (MEFourCouponSearchBaseVC *)JDVC {
    if (!_JDVC) {
        _JDVC = [[MEFourCouponSearchBaseVC alloc] initWithType:2];
        _JDVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _JDVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_JDVC];
    }
    return _JDVC;
}

@end
