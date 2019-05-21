//
//  MEStoreDetailModel.h
//  ME时代
//
//  Created by hank on 2018/10/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@class MEStoreModel;
@interface MEStoreDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * auth_at;
@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * errot_desc;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, assign) NSInteger is_money;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * mask_img;
@property (nonatomic, strong) NSString * mask_info_img;
@property (nonatomic, strong) NSString * md5_extend;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * mini_app_id;
@property (nonatomic, strong) NSString * mini_app_secret;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, assign) NSInteger parent_id_first;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * qq;
@property (nonatomic, assign) NSInteger stars;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * store_name;
@property (nonatomic, strong) NSString * true_name;
@property (nonatomic, strong) NSString * updated_at;

+ (MEStoreDetailModel *)modelWithStoreModel:(MEStoreModel *)model;
@end
