//
//  MEDiagnoseReportModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEDiagnoseReportModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_been;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger is_look;
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * options_json;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * reply_time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * telephone;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * to_admin_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;


@end

NS_ASSUME_NONNULL_END
