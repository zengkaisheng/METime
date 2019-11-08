//
//  MEAttentionOrganizationsModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAttentionOrganizationsModel : MEBaseModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger attention_num;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * county;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, strong) NSString * e_mail;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * id_number;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * la;
@property (nonatomic, strong) NSString * lg;
@property (nonatomic, strong) NSString * link_name;
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, strong) NSString * org_name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * volunteer_num;

@end

NS_ASSUME_NONNULL_END
