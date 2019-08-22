//
//  MECustomerFilesInfoModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class MECustomerFollowTpyeModel;

@interface MECustomerInfoFollowModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger customer_files_id;
@property (nonatomic, strong) NSString * follow_time;
@property (nonatomic, strong) NSArray * follow_type;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * project;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, strong) NSString * updated_at;

@property (nonatomic, strong) NSArray *followList;

@end



@interface MECustomerInfoHabitSubModel : MEBaseModel

@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger idField;

@end



@interface MECustomerInfoHabitModel : MEBaseModel

@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSArray * habit_arr;
@property (nonatomic, assign) NSInteger type;

@end



@interface MECustomerFilesInfoModel : MEBaseModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * best_communication_time;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * blood_type;
@property (nonatomic, strong) NSString * classify_name;
@property (nonatomic, assign) NSInteger consumption;
@property (nonatomic, strong) NSString * consumption_habit;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger customer_classify_id;
@property (nonatomic, strong) NSArray * follow;
@property (nonatomic, strong) NSArray * habit;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * interest;
@property (nonatomic, strong) NSString * interest_object;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * job;
@property (nonatomic, strong) NSString * main_projects;
@property (nonatomic, assign) NSInteger married;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, strong) NSString * month_earning;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * objectives_and_requirements;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * qq;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) NSInteger tall;
@property (nonatomic, strong) NSString * traits_of_character;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * wechat;
@property (nonatomic, assign) CGFloat weight;

@end

NS_ASSUME_NONNULL_END
