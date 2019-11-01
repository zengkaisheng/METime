//
//  MEAppointmentObjectModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAppointmentObjectModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * object_name;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
