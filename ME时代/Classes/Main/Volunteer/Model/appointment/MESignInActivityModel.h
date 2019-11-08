//
//  MESignInActivityModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MESignInActivityModel : MEBaseModel

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * signin_code;
@property (nonatomic, strong) NSString * activity_start_time;
@property (nonatomic, strong) NSString * activity_end_time;
@property (nonatomic, strong) NSString * start_time;
@property (nonatomic, strong) NSString * end_time;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * status_name;

@end

NS_ASSUME_NONNULL_END
