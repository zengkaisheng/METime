//
//  MELocationTool.h
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//  百度地位 已弃

#import <Foundation/Foundation.h>

@class MELocationCLLModel;
//@class BMKAddressComponent;
#define kLocationUserInfo @"LocationUserInfo"

@interface MELocationTool : NSObject

+ (instancetype)sharedHander;
//开始定位
- (void)startLocation;
//停止定位
- (void)stopLocation;
//
//- (BMKAddressComponent *)getLocation;
- (MELocationCLLModel *)getLocationModel;
- (void)getGeocoderSuccess:(kMeObjBlock)success failure:(kMeObjBlock)failure;

//获取当前城市
//+ (NSString *)setInfoWithLocation:(BMKAddressComponent *)location;
@end
