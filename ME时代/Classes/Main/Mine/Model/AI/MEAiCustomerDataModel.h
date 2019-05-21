//
//  MEAiCustomerDataModel.h
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAiCustomerDataModel : MEBaseModel

@property (nonatomic, strong) NSString * age;
@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * company;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * professional;
//1 男 2 女 3 0 保密
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString *sexStr;
@property (nonatomic, strong) NSString * wechat_name;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * uid;
@end

NS_ASSUME_NONNULL_END
