//
//  MEAddCustomerInformationModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddCustomerInformationModel.h"

@implementation MEAddCustomerInformationModel

MEModelIdToIdField

- (NSString *)token {
    return kMeUnNilStr(kCurrentUser.token);
}

@end
