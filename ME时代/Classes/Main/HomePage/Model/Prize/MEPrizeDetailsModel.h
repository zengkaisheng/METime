//
//  MEPrizeDetailsModel.h
//  志愿星
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEPrizeLogModel : MEBaseModel

@property (nonatomic, assign) NSInteger activity_id;
@property (nonatomic, assign) NSInteger from_member_id;
@property (nonatomic, strong) NSString *header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_lucky;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, assign) NSInteger is_friend;
@property (nonatomic, assign) NSInteger oneself;

@end

@interface MEPrizeDetailsModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSArray *inviteLog;
@property (nonatomic, assign) NSInteger inviteNum;
@property (nonatomic, assign) NSInteger is_join;
@property (nonatomic, assign) NSInteger join_number;
@property (nonatomic, assign) NSInteger join_type;
@property (nonatomic, strong) NSArray *lucky;
@property (nonatomic, strong) NSString *open_time;
@property (nonatomic, strong) NSArray *prizeLog;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger wholucky;
@property (nonatomic, strong) NSString *rule;

@end

NS_ASSUME_NONNULL_END
