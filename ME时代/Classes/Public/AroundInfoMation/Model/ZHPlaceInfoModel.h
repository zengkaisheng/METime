//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02
//
//  Created by aimoke on 16/11/10.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZHPlaceInfoModel : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *detailsAddress;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thoroughfare;
@property (nonatomic, strong) NSString *subThoroughfare;
@property (nonatomic, strong) NSString *city;
@property (nonatomic) CLLocationCoordinate2D coordinate;


@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *district;
@end
