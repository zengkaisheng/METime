//
//  MEJoinOrganizationModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEJoinOrganizationModel : MEBaseModel

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * county;
@property (nonatomic, strong) NSString * services_type;
@property (nonatomic, strong) NSString * attention_num;
@property (nonatomic, strong) NSString * volunteer_num;

@end

NS_ASSUME_NONNULL_END
