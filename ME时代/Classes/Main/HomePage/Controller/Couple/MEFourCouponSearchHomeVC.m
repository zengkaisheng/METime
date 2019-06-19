//
//  MEFourCouponSearchHomeVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/17.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourCouponSearchHomeVC.h"
#import "MEFourCouponSearchBaseVC.h"
#import "MEFourSearchCouponNavView.h"

@interface MEFourCouponSearchHomeVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray *arrType;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *keywordsView;

@property (nonatomic, strong) MEFourSearchCouponNavView *navView;

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

    self.navBarHidden = YES;
    [self.view addSubview:self.navView];
    
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
    
    if ([self.keyWords length] > 0) {
        self.navView.searchTF.enabled = NO;
        [self.navView addSubview:self.keywordsView];
        switch (self.index) {
            case 0:
                [self.TBVC searchCouponDataWithQueryStr:self.keyWords];
                break;
            case 1:
                [self.PDDVC searchCouponDataWithQueryStr:self.keyWords];
                break;
            case 2:
                [self.JDVC searchCouponDataWithQueryStr:self.keyWords];
                break;
            default:
                break;
        }
    }
}

- (void)cancelBtnAction {
    [self.keywordsView removeFromSuperview];
    self.keywordsView = nil;
    self.navView.searchTF.enabled = YES;
}

#pragma mark - Getting And Setting
- (MEFourSearchCouponNavView *)navView{
    if(!_navView){
        _navView = [[MEFourSearchCouponNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeNavBarHeight)];
        kMeWEAKSELF
        _navView.searchBlock = ^(NSString *str) {
            kMeSTRONGSELF
            if ([str length] > 0) {
                switch (strongSelf.categoryView.selectedIndex) {
                    case 0:
                        [strongSelf.TBVC searchCouponDataWithQueryStr:str];
                        break;
                    case 1:
                        [strongSelf.PDDVC searchCouponDataWithQueryStr:str];
                        break;
                    case 2:
                        [strongSelf.JDVC searchCouponDataWithQueryStr:str];
                        break;
                    default:
                        break;
                }
            }
        };
        _navView.backBlock = ^{
           kMeSTRONGSELF
            [strongSelf.view endEditing:YES];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navView;
}

- (UIView *)keywordsView {
    if (!_keywordsView) {
        CGFloat width = [self.keyWords boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
        width = width+34>self.navView.searchTF.width-44-28?self.navView.searchTF.width-44-28:width+34;
        _keywordsView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.navView.searchTF.frame) + 44, CGRectGetMinY(self.navView.searchTF.frame)+4, width, 28)];
        _keywordsView.backgroundColor = [UIColor whiteColor];
        _keywordsView.layer.cornerRadius = 14;
        
        UILabel *keywordLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, width-34, 14)];
        keywordLbl.text = self.keyWords;
        keywordLbl.textColor = kME666666;
        keywordLbl.font = [UIFont systemFontOfSize:14];
        keywordLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [_keywordsView addSubview:keywordLbl];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:[UIImage imageNamed:@"stortdel"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.frame = CGRectMake(width - 24, 4, 20, 20);
        [_keywordsView addSubview:cancelBtn];
    }
    return _keywordsView;
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
