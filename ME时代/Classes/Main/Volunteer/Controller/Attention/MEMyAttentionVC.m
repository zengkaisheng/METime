//
//  MEMyAttentionVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyAttentionVC.h"
#import "MEMyAttentionContentVC.h"

#import <CoreLocation/CoreLocation.h>

@interface MEMyAttentionVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>{
    NSArray *_arrType;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEMyAttentionContentVC *organizationVC;
@property (nonatomic, strong) MEMyAttentionContentVC *volunteerVC;
@property (nonatomic, strong) MEMyAttentionContentVC *activityVC;

@property (nonatomic, strong) CLLocationManager *locationManager;  //定位管理器
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, assign) BOOL isSetup;;

@end

@implementation MEMyAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    
    self.isSetup = NO;
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager startUpdatingLocation];
        [MECommonTool showMessage:@"获取定位中..." view:kMeCurrentWindow];
    }
    
     _arrType = @[@"公益组织",@"志愿者",@"招募活动"];
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count,  SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kCategoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.organizationVC.view];
    [self.scrollView addSubview:self.volunteerVC.view];
    [self.scrollView addSubview:self.activityVC.view];
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor colorWithHexString:@"#2ED9A4"];
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#2ED9A4"];
    self.categoryView.contentScrollView = self.scrollView;
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
}

#pragma mark -- CLLocationManagerDelegate
/*定位失败则执行此代理方法*/
/*定位失败弹出提示窗，点击打开定位按钮 按钮，会打开系统设置，提示打开定位服务*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    /*设置提示提示用户打开定位服务*/
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok =[UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /*打开定位设置*/
        NSURL * settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingsURL];
    }];
    UIAlertAction * cacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ok];
    [alert addAction:cacel];
    [self presentViewController:alert animated:YES completion:nil];
}
/*定位成功后则执行此代理方法*/
#pragma mark 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    /*旧值*/
    CLLocation * currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    /*打印当前经纬度*/
    NSLog(@"latitude:%f====longitude:%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    self.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    if (!self.isSetup) {
        [self setupUI];
        self.isSetup = YES;
    }
    
    [_locationManager stopUpdatingLocation];
}

#pragma mark - Setter And Getter
- (MEMyAttentionContentVC *)organizationVC{
    if(!_organizationVC){
        _organizationVC = [[MEMyAttentionContentVC alloc] initWithType:3 latitude:kMeUnNilStr(self.latitude) longitude:kMeUnNilStr(self.longitude)];
        _organizationVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _organizationVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        [self addChildViewController:_organizationVC];
    }
    return _organizationVC;
}

- (MEMyAttentionContentVC *)volunteerVC{
    if(!_volunteerVC){
        _volunteerVC = [[MEMyAttentionContentVC alloc] initWithType:2 latitude:kMeUnNilStr(self.latitude) longitude:kMeUnNilStr(self.longitude)];
        _volunteerVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _volunteerVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_volunteerVC];
    }
    return _volunteerVC;
}

- (MEMyAttentionContentVC *)activityVC{
    if(!_activityVC){
        _activityVC = [[MEMyAttentionContentVC alloc] initWithType:1 latitude:kMeUnNilStr(self.latitude) longitude:kMeUnNilStr(self.longitude)];
        _activityVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight);
        _activityVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addChildViewController:_activityVC];
    }
    return _activityVC;
}

@end
