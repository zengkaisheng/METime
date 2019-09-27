//
//  MEMyCourseVIPModel.h
//  ME时代
//
//  Created by gao lei on 2019/9/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MEMyCourseVIPDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * courses_vip_rule;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * expire_time;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_vip;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSString * old_price;
@property (nonatomic, strong) NSString * over_time;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * vip_rule;
@property (nonatomic, assign) NSInteger vip_type; //1、C端 2、B端

@end



@interface MEMyCourseVIPSubModel : MEBaseModel

@property (nonatomic, strong) NSArray * vip;
@property (nonatomic, strong) NSString * vip_rule;

@property (nonatomic, assign) CGFloat ruleHeight;

@end



@interface MEMyCourseVIPModel : MEBaseModel

@property (nonatomic, strong) MEMyCourseVIPSubModel * B_vip;
@property (nonatomic, strong) MEMyCourseVIPSubModel * C_vip;

@end

NS_ASSUME_NONNULL_END
