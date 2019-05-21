//
//  MELocationHelper.m
//  ME时代
//
//  Created by hank on 2018/11/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MELocationHelper.h"
#import "MELocationCLLModel.h"

#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

@interface MELocationHelper ()<CLLocationManagerDelegate>{
    MELocationCLLModel *_lllModel;
}
@property (nonatomic, copy) kMeBasicBlock failuerBlock;
/** 定位block对象 */
@property (nonatomic, copy) ResultLocationInfoBlock locationBlock;

/** 定位block对象 */
@property (nonatomic, copy) ResultLocationBlock locationOnlyBlock;

/** 定位管理者 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/** 逆地理编码管理者 */
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation MELocationHelper

+ (instancetype)sharedHander{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = self.new;
    });
    return instance;
}

-(id)init{
    self = [super init];
    if (self != nil) {
        _lllModel = [MELocationCLLModel new];
    }
    return self;
}

-(void)getCurrentLocation:(ResultLocationInfoBlock)block failure:(kMeBasicBlock)failuer{
    self.failuerBlock = failuer;
    //记录代码块
    self.locationBlock = block;
    //定位更新频率->
    [self.locationManager setDistanceFilter:100];
    //判断当前定位权限->进而开始定位
    [self startLocation];
}

//定位
-(void)startLocation{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        _lllModel.lng = 0;
        _lllModel.lat = 0;
        _lllModel.city = @"未知";
        kMeCallBlock(_failuerBlock);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str =  [NSString stringWithFormat:@"请在系统设置开启定位服务\n(设置 > 隐私 > 定位服务 > 开启%@)",kMeUnNilStr(kMEAppName)];
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"提示" message:str];
            kMeWEAKSELF
            [aler addButtonWithTitle:@"去开启" block:^{
                kMeSTRONGSELF
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL: url];
                }
                [strongSelf->_locationManager startUpdatingLocation];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
        });
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways ){
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }else{
        _lllModel.lng = 0;
        _lllModel.lat = 0;
        _lllModel.city = @"未知";
        kMeCallBlock(_failuerBlock);
        // 跳转核心代码
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *str =  [NSString stringWithFormat:@"请在系统设置开启定位服务\n(设置 > 隐私 > 定位服务 > 开启%@)",kMeUnNilStr(kMEAppName)];
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"提示" message:str];
            kMeWEAKSELF
            [aler addButtonWithTitle:@"去开启" block:^{
                kMeSTRONGSELF
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL: url];
                }
                [strongSelf->_locationManager startUpdatingLocation];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
        });
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    //表示水平准确度，这么理解，它是以coordinate为圆心的半径，返回的值越小，证明准确度越好，如果是负数，则表示corelocation定位失败。
    if (location.horizontalAccuracy < 0) {
        _lllModel.lng = 0;
        _lllModel.lat = 0;
        _lllModel.city = @"未知";
        kMeCallBlock(_failuerBlock);
        NSLog(@"location.horizontalAccuracy:%f,定位失败!!!!",location.horizontalAccuracy);
        return;
    }else{
        //直接传入坐标
        //        self.locationOnlyBlock(location);
        // 在这里, 还没获取地理位置, 获取到地标对象, 所以, 在此处, 要进一步进行反地理编码
        kMeWEAKSELF
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            kMeSTRONGSELF
            if (error == nil) {
                // 获取地标对象
                CLPlacemark *placemark = [placemarks firstObject];
                // 在此处, 最适合, 执行存储的代码块
                kMeCallBlock(strongSelf->_locationBlock,location,placemark,nil);
//                self.locationBlock(location, placemark, nil);
                strongSelf->_lllModel.lng = location.coordinate.longitude;
                strongSelf->_lllModel.lat = location.coordinate.latitude;
                strongSelf->_lllModel.city = placemark.locality;
                
            }else{
                kMeCallBlock(strongSelf->_locationBlock,location, nil, error.localizedDescription);
//                self.locationBlock(location, nil, error.localizedDescription);
                strongSelf->_lllModel.lng = location.coordinate.longitude;
                strongSelf->_lllModel.lat = location.coordinate.latitude;
                strongSelf->_lllModel.city = @"未知";
            }
        }];
    }
    //停止定位->
    [_locationManager stopUpdatingLocation];
}

#pragma mark - SetAndGet

-(CLLocationManager *)locationManager{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        if (isIOS(8)) {
            //在此处请求授权
            //1.获取项目配置->plist文件
            NSDictionary *infoPlistDict = [[NSBundle mainBundle] infoDictionary];
            //2.获取当前项目中的定位权限设置
            NSString *always = [infoPlistDict objectForKey:@"NSLocationAlwaysUsageDescription"];
            NSString *whenInUse = [infoPlistDict objectForKey:@"NSLocationWhenInUseUsageDescription"];
            //如果开发者设置后台定位模式->
            if (always.length > 0) {
                [_locationManager requestAlwaysAuthorization];
            }else if (whenInUse.length > 0){
                [_locationManager requestWhenInUseAuthorization];
                // 在前台定位授权状态下, 必须勾选后台模式location udpates才能获取用户位置信息
                NSArray *services = [infoPlistDict objectForKey:@"UIBackgroundModes"];
                if (![services containsObject:@"location"]) {
                    NSLog(@"友情提示: 当前状态是前台定位授权状态, 如果想要在后台获取用户位置信息, 必须勾选后台模式 location updates");
                }else{
                    if (isIOS(9.0)) {
                        if (@available(iOS 9.0, *)) {
                            _locationManager.allowsBackgroundLocationUpdates = YES;
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }else{
                NSLog(@"错误---如果在iOS8.0之后定位, 必须在info.plist, 配置NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription");
            }
        }
    }
    return _locationManager;
}
-(CLGeocoder *)geocoder{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (MELocationCLLModel *)getLocationModel{
    return _lllModel;
}

@end
