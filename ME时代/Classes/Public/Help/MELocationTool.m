//
//  MELocationTool.m
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MELocationTool.h"
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import "MELocationCLLModel.h"
//#import "MELocationConverter.h"
//
//@interface MELocationTool()<CLLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate>
//{
//    BMKMapManager *_mapManager;
//    BMKGeoCodeSearch* _geocodesearch;
//    BMKLocationService* _locService;
//    kMeObjBlock _blockSuccess;
//    kMeObjBlock _blockFailure;
//    BMKAddressComponent *_location;
//    MELocationCLLModel *_lllModel;
//}
//@end


@implementation MELocationTool

+ (instancetype)sharedHander{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = self.new;
    });
    return instance;
}

//-(id)init{
//    self = [super init];
//    if (self != nil) {
//        _mapManager = [[BMKMapManager alloc]init];
//        BOOL ret = [_mapManager start:BAIDUAK generalDelegate:self];
//        if(!ret){
//            NSLog(@"_mapManager start Failure");
//        }
//        _locService = [[BMKLocationService alloc]init];
//        _locService.delegate = self;
//        _lllModel = [MELocationCLLModel new];
//    }
//    return self;
//}
//
//- (void)startLocation{
//    [_locService startUserLocationService];
//}
//
//- (void)stopLocation{
//    [_locService stopUserLocationService];
//}
//
//#pragma BMKGeoCodeSearchDelegate
//
//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
//    if (error == 0) {
//        BMKAddressComponent *address = result.addressDetail;
//
//        //百度转wgs84
////        CLLocationCoordinate2D wgs =  [MELocationConverter bd09ToGcj02:result.location];
//        _lllModel.lat = result.location.latitude;
//        _lllModel.lng = result.location.longitude;
//
//
//        NSString *city;
//        if (address && address.city) {
//            city =  [NSString stringWithFormat:@"%@",kMeUnNilStr(address.city)];
//        }else{
//            city = @"定位失败";
//            _lllModel.lng = 0;
//            _lllModel.lat = 0;
//        }
//        _lllModel.city = city;
//
//        NSLog(@"我的位置在 %@",address.city);
//        [self setCallbackFromLocation:address];
//    }else{
//        _lllModel.lng = 0;
//        _lllModel.lat = 0;
//        _lllModel.city = @"定位失败";
//        kMeCallBlock(_blockFailure,nil);
//    }
//}
//
//- (void)setCallbackFromLocation:(BMKAddressComponent *)location{
//    if (kMeUnNilStr(location.city) && ![@"" isEqualToString:kMeUnNilStr(location.city)]) {
//        _location = location;
//        kMeCallBlock(_blockSuccess,location);
//    }else{
//        kMeCallBlock(_blockFailure,location);
//    }
//}
//
//#pragma BMKLocationServiceDelegate
//
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    [self stopLocation];
//    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
//    reverseGeocodeSearchOption.location = userLocation.location.coordinate;
//    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//    _geocodesearch.delegate = self;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//    if(flag){
//        NSLog(@"reverseGeoCode sucess");
//    }else{
//        NSLog(@"reverseGeoCode failure");
//    }
//}
//
//- (void)didFailToLocateUserWithError:(NSError *)error{
//    NSLog(@"location error");
//    [self stopLocation];
//    NSString *str =  [NSString stringWithFormat:@"请在系统设置开启定位服务\n(设置 > 隐私 > 定位服务 > 开启%@)",kMeUnNilStr(kMEAppName)];
//    kMeAlter(@"提示", str);
//    _lllModel.lng = 0;
//    _lllModel.lat = 0;
//    _lllModel.city = @"定位失败";
//    kMeCallBlock(_blockFailure,nil);
//}
//
//#pragma mark - GET and SET
//
//- (BMKAddressComponent *)getLocation{
//    return _location;
//}
//
//- (MELocationCLLModel *)getLocationModel{
//    return _lllModel;
//}
//
//- (void)getGeocoderSuccess:(kMeObjBlock)success failure:(kMeObjBlock)failure{
//    _blockSuccess = success;
//    _blockFailure = failure;
//}
//
//+ (NSString *)setInfoWithLocation:(BMKAddressComponent *)location {
//    if (location && location.province && location.city) {
//        return  [NSString stringWithFormat:@"%@",kMeUnNilStr(location.city)];
//    }else{
//        return @"定位失败";
//    }
//    return @"定位失败";
//}

@end
