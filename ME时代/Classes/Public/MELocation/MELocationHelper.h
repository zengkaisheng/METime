//
//  MELocationHelper.h
//  ME时代
//
//  Created by hank on 2018/11/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class MELocationCLLModel;
//定位block块
typedef void(^ResultLocationInfoBlock)(CLLocation *location, CLPlacemark *placeMark, NSString *error);
//定位block块(仅获取经纬度坐标)
typedef void(^ResultLocationBlock)(CLLocation *location);

@interface MELocationHelper : NSObject


+ (instancetype)sharedHander;
/**
 *  直接通过代码块获取用户位置信息
 *
 *  @param block 定位block代码块
 */
-(void)getCurrentLocation:(ResultLocationInfoBlock)block failure:(kMeBasicBlock)failuer;
- (MELocationCLLModel *)getLocationModel;

@end
