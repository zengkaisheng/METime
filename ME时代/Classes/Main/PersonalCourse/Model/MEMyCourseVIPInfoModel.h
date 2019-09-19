//
//  MEMyCourseVIPInfoModel.h
//  ME时代
//
//  Created by gao lei on 2019/9/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEMyCourseVIPInfoModel : MEBaseModel

@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * expire_time;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_buy;   //是否购买过 1是 2否
@property (nonatomic, assign) NSInteger is_vip;   //是否VIP 1是 2否
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * over_time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * vip_desc;
@property (nonatomic, assign) NSInteger vip_id;
@property (nonatomic, strong) NSString * vip_price;
@property (nonatomic, strong) NSString * vip_rule;
@property (nonatomic, strong) NSString * vip_title;
//交易记录相关
@property (nonatomic, strong) NSString * effective_time;
@property (nonatomic, strong) NSString * payment_name;
@property (nonatomic, strong) NSString * pay_time;
@property (nonatomic, strong) NSString * vipName;

@property (nonatomic, assign) CGFloat ruleHeight;

@end

NS_ASSUME_NONNULL_END
