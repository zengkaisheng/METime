//
//  MEAppointmentDetailVC.h
//  ME时代
//
//  Created by hank on 2018/9/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEAppointmentDetailVC : MEBaseVC

- (instancetype)initWithOrderreserve_sn:(NSString *)reserve_sn;
- (instancetype)initWithReserve_sn:(NSString *)reserve_sn userType:(MEClientTypeStyle)userType;

@end
