//
//  MEAddCustomerAppointmentModel.m
//  志愿星
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddCustomerAppointmentModel.h"

@implementation MEAddCustomerAppointmentModel

- (NSString *)token {
    return kMeUnNilStr(kCurrentUser.token);
}

@end
