//
//  MERegisterVolunteerModel.m
//  志愿星
//
//  Created by gao lei on 2019/10/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERegisterVolunteerModel.h"

@implementation MERegisterVolunteerModel

- (NSString *)token {
    return kMeUnNilStr(kCurrentUser.token);
}

@end
