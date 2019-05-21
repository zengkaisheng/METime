//
//  MEAppointmentMakeOrderVC.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MEServiceDetailsModel;
@class MEAppointAttrModel;
@interface MEAppointmentMakeOrderVC : MEBaseVC

- (instancetype)initWithAttrModel:(MEAppointAttrModel *)attrModel serviceDetailModel:(MEServiceDetailsModel *)serviceDetailModel;

@end
