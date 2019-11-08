//
//  MEApplyOrganizationModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEApplyOrganizationModel : MEBaseModel

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * org_name;
@property (nonatomic, strong) NSString * org_images;
@property (nonatomic, strong) NSString * link_name;
@property (nonatomic, strong) NSString * id_number;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * e_mail;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * county;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * lg;
@property (nonatomic, strong) NSString * la;
@property (nonatomic, strong) NSString * org_remark;
@property (nonatomic, strong) NSString * apply_reason;
@property (nonatomic, strong) NSString * org_img;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, strong) NSString * services_type;

@end

NS_ASSUME_NONNULL_END
