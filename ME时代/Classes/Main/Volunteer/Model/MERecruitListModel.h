//
//  MERecruitListModel.h
//  志愿星
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


@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, assign) NSInteger attention_num;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * start_date;
@property (nonatomic, strong) NSString * end_date;
@property (nonatomic, strong) NSString * join_start_date;
@property (nonatomic, strong) NSString * join_end_date;
@property (nonatomic, strong) NSString * organizers;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
