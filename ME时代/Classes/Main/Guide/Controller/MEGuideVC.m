//
//  MEGuideVC.m
//  ME时代
//
//  Created by hank on 2018/12/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGuideVC.h"
#import "METabBarVC.h"

@interface MEGuideVC ()<UIScrollViewDelegate>{
    NSArray *_arrImage;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageController;
@property (strong, nonatomic) UIButton *btnInApp;

@end

@implementation MEGuideVC

#pragma mark - LifeCycle

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0f0100"];//[UIColor colorWithRed:15 green:106 blue:180 alpha:1];
    _arrImage = @[@"guideone",@"guidetwo",@"guidethree",@"guidefour"];
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH * _arrImage.count, SCREEN_HEIGHT);
    self.pageController.numberOfPages = _arrImage.count;
    CGFloat imageW = SCREEN_WIDTH;
    CGFloat imageH = (667 * imageW)/375;
    for (NSInteger i=0; i<_arrImage.count; i++) {
        UIImageView *v = [[UIImageView alloc]init];
        [self.scrollView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(imageW);
            make.height.mas_equalTo(imageH);
            make.centerX.mas_equalTo((i * SCREEN_WIDTH));
//            make.centerY.mas_equalTo(0);
             make.top.mas_equalTo(0);
        }];
        v.image = [UIImage imageNamed:kMeUnNilStr(_arrImage[i])];
    }
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageController];
    [self.pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).offset(-20*kMeFrameScaleY());
    }];
    [self.view addSubview:self.btnInApp];
    [self.btnInApp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150*kMeFrameScaleX());
        make.height.mas_equalTo(45);
        make.centerX.equalTo(self.pageController);
        make.bottom.equalTo(self.pageController).offset(-40);
    }];
    self.btnInApp.hidden = YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    _pageController.currentPage = page;
    self.btnInApp.hidden = _pageController.currentPage!=_arrImage.count-1;
}

- (void)intoApp:(UIButton *)btn{
    [[NSUserDefaults standardUserDefaults] setObject:kMEAppVersion forKey:kMEAppVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [kMeCurrentWindow setRootViewController:[METabBarVC new]];
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.pagingEnabled=YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageController{
    if(!_pageController){
        _pageController = [[UIPageControl alloc]init];
        _pageController.currentPage = 0;
        _pageController.userInteractionEnabled=NO;
    }
    return _pageController;
}

- (UIButton *)btnInApp{
    if(!_btnInApp){
        _btnInApp = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnInApp addTarget:self action:@selector(intoApp:) forControlEvents:UIControlEventTouchUpInside];
        [_btnInApp setTitle:@"立即体验" forState:UIControlStateNormal];
        [_btnInApp setBackgroundColor:[UIColor colorWithHexString:@"f3c343"]];
        [_btnInApp setTitleColor:[UIColor colorWithHexString:@"471b06"] forState:UIControlStateNormal];
        _btnInApp.cornerRadius = 45/2;
        _btnInApp.clipsToBounds = YES;
        _btnInApp.titleLabel.font = kMeFont(17);
//        _btnInApp.borderWidth =1;
//        _btnInApp.borderColor = [UIColor whiteColor];
    }
    return _btnInApp;
}

@end
