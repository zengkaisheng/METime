//
//  MEMyAppointmentVC.h
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEMyAppointmentVC : MEBaseVC

- (instancetype)initWithType:(MEAppointmenyStyle)type;
- (instancetype)initWithType:(MEAppointmenyStyle)type userType:(MEClientTypeStyle)userType;

@end
