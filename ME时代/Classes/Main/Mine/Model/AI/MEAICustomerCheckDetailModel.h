//
//  MEAICustomerCheckDetailModel.h
//  志愿星
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAICustomerCheckDetailModel : MEBaseModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger count_type;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * share_store;

@end

NS_ASSUME_NONNULL_END
