//
//  MEBStoreMannagerModel.h
//  ME时代
//
//  Created by hank on 2019/2/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEBStoreMannagerModel : MEBaseModel

@property (nonatomic, strong) NSString * address;

@property (nonatomic, strong) NSString * auth_at;
@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * current;
@property (nonatomic, strong) NSString * id_number;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * login_name;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * on_name;
@property (nonatomic, strong) NSString * store_name;
@property (nonatomic, strong) NSString * top_name;
@property (nonatomic, strong) NSString * true_name;

@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * district;

@end

NS_ASSUME_NONNULL_END
