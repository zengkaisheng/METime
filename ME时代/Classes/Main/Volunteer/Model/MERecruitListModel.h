//
//  MERecruitListModel.h
//  ME时代
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MERecruitListModel : MEBaseModel

@property (nonatomic, strong) NSString * area;           //区/县
@property (nonatomic, strong) NSString * city;           //市
@property (nonatomic, strong) NSString * classify_id;    //服务类型ID
@property (nonatomic, strong) NSString * distance;       //距离
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * image;          //
@property (nonatomic, assign) NSInteger join_num;
@property (nonatomic, strong) NSString * latitude;       //纬度
@property (nonatomic, strong) NSString * longitude;      //经度
@property (nonatomic, assign) NSInteger need_num;
@property (nonatomic, strong) NSString * province;       //省
@property (nonatomic, strong) NSString * title;

@end

NS_ASSUME_NONNULL_END
