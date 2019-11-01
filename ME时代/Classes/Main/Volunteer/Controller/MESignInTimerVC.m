//
//  MESignInTimerVC.m
//  ME时代
//
//  Created by gao lei on 2019/10/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESignInTimerVC.h"
#import "MESginUpActivityInfoModel.h"
#import "MESignOutVC.h"

#import <CoreLocation/CoreLocation.h>

@interface MESignInTimerVC ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timerLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *tipLbl;
@property (nonatomic, strong) MESginUpActivityInfoModel *model;
@property (nonatomic, strong) UIButton *btnRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerBgConsTop;
@property (weak, nonatomic) IBOutlet UIView *timerBGView;

@property (nonatomic, strong) CLLocationManager *locationManager;  //定位管理器

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *hourStr;
@property (nonatomic, strong) NSString *minuteStr;
@property (nonatomic, strong) NSString *secondStr;

@end

@implementation MESignInTimerVC

- (instancetype)initWithModel:(MESginUpActivityInfoModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"签到";
    
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager startUpdatingLocation];
        [MECommonTool showMessage:@"定位中..." view:kMeCurrentWindow];
    }
    
    self.timerBgConsTop.constant = kMeNavBarHeight+44;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    
    self.timerBGView.layer.borderWidth = 0.5;
    self.timerBGView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.timerBGView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    self.timerBGView.layer.shadowOffset = CGSizeMake(0,15);
    self.timerBGView.layer.shadowRadius = 8;
    self.timerBGView.layer.shadowOpacity = 1;
    self.timerBGView.layer.cornerRadius = 40;
    self.timerBGView.clipsToBounds = false;
    self.timerBGView.layer.masksToBounds = false;
    
    self.tipLbl.layer.borderWidth = 1;
    self.tipLbl.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.tipLbl.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    self.tipLbl.layer.shadowOffset = CGSizeMake(0,3);
    self.tipLbl.layer.shadowRadius = 6;
    self.tipLbl.layer.shadowOpacity = 1;
    self.tipLbl.layer.cornerRadius = 6;
    self.tipLbl.clipsToBounds = false;
    self.tipLbl.layer.masksToBounds = false;
    
    self.titleLbl.text = kMeUnNilStr(self.model.title);
    self.timeLbl.text = kMeUnNilStr(self.model.end_time);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self upSecondHandleWithStartTime:kMeUnNilStr(self.model.member_info.start_time)];
}

-(void)upSecondHandleWithStartTime:(NSString *)startTimeString{
    
    NSDate *nowDate = [NSDate date]; // 当前日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    NSDate *creat = [formatter dateFromString:startTimeString];// 将传入的字符串转化成时间
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:creat]; // 计算出相差多少秒

    NSLog(@"timeInterval:%f",timeInterval);
    if (_timer == nil) {
        __block int timeout = timeInterval; //计时时间
        
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                int days = (int)(timeout/(3600*24));
                int hours = (int)((timeout-days*24*3600)/3600);
                int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                int second = timeout-days*24*3600-hours*3600-minute*60;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (hours<10) {
                        self.hourStr = [NSString stringWithFormat:@"0%d",hours];
                    }else{
                        self.hourStr = [NSString stringWithFormat:@"%d",hours];
                    }
                    if (minute<10) {
                        self.minuteStr = [NSString stringWithFormat:@"0%d",minute];
                    }else{
                        self.minuteStr = [NSString stringWithFormat:@"%d",minute];
                    }
                    if (second<10) {
                        self.secondStr = [NSString stringWithFormat:@"0%d",second];
                    }else{
                        self.secondStr = [NSString stringWithFormat:@"%d",second];
                    }
                    self.timerLbl.text = [NSString stringWithFormat:@"%@:%@:%@",kMeUnNilStr(self.hourStr),kMeUnNilStr(self.minuteStr),kMeUnNilStr(self.secondStr)];
                });
                timeout++;
            });
            dispatch_resume(_timer);
    }
}

- (void)gotoHomeAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.tabBarController.selectedIndex = 0;
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
    self.model.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.model.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
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
    
    [_locationManager stopUpdatingLocation];
}

- (IBAction)signOutAction:(id)sender {
    [self signOutWithNetWork];
}

#pragma mark -- Networking
//签退
- (void)signOutWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool posSignOutWithSignInCode:kMeUnNilStr(self.model.signin_code) latitude:kMeUnNilStr(self.model.latitude) longitude:kMeUnNilStr(self.model.longitude) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.status_code integerValue] == 200) {
            MESignOutVC *vc = [[MESignOutVC alloc] initWithModel:strongSelf.model];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(id object) {
    }];
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 40, 40);
        _btnRight.contentMode = UIViewContentModeRight;
        [_btnRight setImage:[UIImage imageNamed:@"icon_gotoHome"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(gotoHomeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
