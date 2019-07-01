//
//  MEBargainDetailModel.h
//  ME时代
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEBargainUserModel : MEBaseModel

@property (nonatomic, strong) NSString * bargin_money;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * tip;

@end


@interface MEBargainDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * amount_money;
@property (nonatomic, assign) NSInteger bargin_count;
@property (nonatomic, assign) NSInteger bargin_id;
@property (nonatomic, assign) NSInteger bargin_num;
@property (nonatomic, assign) NSInteger bargin_status;
@property (nonatomic, assign) NSInteger bargin_type;
@property (nonatomic, strong) NSArray * bargin_user;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * end_time;
@property (nonatomic, assign) NSInteger finish_bargin_num;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, assign) NSInteger over_time;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * product_price;
@property (nonatomic, strong) NSString * rule;
@property (nonatomic, assign) NSInteger start_num;
@property (nonatomic, strong) NSString * start_time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;

@property (nonatomic, assign) BOOL isShowMore;

@end

NS_ASSUME_NONNULL_END
