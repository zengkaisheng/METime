//
//  MEGroupUserContentModel.h
//  ME时代
//
//  Created by gao lei on 2019/7/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGroupUserContentModel : MEBaseModel

@property (nonatomic, strong) NSString * group_sn;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * group_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * over_time;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString * now;

@end

NS_ASSUME_NONNULL_END
