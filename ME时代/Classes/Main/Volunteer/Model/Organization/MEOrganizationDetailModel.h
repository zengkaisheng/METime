//
//  MEOrganizationDetailModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEOrganizationDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * org_name;
@property (nonatomic, strong) NSString * org_images;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * county;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger attention_num;
@property (nonatomic, assign) NSInteger volunteer_num;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, assign) NSInteger is_attention;
@property (nonatomic, assign) NSInteger is_join;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, assign) NSInteger is_own;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, strong) NSString * status;

@end

NS_ASSUME_NONNULL_END
