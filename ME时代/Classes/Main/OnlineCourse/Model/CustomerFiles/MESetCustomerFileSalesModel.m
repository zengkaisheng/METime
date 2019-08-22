//
//  MESetCustomerFileSalesModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESetCustomerFileSalesModel.h"

@implementation MESetCustomerFileSalesModel

- (NSString *)token {
    return kMeUnNilStr(kCurrentUser.token);
}

@end
