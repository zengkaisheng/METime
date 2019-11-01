//
//  MERecruitRequestModel.h
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MERecruitRequestModel : MEBaseModel

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * latitude;       //纬度
@property (nonatomic, strong) NSString * longitude;      //经度
@property (nonatomic, strong) NSString * screen_type;    //0或不传为智能筛选，1最新发布，2距离最近
@property (nonatomic, strong) NSString * classify_id;    //服务类型ID
@property (nonatomic, strong) NSString * province;       //省（必传）
@property (nonatomic, strong) NSString * city;           //市（必传）
@property (nonatomic, strong) NSString * area;           //区/县（选传）不传或为0时，为全市

@end

NS_ASSUME_NONNULL_END
