//
//  MERegisterVolunteerModel.h
//  志愿星
//
//  Created by gao lei on 2019/10/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MERegisterVolunteerModel : MEBaseModel

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * id_number;
@property (nonatomic, strong) NSString * id_image_front;
@property (nonatomic, strong) NSString * id_image_back;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * area;

@end

NS_ASSUME_NONNULL_END
