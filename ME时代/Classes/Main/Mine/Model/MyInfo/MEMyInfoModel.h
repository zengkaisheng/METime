//
//  MEMyInfoModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEMyInfoModel : MEBaseModel

@property (nonatomic, strong) NSString * area;
@property (nonatomic, assign) NSInteger attention_num;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * id_image_back;
@property (nonatomic, strong) NSString * id_image_front;
@property (nonatomic, strong) NSString * id_number;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, assign) NSInteger praise_num;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
