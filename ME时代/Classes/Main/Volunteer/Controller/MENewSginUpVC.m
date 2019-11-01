//
//  MENewSginUpVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewSginUpVC.h"
#import "MESginUpProtocolView.h"
#import "MEInputSginUpCodeVC.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MENewSginUpVC ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;  //定位管理器
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MENewSginUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签到";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager startUpdatingLocation];
        [MECommonTool showMessage:@"定位中..." view:kMeCurrentWindow];
    }
    [self.view addSubview:self.mapView];
    
    [MESginUpProtocolView showSginUpProtocolViewWithTitle:@"志愿服务签到" content:@"      我承诺在参与志愿服务过程中，诚心志愿，诚信志愿，诚实志愿，坚决拒绝任何伪造志愿服务时长等弄虚作假的失信行为。同时，我同意公开我的志愿服务时长和服务记录等信息，以配合广大志愿者和志愿汇对诚信志愿的监督与核查。" confirmBlock:^{
        MEInputSginUpCodeVC *vc = [[MEInputSginUpCodeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } superView:self.view];
}

#pragma mark -- Action
- (void)loactionAction {
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.021252, 0.014720);
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
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
    NSLog(@"%f%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    self.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    /*地理反编码 -- 可以根据地理位置（经纬度）确认位置信息 （街道、门牌）*/
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark * placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            if (!currentCity) {
 //                currentCity = @"无法定位当前城市";
                currentCity = placeMark.administrativeArea;
            }
            /*看需求定义一个全局变量来接受赋值*/
            NSLog(@"当前国家:%@",placeMark.country);/*当前国家*/
            NSLog(@"当前城市:%@",currentCity);/*当前城市*/
            NSLog(@"当前位置:%@",placeMark.subLocality);/*当前位置*/
            NSLog(@"当前街道:%@",placeMark.thoroughfare);/*当前街道*/
            NSLog(@"具体地址:%@",placeMark.name);/*具体地址 ** 市 ** 区** 街道*/
            NSLog(@"具体行政区:%@",placeMark.areasOfInterest);
        }
        else if (error == nil&&placemarks.count == 0){
            NSLog(@"没有地址返回");
        }
        else if (error){
            NSLog(@"location error:%@",error);
        }
    }];
    
    //需要将地图的显示区域变小
    MKCoordinateSpan span = MKCoordinateSpanMake(0.021252, 0.014720);
    [self.mapView setRegion:MKCoordinateRegionMake(currentLocation.coordinate, span) animated:YES];

    [_locationManager stopUpdatingLocation];
}

#pragma mark --
- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.activityType = CLActivityTypeFitness;   ///<步行导航
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
        _mapView.delegate = self;
        //设置地图类型
        _mapView.mapType = MKMapTypeStandard;   //平面地图
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 30, 25);
        _btnRight.contentMode = UIViewContentModeRight;
        [_btnRight setImage:[UIImage imageNamed:@"icon_sginUp_location"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(loactionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
