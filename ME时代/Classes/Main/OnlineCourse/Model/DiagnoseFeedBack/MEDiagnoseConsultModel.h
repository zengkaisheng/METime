//
//  MEDiagnoseConsultModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEDiagnoseConsultModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * problem;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSString * answer;
@property (nonatomic, strong) NSArray * answer_images;
@property (nonatomic, assign) NSInteger is_reply;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, strong) NSString * to_member_id;
@property (nonatomic, strong) NSString * to_admin_id;
@property (nonatomic, strong) NSString * reply_time;
@property (nonatomic, assign) NSInteger is_look;
@property (nonatomic, assign) NSInteger is_help;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * user_type_name;

@end

NS_ASSUME_NONNULL_END
