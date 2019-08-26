//
//  MECustomerServiceLogsModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEServiceLogsDataModel : MEBaseModel

@property (nonatomic, strong) NSString * change;
@property (nonatomic, assign) NSInteger come_in_count;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * customer_check;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger member;
@property (nonatomic, strong) NSString * member_name;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) NSInteger residue_num;
@property (nonatomic, strong) NSString * residue_time;
@property (nonatomic, assign) NSInteger service_id;
@property (nonatomic, strong) NSString * service_time;
@property (nonatomic, strong) NSString * updated_at;

@end




@interface MEServiceLogsModel : MEBaseModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray * data;
@property (nonatomic, assign) NSInteger page;

@end



@interface MECustomerServiceLogsModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger customer_files_id;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) MEServiceLogsModel * logs;
@property (nonatomic, strong) NSString * open_card_time;
@property (nonatomic, assign) NSInteger residue_num;
@property (nonatomic, strong) NSString * residue_time;
@property (nonatomic, strong) NSString * service_name;
@property (nonatomic, assign) NSInteger total_num;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
