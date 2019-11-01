//
//  MEMyBargainListModel.h
//  志愿星
//
//  Created by gao lei on 2019/6/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEMyBargainListModel : MEBaseModel

@property (nonatomic, strong) NSString * amount_money;
@property (nonatomic, assign) NSInteger bargin_count;
@property (nonatomic, assign) NSInteger bargin_id;
@property (nonatomic, assign) NSInteger bargin_num;
@property (nonatomic, assign) NSInteger bargin_status;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * end_time;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, assign) NSInteger over_time;
@property (nonatomic, strong) NSString * rule;
@property (nonatomic, assign) NSInteger start_num;
@property (nonatomic, strong) NSString * start_time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;

@end

NS_ASSUME_NONNULL_END
