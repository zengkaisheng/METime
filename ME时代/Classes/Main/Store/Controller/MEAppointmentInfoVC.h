//
//  MEAppointmentInfoVC.h
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MEServiceDetailsModel;
@class MEAppointAttrModel;
@interface MEAppointmentInfoVC : MEBaseVC

//有block 是是在预约订单里进去 没有责是第一次进去
@property (nonatomic, copy) kMeObjBlock block;
//- (instancetype)initWithAttrModel:(MEAppointAttrModel *)attrmodel;
- (instancetype)initWithAttrModel:(MEAppointAttrModel *)attrmodel serviceDetailModel:(MEServiceDetailsModel *)serviceDetailModel;

@end
