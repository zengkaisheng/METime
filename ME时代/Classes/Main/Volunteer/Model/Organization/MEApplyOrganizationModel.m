//
//  MEApplyOrganizationModel.m
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEApplyOrganizationModel.h"

@implementation MEApplyOrganizationModel

- (NSString *)token {
    return kMeUnNilStr(kCurrentUser.token);
}

@end
