//
//  MEAppointAttrModel.h
//  ME时代
//
//  Created by hank on 2018/10/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEAppointAttrModel : MEBaseModel

@property (nonatomic, strong) NSString * arrive_time;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger reserve_number;
@property (nonatomic, assign) NSInteger store_id;

//
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, assign) BOOL isFromStroe;
@property (nonatomic, assign) BOOL is_first_buy;//是否使用首次下1是0否
- (instancetype)initAttr;

@end
