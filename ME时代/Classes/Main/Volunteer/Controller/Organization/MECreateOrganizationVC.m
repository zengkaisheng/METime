//
//  MECreateOrganizationVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECreateOrganizationVC.h"
#import "MEApplyOrganizationInfoVC.h"

#import <CoreLocation/CoreLocation.h>
@interface MECreateOrganizationVC ()<CLLocationManagerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UIButton *applyBtn;

@property (nonatomic, strong) CLLocationManager *locationManager;  //定位管理器
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@end

@implementation MECreateOrganizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"组织入驻";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"organization_welcome"]];
    CGFloat scale = SCREEN_WIDTH/500;
    self.imgV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 922*scale);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-28-63-10)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.imgV.frame.size.height);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imgV];
    
    [self.view addSubview:self.applyBtn];
    
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager startUpdatingLocation];
        [MECommonTool showMessage:@"获取定位中..." view:kMeCurrentWindow];
    }
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
    [_locationManager stopUpdatingLocation];
}

#pragma mark -- Aaction
- (void)applyBtnAction {
    MEApplyOrganizationInfoVC *vc = [[MEApplyOrganizationInfoVC alloc] initWithLatitude:kMeUnNilStr(self.latitude) longitude:kMeUnNilStr(self.longitude)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- setter && getter
- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT-28-63, SCREEN_WIDTH-50, 63)];
        _applyBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [_applyBtn setTitle:@"申请入会" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _applyBtn.layer.cornerRadius = 14;
        
        [_applyBtn addTarget:self action:@selector(applyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

@end
